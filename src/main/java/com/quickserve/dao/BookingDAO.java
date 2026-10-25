package com.quickserve.dao;

import com.quickserve.pojo.Booking;
import com.quickserve.pojo.BookingItem;
import java.util.List;

public interface BookingDAO {
    int createBookingTransaction(Booking booking, List<BookingItem> items, String paymentMethod, Integer availabilityId);
    Booking findById(int bookingId);
    List<Booking> findByCustomer(int customerId);
    List<Booking> findByProvider(int providerId);
    List<Booking> findAll(String statusFilter, int limit, int offset);
    int countAll(String statusFilter);
    boolean updateStatus(int bookingId, String status);
    boolean cancelBooking(int bookingId, int customerId);
    int countByCustomer(int customerId, String status);
    int countByProvider(int providerId, String status);
    List<Booking> findRecentBookings(int limit);
}
