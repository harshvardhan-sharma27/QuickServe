<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickserve.pojo.Payment, java.util.List, java.math.BigDecimal" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    BigDecimal totalRevenue = (BigDecimal) request.getAttribute("totalRevenue");
    if (totalRevenue == null) totalRevenue = BigDecimal.ZERO;
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 fw-bold mb-1">Payment Records</h1>
        <p class="text-muted mb-0">All transaction records across the platform</p>
    </div>
    <div class="text-end">
        <div class="text-muted small">Total Successful Revenue</div>
        <div class="h4 fw-bold text-success mb-0">&#8377;<%= totalRevenue.toPlainString() %></div>
    </div>
</div>

<div class="bg-white rounded-3 border shadow-sm p-4">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
                <tr><th>#ID</th><th>Booking</th><th>Transaction Ref</th><th>Amount</th><th>Method</th><th>Status</th><th>Paid At</th></tr>
            </thead>
            <tbody>
                <% if (payments != null && !payments.isEmpty()) {
                    for (Payment p : payments) {
                        String pStatus = p.getPaymentStatus() != null ? p.getPaymentStatus() : "PENDING"; %>
                <tr>
                    <td><span class="badge bg-light text-dark border"><%= p.getPaymentId() %></span></td>
                    <td><a href="<%= cp %>/customer/booking-details?id=<%= p.getBookingId() %>" class="fw-semibold text-primary">#<%= p.getBookingId() %></a></td>
                    <td><span class="text-muted small font-monospace"><%= p.getTransactionReference() != null ? p.getTransactionReference() : "—" %></span></td>
                    <td class="fw-bold text-success">&#8377;<%= p.getAmount() %></td>
                    <td>
                        <span class="badge bg-secondary bg-opacity-10 text-secondary fw-semibold">
                            <%= p.getPaymentMethod() != null ? p.getPaymentMethod() : "—" %>
                        </span>
                    </td>
                    <td>
                        <span class="badge bg-<%= "SUCCESS".equals(pStatus) ? "success" : "FAILED".equals(pStatus) ? "danger" : "REFUNDED".equals(pStatus) ? "info" : "warning text-dark" %> bg-opacity-15 text-<%= "SUCCESS".equals(pStatus) ? "success" : "FAILED".equals(pStatus) ? "danger" : "REFUNDED".equals(pStatus) ? "info" : "warning" %> fw-semibold">
                            <%= pStatus %>
                        </span>
                    </td>
                    <td class="text-muted small"><%= p.getPaidAt() != null ? p.getPaidAt().toString().substring(0,16) : "—" %></td>
                </tr>
                <% } } else { %>
                <tr><td colspan="7" class="text-center text-muted py-4">No payment records found</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
