<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickserve.pojo.Booking, java.util.List" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    String selectedFilter = (String) request.getAttribute("selectedFilter");
    int totalBookings = request.getAttribute("totalBookings") != null ? (Integer) request.getAttribute("totalBookings") : 0;
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 fw-bold mb-1">All Bookings</h1>
        <p class="text-muted mb-0">Manage and track all platform bookings</p>
    </div>
    <span class="badge bg-primary bg-opacity-10 text-primary fw-bold px-3 py-2 rounded-3"><%= totalBookings %> total</span>
</div>

<!-- Status Filter Tabs -->
<div class="bg-white rounded-3 border shadow-sm p-3 mb-4">
    <div class="d-flex flex-wrap gap-2">
        <a href="<%= cp %>/admin/bookings" class="btn btn-sm <%= selectedFilter == null ? "btn-primary-qs" : "btn-outline-secondary" %>">All</a>
        <a href="<%= cp %>/admin/bookings?filter=PENDING" class="btn btn-sm <%= "PENDING".equals(selectedFilter) ? "btn-warning text-dark" : "btn-outline-warning" %>">Pending</a>
        <a href="<%= cp %>/admin/bookings?filter=CONFIRMED" class="btn btn-sm <%= "CONFIRMED".equals(selectedFilter) ? "btn-info" : "btn-outline-info" %>">Confirmed</a>
        <a href="<%= cp %>/admin/bookings?filter=IN_PROGRESS" class="btn btn-sm <%= "IN_PROGRESS".equals(selectedFilter) ? "btn-primary" : "btn-outline-primary" %>">In Progress</a>
        <a href="<%= cp %>/admin/bookings?filter=COMPLETED" class="btn btn-sm <%= "COMPLETED".equals(selectedFilter) ? "btn-success" : "btn-outline-success" %>">Completed</a>
        <a href="<%= cp %>/admin/bookings?filter=CANCELLED" class="btn btn-sm <%= "CANCELLED".equals(selectedFilter) ? "btn-danger" : "btn-outline-danger" %>">Cancelled</a>
    </div>
</div>

<div class="bg-white rounded-3 border shadow-sm p-4">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
                <tr>
                    <th>#ID</th><th>Customer</th><th>Provider</th><th>Date</th><th>Amount</th>
                    <th>Payment</th><th>Status</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (bookings != null && !bookings.isEmpty()) {
                    for (Booking b : bookings) {
                        String bStatus = b.getStatus() != null ? b.getStatus() : "PENDING"; %>
                <tr>
                    <td><a href="<%= cp %>/customer/booking-details?id=<%= b.getBookingId() %>" class="badge bg-light text-dark border text-decoration-none">#<%= b.getBookingId() %></a></td>
                    <td class="fw-semibold"><%= b.getCustomerName() != null ? b.getCustomerName() : "—" %></td>
                    <td class="text-muted small"><%= b.getProviderBusinessName() != null ? b.getProviderBusinessName() : "—" %></td>
                    <td class="text-muted small"><%= b.getBookingDate() != null ? b.getBookingDate().toString() : "—" %></td>
                    <td class="fw-bold text-success">&#8377;<%= b.getTotalAmount() %></td>
                    <td class="text-muted small"><%= b.getPaymentMethod() != null ? b.getPaymentMethod() : "—" %></td>
                    <td>
                        <span class="badge bg-<%= "COMPLETED".equals(bStatus) ? "success" : "CANCELLED".equals(bStatus) ? "danger" : "PENDING".equals(bStatus) ? "warning text-dark" : "CONFIRMED".equals(bStatus) ? "info" : "primary" %> bg-opacity-15 text-<%= "COMPLETED".equals(bStatus) ? "success" : "CANCELLED".equals(bStatus) ? "danger" : "PENDING".equals(bStatus) ? "warning" : "CONFIRMED".equals(bStatus) ? "info" : "primary" %> fw-semibold">
                            <%= bStatus %>
                        </span>
                    </td>
                    <td>
                        <% if (!"COMPLETED".equals(bStatus) && !"CANCELLED".equals(bStatus)) { %>
                        <div class="dropdown">
                            <button class="btn btn-outline-secondary btn-sm dropdown-toggle py-0 px-2" data-bs-toggle="dropdown">Change</button>
                            <ul class="dropdown-menu shadow border-0">
                                <li><a class="dropdown-item small" href="<%= cp %>/admin/bookings?action=update&id=<%= b.getBookingId() %>&status=CONFIRMED">Confirm</a></li>
                                <li><a class="dropdown-item small" href="<%= cp %>/admin/bookings?action=update&id=<%= b.getBookingId() %>&status=IN_PROGRESS">In Progress</a></li>
                                <li><a class="dropdown-item small" href="<%= cp %>/admin/bookings?action=update&id=<%= b.getBookingId() %>&status=COMPLETED">Complete</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item small text-danger" href="<%= cp %>/admin/bookings?action=update&id=<%= b.getBookingId() %>&status=CANCELLED" onclick="return confirm('Cancel this booking?')">Cancel</a></li>
                            </ul>
                        </div>
                        <% } else { %>
                        <span class="text-muted small">—</span>
                        <% } %>
                    </td>
                </tr>
                <% } } else { %>
                <tr><td colspan="8" class="text-center text-muted py-4">No bookings found</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
