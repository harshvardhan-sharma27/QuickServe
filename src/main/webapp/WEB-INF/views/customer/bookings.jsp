<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.quickserve.pojo.Booking" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>

<div class="mb-4 d-flex justify-content-between align-items-center">
    <div>
        <h2 class="h3 fw-bold mb-1">My Bookings</h2>
        <span class="text-muted small">Track and manage all your scheduled and past service requests</span>
    </div>
    <a href="<%= request.getContextPath() %>/services" class="btn btn-primary-qs btn-sm">
        <i class="bi bi-plus-circle me-1"></i>Book Another Service
    </a>
</div>

<div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-5">
    <div class="table-responsive">
        <table class="table table-custom mb-0">
            <thead>
                <tr>
                    <th>Booking #</th>
                    <th>Provider</th>
                    <th>Date & Time</th>
                    <th>Amount</th>
                    <th>Status</th>
                    <th>Payment</th>
                    <th class="text-end">Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (bookings != null && !bookings.isEmpty()) {
                    for (Booking b : bookings) { %>
                    <tr>
                        <td class="fw-bold">#<%= b.getBookingId() %></td>
                        <td>
                            <div class="fw-bold text-dark"><%= b.getProviderBusinessName() %></div>
                            <div class="text-muted small text-truncate" style="max-width: 250px;"><%= b.getAddressDetails() %></div>
                        </td>
                        <td>
                            <div class="fw-semibold"><%= b.getBookingDate() %></div>
                            <div class="text-muted small"><%= b.getBookingTime() %></div>
                        </td>
                        <td class="fw-bold fs-6">&#8377;<%= b.getTotalAmount() %></td>
                        <td>
                            <span class="badge-status <%= b.getStatus() %>"><%= b.getStatus() %></span>
                        </td>
                        <td>
                            <span class="badge <%= "SUCCESS".equalsIgnoreCase(b.getPaymentStatus()) ? "bg-success" : "bg-warning text-dark" %>">
                                <%= b.getPaymentStatus() %> (<%= b.getPaymentMethod() %>)
                            </span>
                        </td>
                        <td class="text-end">
                            <div class="d-inline-flex gap-1">
                                <a href="<%= request.getContextPath() %>/customer/booking-details?id=<%= b.getBookingId() %>" class="btn btn-sm btn-outline-primary" title="View Details">
                                    <i class="bi bi-eye"></i> Details
                                </a>

                                <% if ("PENDING".equalsIgnoreCase(b.getPaymentStatus())) { %>
                                    <a href="<%= request.getContextPath() %>/customer/payment?bookingId=<%= b.getBookingId() %>" class="btn btn-sm btn-success" title="Pay Now">
                                        <i class="bi bi-credit-card"></i> Pay
                                    </a>
                                <% } %>

                                <% if ("PENDING".equalsIgnoreCase(b.getStatus()) || "CONFIRMED".equalsIgnoreCase(b.getStatus())) { %>
                                    <a href="<%= request.getContextPath() %>/customer/bookings?cancelId=<%= b.getBookingId() %>" 
                                       class="btn btn-sm btn-outline-danger" 
                                       onclick="return confirm('Are you sure you want to cancel booking #' + <%= b.getBookingId() %> + '?');"
                                       title="Cancel Booking">
                                        <i class="bi bi-x-circle"></i> Cancel
                                    </a>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr>
                        <td colspan="7" class="text-center py-5 text-muted">
                            <i class="bi bi-calendar-x fs-1 opacity-50 mb-2 d-block"></i>
                            <h6 class="fw-bold">No bookings found</h6>
                            <p class="small text-muted mb-3">You haven't scheduled any services yet.</p>
                            <a href="<%= request.getContextPath() %>/services" class="btn btn-primary-qs btn-sm">Explore Services</a>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
