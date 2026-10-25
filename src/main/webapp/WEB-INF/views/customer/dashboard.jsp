<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickserve.dto.CustomerDashboardDTO" %>
<%@ page import="com.quickserve.pojo.Booking" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    CustomerDashboardDTO dash = (CustomerDashboardDTO) request.getAttribute("dashboard");
%>

<div class="mb-4">
    <h2 class="h3 fw-bold mb-1">Hello, <%= currentUser.getFullName() %>! 👋</h2>
    <p class="text-muted small">Welcome to your QuickServe customer dashboard. Manage your active services and appointments.</p>
</div>

<!-- Metrics Cards -->
<div class="row g-3 mb-4">
    <div class="col-md-4">
        <div class="stat-card">
            <div class="stat-icon primary">
                <i class="bi bi-clock-history"></i>
            </div>
            <div>
                <div class="stat-number"><%= (dash != null) ? dash.getActiveBookingsCount() : 0 %></div>
                <div class="stat-label">Active / Upcoming Bookings</div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="stat-card">
            <div class="stat-icon success">
                <i class="bi bi-check2-circle"></i>
            </div>
            <div>
                <div class="stat-number"><%= (dash != null) ? dash.getCompletedBookingsCount() : 0 %></div>
                <div class="stat-label">Completed Services</div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="stat-card">
            <div class="stat-icon warning">
                <i class="bi bi-bell"></i>
            </div>
            <div>
                <div class="stat-number"><%= (dash != null) ? dash.getUnreadNotificationsCount() : 0 %></div>
                <div class="stat-label">Unread Notifications</div>
            </div>
        </div>
    </div>
</div>

<!-- Recent Bookings Table -->
<div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
    <div class="card-header bg-white py-3 px-4 d-flex justify-content-between align-items-center border-bottom">
        <h5 class="fw-bold mb-0">Recent Bookings</h5>
        <a href="<%= request.getContextPath() %>/customer/bookings" class="btn btn-outline-qs btn-sm">View All History</a>
    </div>

    <div class="table-responsive">
        <table class="table table-custom mb-0">
            <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Provider</th>
                    <th>Date & Time</th>
                    <th>Total</th>
                    <th>Status</th>
                    <th>Payment</th>
                    <th class="text-end">Action</th>
                </tr>
            </thead>
            <tbody>
                <% if (dash != null && dash.getRecentBookings() != null && !dash.getRecentBookings().isEmpty()) {
                    for (Booking b : dash.getRecentBookings()) { %>
                    <tr>
                        <td class="fw-bold">#<%= b.getBookingId() %></td>
                        <td>
                            <div class="fw-semibold text-dark"><%= b.getProviderBusinessName() %></div>
                            <div class="text-muted small"><%= b.getAddressDetails() %></div>
                        </td>
                        <td>
                            <div><%= b.getBookingDate() %></div>
                            <div class="text-muted small"><%= b.getBookingTime() %></div>
                        </td>
                        <td class="fw-bold">&#8377;<%= b.getTotalAmount() %></td>
                        <td>
                            <span class="badge-status <%= b.getStatus() %>"><%= b.getStatus() %></span>
                        </td>
                        <td>
                            <span class="badge <%= "SUCCESS".equalsIgnoreCase(b.getPaymentStatus()) ? "bg-success" : "bg-warning text-dark" %>">
                                <%= b.getPaymentStatus() %> (<%= b.getPaymentMethod() %>)
                            </span>
                        </td>
                        <td class="text-end">
                            <a href="<%= request.getContextPath() %>/customer/booking-details?id=<%= b.getBookingId() %>" class="btn btn-outline-primary btn-sm">
                                Details
                            </a>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr>
                        <td colspan="7" class="text-center py-4 text-muted">
                            You have no recent bookings. <a href="<%= request.getContextPath() %>/services">Book a service now!</a>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Quick Shortcuts -->
<div class="row g-3">
    <div class="col-md-4">
        <a href="<%= request.getContextPath() %>/services" class="card border-0 shadow-sm rounded-4 p-3 text-decoration-none text-dark d-flex align-items-center gap-3">
            <div class="stat-icon primary m-0" style="width: 44px; height: 44px; font-size: 1.3rem;"><i class="bi bi-search"></i></div>
            <div>
                <div class="fw-bold">Book New Service</div>
                <div class="text-muted small">Explore electrician, plumber, cleaner</div>
            </div>
        </a>
    </div>
    <div class="col-md-4">
        <a href="<%= request.getContextPath() %>/customer/addresses" class="card border-0 shadow-sm rounded-4 p-3 text-decoration-none text-dark d-flex align-items-center gap-3">
            <div class="stat-icon secondary m-0" style="width: 44px; height: 44px; font-size: 1.3rem;"><i class="bi bi-geo-alt"></i></div>
            <div>
                <div class="fw-bold">Saved Addresses</div>
                <div class="text-muted small">Manage home & office delivery addresses</div>
            </div>
        </a>
    </div>
    <div class="col-md-4">
        <a href="<%= request.getContextPath() %>/customer/support" class="card border-0 shadow-sm rounded-4 p-3 text-decoration-none text-dark d-flex align-items-center gap-3">
            <div class="stat-icon warning m-0" style="width: 44px; height: 44px; font-size: 1.3rem;"><i class="bi bi-question-circle"></i></div>
            <div>
                <div class="fw-bold">Customer Support</div>
                <div class="text-muted small">Raise inquiries or complaints</div>
            </div>
        </a>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
