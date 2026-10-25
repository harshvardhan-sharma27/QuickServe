package com.quickserve.dto;

import com.quickserve.pojo.Booking;
import java.util.ArrayList;
import java.util.List;

public class CustomerDashboardDTO {
    private int activeBookingsCount;
    private int completedBookingsCount;
    private int unreadNotificationsCount;
    private List<Booking> recentBookings = new ArrayList<>();

    public CustomerDashboardDTO() {}

    public int getActiveBookingsCount() { return activeBookingsCount; }
    public void setActiveBookingsCount(int activeBookingsCount) { this.activeBookingsCount = activeBookingsCount; }

    public int getCompletedBookingsCount() { return completedBookingsCount; }
    public void setCompletedBookingsCount(int completedBookingsCount) { this.completedBookingsCount = completedBookingsCount; }

    public int getUnreadNotificationsCount() { return unreadNotificationsCount; }
    public void setUnreadNotificationsCount(int unreadNotificationsCount) { this.unreadNotificationsCount = unreadNotificationsCount; }

    public List<Booking> getRecentBookings() { return recentBookings; }
    public void setRecentBookings(List<Booking> recentBookings) { this.recentBookings = recentBookings; }
}
