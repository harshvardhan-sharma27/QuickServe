package com.quickserve.service.impl;

import com.quickserve.dao.*;
import com.quickserve.dao.impl.*;
import com.quickserve.dto.CustomerDashboardDTO;
import com.quickserve.exception.BookingException;
import com.quickserve.exception.ServiceException;
import com.quickserve.pojo.Booking;
import com.quickserve.pojo.BookingItem;
import com.quickserve.pojo.Service;
import com.quickserve.service.BookingService;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

public class BookingServiceImpl implements BookingService {

    private final BookingDAO bookingDAO = new BookingDAOImpl();
    private final ServiceDAO serviceDAO = new ServiceDAOImpl();
    private final NotificationDAO notificationDAO = new NotificationDAOImpl();

    @Override
    public int createBooking(int customerId, int providerId, int addressId, Date bookingDate, Time bookingTime, List<Integer> serviceIds, String paymentMethod, String notes, Integer availabilityId) {
        if (customerId <= 0) throw new BookingException("Invalid customer.");
        if (providerId <= 0) throw new BookingException("Invalid provider.");
        if (addressId <= 0) throw new BookingException("Please select a delivery address.");
        if (bookingDate == null) throw new BookingException("Booking date is required.");
        if (serviceIds == null || serviceIds.isEmpty()) throw new BookingException("Please select at least one service.");

        List<BookingItem> items = new ArrayList<>();
        BigDecimal totalAmount = BigDecimal.ZERO;

        for (Integer sId : serviceIds) {
            Service s = serviceDAO.findById(sId);
            if (s == null) {
                throw new BookingException("Selected service was not found.");
            }
            if (s.getProviderId() != providerId) {
                throw new BookingException("All selected services must belong to the chosen provider.");
            }
            BookingItem item = new BookingItem();
            item.setServiceId(s.getServiceId());
            item.setQuantity(1);
            item.setUnitPrice(s.getPrice());
            items.add(item);

            totalAmount = totalAmount.add(s.getPrice());
        }

        Booking booking = new Booking();
        booking.setCustomerId(customerId);
        booking.setProviderId(providerId);
        booking.setAddressId(addressId);
        booking.setBookingDate(bookingDate);
        booking.setBookingTime(bookingTime != null ? bookingTime : Time.valueOf("10:00:00"));
        booking.setTotalAmount(totalAmount);
        booking.setNotes(notes);

        return bookingDAO.createBookingTransaction(booking, items, paymentMethod, availabilityId);
    }

    @Override
    public Booking getBookingDetails(int bookingId) {
        return bookingDAO.findById(bookingId);
    }

    @Override
    public List<Booking> getCustomerBookings(int customerId) {
        return bookingDAO.findByCustomer(customerId);
    }

    @Override
    public List<Booking> getProviderBookings(int providerId) {
        return bookingDAO.findByProvider(providerId);
    }

    @Override
    public List<Booking> getAllBookings(String statusFilter, int page, int pageSize) {
        int safePage = Math.max(page, 1);
        int safePageSize = (pageSize > 0) ? pageSize : 20;
        int offset = (safePage - 1) * safePageSize;
        return bookingDAO.findAll(statusFilter, safePageSize, offset);
    }

    @Override
    public int getTotalBookingsCount(String statusFilter) {
        return bookingDAO.countAll(statusFilter);
    }

    @Override
    public boolean updateBookingStatus(int bookingId, String newStatus, int currentUserId, String currentRole) {
        Booking b = bookingDAO.findById(bookingId);
        if (b == null) throw new ServiceException("Booking not found.");

        if ("PROVIDER".equalsIgnoreCase(currentRole) && b.getProviderId() != currentUserId) {
            throw new ServiceException("Unauthorized: You can only update bookings assigned to you.");
        }

        boolean updated = bookingDAO.updateStatus(bookingId, newStatus);
        if (updated) {
            notificationDAO.create(b.getCustomerId(), "Your booking #" + bookingId + " status was updated to: " + newStatus);
        }
        return updated;
    }

    @Override
    public boolean cancelBooking(int bookingId, int customerId) {
        Booking b = bookingDAO.findById(bookingId);
        if (b == null || b.getCustomerId() != customerId) {
            throw new ServiceException("Booking not found or not owned by user.");
        }
        boolean cancelled = bookingDAO.cancelBooking(bookingId, customerId);
        if (cancelled) {
            notificationDAO.create(b.getProviderId(), "Booking #" + bookingId + " has been cancelled by customer.");
        }
        return cancelled;
    }

    @Override
    public CustomerDashboardDTO getCustomerDashboard(int customerId) {
        CustomerDashboardDTO dto = new CustomerDashboardDTO();
        dto.setActiveBookingsCount(bookingDAO.countByCustomer(customerId, "CONFIRMED") + bookingDAO.countByCustomer(customerId, "IN_PROGRESS") + bookingDAO.countByCustomer(customerId, "PENDING"));
        dto.setCompletedBookingsCount(bookingDAO.countByCustomer(customerId, "COMPLETED"));
        dto.setUnreadNotificationsCount(notificationDAO.getUnreadCount(customerId));

        List<Booking> bookings = bookingDAO.findByCustomer(customerId);
        if (bookings.size() > 5) {
            dto.setRecentBookings(bookings.subList(0, 5));
        } else {
            dto.setRecentBookings(bookings);
        }
        return dto;
    }
}
