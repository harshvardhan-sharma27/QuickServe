package com.quickserve.dto;

import com.quickserve.pojo.Booking;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class ProviderDashboardDTO {
    private BigDecimal totalEarnings = BigDecimal.ZERO;
    private int totalBookings;
    private int pendingBookings;
    private int completedBookings;
    private double rating;
    private int activeServicesCount;
    private List<Booking> recentBookings = new ArrayList<>();

    public ProviderDashboardDTO() {}

    public BigDecimal getTotalEarnings() { return totalEarnings; }
    public void setTotalEarnings(BigDecimal totalEarnings) { this.totalEarnings = totalEarnings; }

    public int getTotalBookings() { return totalBookings; }
    public void setTotalBookings(int totalBookings) { this.totalBookings = totalBookings; }

    public int getPendingBookings() { return pendingBookings; }
    public void setPendingBookings(int pendingBookings) { this.pendingBookings = pendingBookings; }

    public int getCompletedBookings() { return completedBookings; }
    public void setCompletedBookings(int completedBookings) { this.completedBookings = completedBookings; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public int getActiveServicesCount() { return activeServicesCount; }
    public void setActiveServicesCount(int activeServicesCount) { this.activeServicesCount = activeServicesCount; }

    public List<Booking> getRecentBookings() { return recentBookings; }
    public void setRecentBookings(List<Booking> recentBookings) { this.recentBookings = recentBookings; }
}
