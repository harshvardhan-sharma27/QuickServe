package com.quickserve.dto;

import com.quickserve.pojo.Booking;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardDTO {
    private int totalCustomers;
    private int totalProviders;
    private int totalBookings;
    private BigDecimal totalRevenue = BigDecimal.ZERO;
    private int pendingBookings;
    private int openTickets;

    private List<Map<String, Object>> topServices = new ArrayList<>();
    private List<Map<String, Object>> monthlyRevenue = new ArrayList<>();
    private List<Booking> recentBookings = new ArrayList<>();

    public DashboardDTO() {}

    public int getTotalCustomers() { return totalCustomers; }
    public void setTotalCustomers(int totalCustomers) { this.totalCustomers = totalCustomers; }

    public int getTotalProviders() { return totalProviders; }
    public void setTotalProviders(int totalProviders) { this.totalProviders = totalProviders; }

    public int getTotalBookings() { return totalBookings; }
    public void setTotalBookings(int totalBookings) { this.totalBookings = totalBookings; }

    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }

    public int getPendingBookings() { return pendingBookings; }
    public void setPendingBookings(int pendingBookings) { this.pendingBookings = pendingBookings; }

    public int getOpenTickets() { return openTickets; }
    public void setOpenTickets(int openTickets) { this.openTickets = openTickets; }

    public List<Map<String, Object>> getTopServices() { return topServices; }
    public void setTopServices(List<Map<String, Object>> topServices) { this.topServices = topServices; }

    public List<Map<String, Object>> getMonthlyRevenue() { return monthlyRevenue; }
    public void setMonthlyRevenue(List<Map<String, Object>> monthlyRevenue) { this.monthlyRevenue = monthlyRevenue; }

    public List<Booking> getRecentBookings() { return recentBookings; }
    public void setRecentBookings(List<Booking> recentBookings) { this.recentBookings = recentBookings; }
}
