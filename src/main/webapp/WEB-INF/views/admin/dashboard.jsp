<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickserve.dto.DashboardDTO" %>
<%@ page import="com.quickserve.pojo.Booking" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    DashboardDTO stats = (DashboardDTO) request.getAttribute("stats");
    if (stats == null) { stats = new DashboardDTO(); }
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 fw-bold mb-1">Admin Dashboard</h1>
        <p class="text-muted mb-0">Platform overview &amp; real-time analytics</p>
    </div>
    <span class="badge bg-danger bg-opacity-15 text-danger fw-bold px-3 py-2 rounded-3">
        <i class="bi bi-shield-lock-fill me-1"></i>Admin Panel
    </span>
</div>

<!-- Stats Cards -->
<div class="row g-4 mb-4">
    <div class="col-6 col-md-4 col-lg-2">
        <div class="p-3 bg-white rounded-3 border shadow-sm text-center h-100">
            <div class="stat-icon primary mx-auto mb-2" style="width:48px;height:48px;font-size:1.3rem;">
                <i class="bi bi-people-fill"></i>
            </div>
            <div class="h4 fw-bold mb-0 text-primary"><%= stats.getTotalCustomers() %></div>
            <div class="small text-muted">Customers</div>
        </div>
    </div>
    <div class="col-6 col-md-4 col-lg-2">
        <div class="p-3 bg-white rounded-3 border shadow-sm text-center h-100">
            <div class="stat-icon secondary mx-auto mb-2" style="width:48px;height:48px;font-size:1.3rem;">
                <i class="bi bi-briefcase-fill"></i>
            </div>
            <div class="h4 fw-bold mb-0" style="color:var(--secondary)"><%= stats.getTotalProviders() %></div>
            <div class="small text-muted">Providers</div>
        </div>
    </div>
    <div class="col-6 col-md-4 col-lg-2">
        <div class="p-3 bg-white rounded-3 border shadow-sm text-center h-100">
            <div class="stat-icon warning mx-auto mb-2" style="width:48px;height:48px;font-size:1.3rem;">
                <i class="bi bi-calendar-check-fill"></i>
            </div>
            <div class="h4 fw-bold mb-0 text-warning"><%= stats.getTotalBookings() %></div>
            <div class="small text-muted">Bookings</div>
        </div>
    </div>
    <div class="col-6 col-md-4 col-lg-2">
        <div class="p-3 bg-white rounded-3 border shadow-sm text-center h-100">
            <div class="stat-icon success mx-auto mb-2" style="width:48px;height:48px;font-size:1.3rem;">
                <i class="bi bi-currency-rupee"></i>
            </div>
            <div class="h4 fw-bold mb-0 text-success">&#8377;<%= stats.getTotalRevenue() != null ? stats.getTotalRevenue().toPlainString() : "0" %></div>
            <div class="small text-muted">Revenue</div>
        </div>
    </div>
    <div class="col-6 col-md-4 col-lg-2">
        <div class="p-3 bg-white rounded-3 border shadow-sm text-center h-100">
            <div class="stat-icon" style="width:48px;height:48px;font-size:1.3rem;background:var(--warning-soft);color:var(--warning)" class="mx-auto mb-2">
                <i class="bi bi-hourglass-split"></i>
            </div>
            <div class="h4 fw-bold mb-0 text-warning"><%= stats.getPendingBookings() %></div>
            <div class="small text-muted">Pending</div>
        </div>
    </div>
    <div class="col-6 col-md-4 col-lg-2">
        <div class="p-3 bg-white rounded-3 border shadow-sm text-center h-100">
            <div style="width:48px;height:48px;font-size:1.3rem;background:var(--danger-soft);color:var(--danger);border-radius:12px;display:flex;align-items:center;justify-content:center;" class="mx-auto mb-2">
                <i class="bi bi-chat-left-dots-fill"></i>
            </div>
            <div class="h4 fw-bold mb-0 text-danger"><%= stats.getOpenTickets() %></div>
            <div class="small text-muted">Open Tickets</div>
        </div>
    </div>
</div>

<!-- Quick Links -->
<div class="row g-3 mb-4">
    <div class="col-12">
        <div class="bg-white rounded-3 border p-4 shadow-sm">
            <h5 class="fw-bold mb-3"><i class="bi bi-grid-3x3-gap me-2 text-primary"></i>Quick Actions</h5>
            <div class="d-flex flex-wrap gap-2">
                <a href="<%= cp %>/admin/users" class="btn btn-outline-primary btn-sm"><i class="bi bi-people me-1"></i>Manage Users</a>
                <a href="<%= cp %>/admin/providers" class="btn btn-outline-secondary btn-sm"><i class="bi bi-patch-check me-1"></i>Manage Providers</a>
                <a href="<%= cp %>/admin/bookings" class="btn btn-outline-warning btn-sm"><i class="bi bi-calendar-event me-1"></i>All Bookings</a>
                <a href="<%= cp %>/admin/categories" class="btn btn-outline-success btn-sm"><i class="bi bi-tags me-1"></i>Categories</a>
                <a href="<%= cp %>/admin/services" class="btn btn-outline-info btn-sm"><i class="bi bi-gear me-1"></i>Services</a>
                <a href="<%= cp %>/admin/payments" class="btn btn-outline-dark btn-sm"><i class="bi bi-credit-card me-1"></i>Payments</a>
                <a href="<%= cp %>/admin/support" class="btn btn-outline-danger btn-sm"><i class="bi bi-headset me-1"></i>Support Tickets</a>
            </div>
        </div>
    </div>
</div>

<!-- Recent Bookings & Top Services -->
<div class="row g-4">
    <div class="col-lg-8">
        <div class="bg-white rounded-3 border shadow-sm p-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold mb-0"><i class="bi bi-clock-history me-2 text-primary"></i>Recent Bookings</h5>
                <a href="<%= cp %>/admin/bookings" class="btn btn-outline-qs btn-sm">View All</a>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr><th>#ID</th><th>Customer</th><th>Provider</th><th>Amount</th><th>Status</th><th>Date</th></tr>
                    </thead>
                    <tbody>
                        <% if (stats.getRecentBookings() != null && !stats.getRecentBookings().isEmpty()) {
                            for (Booking b : stats.getRecentBookings()) { %>
                        <tr>
                            <td><span class="badge bg-light text-dark border">#<%= b.getBookingId() %></span></td>
                            <td><span class="fw-semibold"><%= b.getCustomerName() != null ? b.getCustomerName() : "—" %></span></td>
                            <td class="text-muted small"><%= b.getProviderBusinessName() != null ? b.getProviderBusinessName() : "—" %></td>
                            <td class="fw-bold text-success">&#8377;<%= b.getTotalAmount() %></td>
                            <td>
                                <% String bStatus = b.getStatus() != null ? b.getStatus() : ""; %>
                                <span class="badge bg-<%= "COMPLETED".equals(bStatus) ? "success" : "CANCELLED".equals(bStatus) ? "danger" : "PENDING".equals(bStatus) ? "warning text-dark" : "info" %> bg-opacity-15 text-<%= "COMPLETED".equals(bStatus) ? "success" : "CANCELLED".equals(bStatus) ? "danger" : "PENDING".equals(bStatus) ? "warning" : "info" %> fw-semibold">
                                    <%= bStatus %>
                                </span>
                            </td>
                            <td class="text-muted small"><%= b.getBookingDate() != null ? b.getBookingDate().toString() : "—" %></td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="6" class="text-center text-muted py-4">No recent bookings</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="bg-white rounded-3 border shadow-sm p-4">
            <h5 class="fw-bold mb-3"><i class="bi bi-bar-chart-fill me-2 text-warning"></i>Top Services</h5>
            <% if (stats.getTopServices() != null && !stats.getTopServices().isEmpty()) {
                for (Map<String, Object> svc : stats.getTopServices()) { %>
            <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                <span class="fw-semibold text-truncate me-2" style="max-width:160px"><%= svc.get("serviceName") %></span>
                <span class="badge bg-primary bg-opacity-10 text-primary fw-bold"><%= svc.get("bookingCount") %> bookings</span>
            </div>
            <% } } else { %>
            <div class="text-muted small py-4 text-center">No data yet</div>
            <% } %>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
