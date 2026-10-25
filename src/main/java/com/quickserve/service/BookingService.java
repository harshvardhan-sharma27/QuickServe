package com.quickserve.service;

import com.quickserve.dto.CustomerDashboardDTO;
import com.quickserve.pojo.Booking;

import java.sql.Date;
import java.sql.Time;
import java.util.List;

public interface BookingService {
    int createBooking(int customerId, int providerId, int addressId, Date bookingDate, Time bookingTime, List<Integer> serviceIds, String paymentMethod, String notes, Integer availabilityId);
    Booking getBookingDetails(int bookingId);
    List<Booking> getCustomerBookings(int customerId);
    List<Booking> getProviderBookings(int providerId);
    List<Booking> getAllBookings(String statusFilter, int page, int pageSize);
    int getTotalBookingsCount(String statusFilter);
    boolean updateBookingStatus(int bookingId, String newStatus, int currentUserId, String currentRole);
    boolean cancelBooking(int bookingId, int customerId);
    CustomerDashboardDTO getCustomerDashboard(int customerId);
}
