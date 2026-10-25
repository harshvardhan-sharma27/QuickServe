<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickserve.pojo.Booking, java.util.List, java.math.BigDecimal" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    BigDecimal totalEarnings = (BigDecimal) request.getAttribute("totalEarnings");
    List<Booking> paidBookings = (List<Booking>) request.getAttribute("paidBookings");
    if (totalEarnings == null) totalEarnings = BigDecimal.ZERO;
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 fw-bold mb-1">My Earnings</h1>
        <p class="text-muted mb-0">Track your income from completed services</p>
    </div>
</div>

<!-- Earnings Summary -->
<div class="row g-4 mb-4">
    <div class="col-md-4">
        <div class="p-4 bg-success bg-opacity-10 border border-success border-opacity-25 rounded-3 text-center h-100">
            <div class="text-success fw-bold text-uppercase small mb-1">Total Earned</div>
            <div class="display-6 fw-bold text-success">&#8377;<%= totalEarnings.toPlainString() %></div>
            <div class="text-muted small mt-1">Lifetime earnings</div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="p-4 bg-primary bg-opacity-10 border border-primary border-opacity-25 rounded-3 text-center h-100">
            <div class="text-primary fw-bold text-uppercase small mb-1">Paid Jobs</div>
            <div class="display-6 fw-bold text-primary"><%= paidBookings != null ? paidBookings.size() : 0 %></div>
            <div class="text-muted small mt-1">Completed &amp; paid</div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="p-4 bg-warning bg-opacity-10 border border-warning border-opacity-25 rounded-3 text-center h-100">
            <div class="text-warning fw-bold text-uppercase small mb-1">Avg per Job</div>
            <div class="display-6 fw-bold text-warning">
                &#8377;<%= (paidBookings != null && !paidBookings.isEmpty())
                    ? String.format("%.0f", totalEarnings.doubleValue() / paidBookings.size())
                    : "0" %>
            </div>
            <div class="text-muted small mt-1">Average booking value</div>
        </div>
    </div>
</div>

<!-- Paid Bookings Table -->
<div class="bg-white rounded-3 border shadow-sm p-4">
    <h5 class="fw-bold mb-3"><i class="bi bi-cash-stack me-2 text-success"></i>Paid Bookings</h5>
    <% if (paidBookings == null || paidBookings.isEmpty()) { %>
    <div class="text-center text-muted py-5">
        <i class="bi bi-wallet2 fs-1 d-block mb-2 opacity-25"></i>
        No paid bookings yet. Complete a service to earn!
    </div>
    <% } else { %>
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
                <tr><th>Booking #</th><th>Customer</th><th>Date</th><th>Payment Method</th><th>Amount</th></tr>
            </thead>
            <tbody>
                <% for (Booking b : paidBookings) { %>
                <tr>
                    <td><span class="badge bg-light text-dark border">#<%= b.getBookingId() %></span></td>
                    <td class="fw-semibold"><%= b.getCustomerName() != null ? b.getCustomerName() : "—" %></td>
                    <td class="text-muted small"><%= b.getBookingDate() != null ? b.getBookingDate().toString() : "—" %></td>
                    <td><span class="badge bg-secondary bg-opacity-10 text-secondary"><%= b.getPaymentMethod() != null ? b.getPaymentMethod() : "—" %></span></td>
                    <td class="fw-bold text-success">&#8377;<%= b.getTotalAmount() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    <% } %>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
