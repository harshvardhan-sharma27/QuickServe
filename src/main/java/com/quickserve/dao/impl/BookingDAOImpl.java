package com.quickserve.dao.impl;

import com.quickserve.dao.BookingDAO;
import com.quickserve.exception.BookingException;
import com.quickserve.exception.DAOException;
import com.quickserve.mapper.ResultSetMapper;
import com.quickserve.pojo.Booking;
import com.quickserve.pojo.BookingItem;
import com.quickserve.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class BookingDAOImpl implements BookingDAO {

    private static final String BASE_JOIN_QUERY =
        "SELECT b.*, " +
        "u.full_name AS customer_name, u.email AS customer_email, u.phone AS customer_phone, " +
        "p.business_name, pu.phone AS provider_phone, " +
        "CONCAT(a.address_line, ', ', a.city, ' - ', a.pincode) AS address_details, " +
        "pay.payment_status, pay.payment_method, pay.transaction_reference, " +
        "r.rating, r.comment AS review_comment " +
        "FROM bookings b " +
        "INNER JOIN users u ON b.customer_id = u.user_id " +
        "INNER JOIN provider_profiles p ON b.provider_id = p.provider_id " +
        "INNER JOIN users pu ON p.provider_id = pu.user_id " +
        "INNER JOIN addresses a ON b.address_id = a.address_id " +
        "LEFT JOIN payments pay ON b.booking_id = pay.booking_id " +
        "LEFT JOIN reviews r ON b.booking_id = r.booking_id ";

    @Override
    public int createBookingTransaction(Booking booking, List<BookingItem> items, String paymentMethod, Integer availabilityId) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // BEGIN TRANSACTION

            // 1. Insert Booking
            String bookingSql = "INSERT INTO bookings (customer_id, provider_id, address_id, booking_date, booking_time, total_amount, status, notes) " +
                                "VALUES (?, ?, ?, ?, ?, ?, 'PENDING', ?)";
            int generatedBookingId;
            try (PreparedStatement psBooking = con.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS)) {
                psBooking.setInt(1, booking.getCustomerId());
                psBooking.setInt(2, booking.getProviderId());
                psBooking.setInt(3, booking.getAddressId());
                psBooking.setDate(4, booking.getBookingDate());
                psBooking.setTime(5, booking.getBookingTime());
                psBooking.setBigDecimal(6, booking.getTotalAmount());
                psBooking.setString(7, booking.getNotes());

                int affected = psBooking.executeUpdate();
                if (affected == 0) {
                    throw new SQLException("Failed to insert booking record.");
                }
                try (ResultSet rs = psBooking.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedBookingId = rs.getInt(1);
                        booking.setBookingId(generatedBookingId);
                    } else {
                        throw new SQLException("Failed to retrieve generated booking ID.");
                    }
                }
            }

            // 2. Insert Booking Items
            String itemSql = "INSERT INTO booking_items (booking_id, service_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
            try (PreparedStatement psItem = con.prepareStatement(itemSql)) {
                for (BookingItem item : items) {
                    psItem.setInt(1, generatedBookingId);
                    psItem.setInt(2, item.getServiceId());
                    psItem.setInt(3, item.getQuantity() > 0 ? item.getQuantity() : 1);
                    psItem.setBigDecimal(4, item.getUnitPrice());
                    psItem.addBatch();
                }
                psItem.executeBatch();
            }

            // 3. Mark Provider Availability as BOOKED if availabilityId was supplied
            if (availabilityId != null && availabilityId > 0) {
                String slotSql = "UPDATE provider_availability SET status = 'BOOKED' WHERE availability_id = ? AND provider_id = ?";
                try (PreparedStatement psSlot = con.prepareStatement(slotSql)) {
                    psSlot.setInt(1, availabilityId);
                    psSlot.setInt(2, booking.getProviderId());
                    psSlot.executeUpdate();
                }
            }

            // 4. Create Initial Payment record
            String paySql = "INSERT INTO payments (booking_id, transaction_reference, amount, payment_method, payment_status, paid_at) " +
                            "VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement psPay = con.prepareStatement(paySql)) {
                String txnRef = "TXN_" + System.currentTimeMillis() + "_" + (int)(Math.random() * 9000 + 1000);
                String payMethod = (paymentMethod != null && !paymentMethod.trim().isEmpty()) ? paymentMethod : "UPI";
                boolean isInstantSuccess = "UPI".equalsIgnoreCase(payMethod) || "CARD".equalsIgnoreCase(payMethod);
                String status = isInstantSuccess ? "SUCCESS" : "PENDING";
                Timestamp paidAt = isInstantSuccess ? new Timestamp(System.currentTimeMillis()) : null;

                psPay.setInt(1, generatedBookingId);
                psPay.setString(2, txnRef);
                psPay.setBigDecimal(3, booking.getTotalAmount());
                psPay.setString(4, payMethod);
                psPay.setString(5, status);
                psPay.setTimestamp(6, paidAt);
                psPay.executeUpdate();
            }

            // 5. Send Notification to Provider
            String notifSql = "INSERT INTO notifications (user_id, message) VALUES (?, ?)";
            try (PreparedStatement psNotif = con.prepareStatement(notifSql)) {
                psNotif.setInt(1, booking.getProviderId());
                psNotif.setString(2, "New booking #" + generatedBookingId + " received for date " + booking.getBookingDate() + ".");
                psNotif.executeUpdate();

                // Notification to Customer
                psNotif.setInt(1, booking.getCustomerId());
                psNotif.setString(2, "Your booking #" + generatedBookingId + " has been placed successfully!");
                psNotif.executeUpdate();
            }

            con.commit(); // COMMIT TRANSACTION
            return generatedBookingId;

        } catch (Exception e) {
            if (con != null) {
                try {
                    con.rollback(); // ROLLBACK ON FAILURE
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            throw new BookingException("Failed to complete booking transaction: " + e.getMessage(), e);
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException closeEx) {
                    closeEx.printStackTrace();
                }
            }
        }
    }

    @Override
    public Booking findById(int bookingId) {
        String sql = BASE_JOIN_QUERY + "WHERE b.booking_id = ?";
        Booking booking = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    booking = ResultSetMapper.mapBooking(rs);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error finding booking: " + bookingId, e);
        }

        if (booking != null) {
            booking.setItems(loadBookingItems(bookingId));
        }
        return booking;
    }

    private List<BookingItem> loadBookingItems(int bookingId) {
        List<BookingItem> items = new ArrayList<>();
        String sql = "SELECT bi.*, s.service_name FROM booking_items bi " +
                     "INNER JOIN services s ON bi.service_id = s.service_id " +
                     "WHERE bi.booking_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(ResultSetMapper.mapBookingItem(rs));
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error fetching items for booking: " + bookingId, e);
        }
        return items;
    }

    @Override
    public List<Booking> findByCustomer(int customerId) {
        List<Booking> list = new ArrayList<>();
        String sql = BASE_JOIN_QUERY + "WHERE b.customer_id = ? ORDER BY b.booking_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = ResultSetMapper.mapBooking(rs);
                    b.setItems(loadBookingItems(b.getBookingId()));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error finding bookings for customer: " + customerId, e);
        }
        return list;
    }

    @Override
    public List<Booking> findByProvider(int providerId) {
        List<Booking> list = new ArrayList<>();
        String sql = BASE_JOIN_QUERY + "WHERE b.provider_id = ? ORDER BY b.booking_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, providerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = ResultSetMapper.mapBooking(rs);
                    b.setItems(loadBookingItems(b.getBookingId()));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error finding bookings for provider: " + providerId, e);
        }
        return list;
    }

    @Override
    public List<Booking> findAll(String statusFilter, int limit, int offset) {
        List<Booking> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_JOIN_QUERY);
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("ALL")) {
            sql.append("WHERE b.status = ? ");
        }
        sql.append("ORDER BY b.booking_id DESC LIMIT ? OFFSET ?");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int idx = 1;
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("ALL")) {
                ps.setString(idx++, statusFilter);
            }
            ps.setInt(idx++, limit > 0 ? limit : 50);
            ps.setInt(idx++, Math.max(offset, 0));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = ResultSetMapper.mapBooking(rs);
                    b.setItems(loadBookingItems(b.getBookingId()));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error fetching bookings for admin", e);
        }
        return list;
    }

    @Override
    public int countAll(String statusFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM bookings ");
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("ALL")) {
            sql.append("WHERE status = ?");
        }
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("ALL")) {
                ps.setString(1, statusFilter);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new DAOException("Error counting bookings", e);
        }
        return 0;
    }

    @Override
    public boolean updateStatus(int bookingId, String status) {
        String sql = "UPDATE bookings SET status = ? WHERE booking_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error updating booking status", e);
        }
    }

    @Override
    public boolean cancelBooking(int bookingId, int customerId) {
        String sql = "UPDATE bookings SET status = 'CANCELLED' WHERE booking_id = ? AND customer_id = ? AND status IN ('PENDING', 'CONFIRMED')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, customerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error cancelling booking", e);
        }
    }

    @Override
    public int countByCustomer(int customerId, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM bookings WHERE customer_id = ? ");
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND status = ?");
        }
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            ps.setInt(1, customerId);
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(2, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new DAOException("Error counting customer bookings", e);
        }
        return 0;
    }

    @Override
    public int countByProvider(int providerId, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM bookings WHERE provider_id = ? ");
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND status = ?");
        }
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            ps.setInt(1, providerId);
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(2, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new DAOException("Error counting provider bookings", e);
        }
        return 0;
    }

    @Override
    public List<Booking> findRecentBookings(int limit) {
        List<Booking> list = new ArrayList<>();
        String sql = BASE_JOIN_QUERY + "ORDER BY b.booking_id DESC LIMIT ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = ResultSetMapper.mapBooking(rs);
                    b.setItems(loadBookingItems(b.getBookingId()));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error fetching recent bookings", e);
        }
        return list;
    }
}
