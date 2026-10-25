package com.quickserve.dao.impl;

import com.quickserve.dao.PaymentDAO;
import com.quickserve.exception.DAOException;
import com.quickserve.mapper.ResultSetMapper;
import com.quickserve.pojo.Payment;
import com.quickserve.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PaymentDAOImpl implements PaymentDAO {

    @Override
    public Payment findByBookingId(int bookingId) {
        String sql = "SELECT * FROM payments WHERE booking_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return ResultSetMapper.mapPayment(rs);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error finding payment for booking: " + bookingId, e);
        }
        return null;
    }

    @Override
    public boolean updateStatus(int bookingId, String status, String method, String txnRef) {
        String sql = "UPDATE payments SET payment_status = ?, payment_method = ?, transaction_reference = ?, paid_at = ? WHERE booking_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, method);
            ps.setString(3, txnRef);
            ps.setTimestamp(4, "SUCCESS".equalsIgnoreCase(status) ? new Timestamp(System.currentTimeMillis()) : null);
            ps.setInt(5, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error updating payment status for booking: " + bookingId, e);
        }
    }

    @Override
    public BigDecimal getTotalSuccessfulRevenue() {
        String sql = "SELECT SUM(amount) FROM payments WHERE payment_status = 'SUCCESS'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                BigDecimal sum = rs.getBigDecimal(1);
                return sum != null ? sum : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            throw new DAOException("Error calculating total revenue", e);
        }
        return BigDecimal.ZERO;
    }

    @Override
    public BigDecimal getProviderEarnings(int providerId) {
        String sql = "SELECT SUM(pay.amount) AS total_earnings " +
                     "FROM payments pay " +
                     "INNER JOIN bookings b ON pay.booking_id = b.booking_id " +
                     "WHERE pay.payment_status = 'SUCCESS' AND b.provider_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, providerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BigDecimal earnings = rs.getBigDecimal("total_earnings");
                    return earnings != null ? earnings : BigDecimal.ZERO;
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error calculating provider earnings: " + providerId, e);
        }
        return BigDecimal.ZERO;
    }

    @Override
    public List<Map<String, Object>> getMonthlyRevenue() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT MONTH(paid_at) AS pay_month, YEAR(paid_at) AS pay_year, SUM(amount) AS revenue " +
                     "FROM payments " +
                     "WHERE payment_status = 'SUCCESS' AND paid_at IS NOT NULL " +
                     "GROUP BY YEAR(paid_at), MONTH(paid_at) " +
                     "ORDER BY pay_year DESC, pay_month DESC LIMIT 6";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("month", rs.getInt("pay_month"));
                map.put("year", rs.getInt("pay_year"));
                map.put("revenue", rs.getBigDecimal("revenue"));
                list.add(map);
            }
        } catch (SQLException e) {
            throw new DAOException("Error fetching monthly revenue aggregation", e);
        }
        return list;
    }

    @Override
    public List<Payment> findAll() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT * FROM payments ORDER BY payment_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(ResultSetMapper.mapPayment(rs));
            }
        } catch (SQLException e) {
            throw new DAOException("Error fetching payments", e);
        }
        return list;
    }
}
