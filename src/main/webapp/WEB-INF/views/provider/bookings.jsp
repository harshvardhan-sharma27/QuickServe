<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickserve.pojo.Booking, java.util.List" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 fw-bold mb-1">My Jobs</h1>
        <p class="text-muted mb-0">Track and update your assigned service bookings</p>
    </div>
</div>

<% if (bookings == null || bookings.isEmpty()) { %>
<div class="bg-white rounded-4 border shadow-sm p-5 text-center">
    <i class="bi bi-clipboard2-x fs-1 d-block mb-3 text-muted opacity-50"></i>
    <h5 class="fw-bold text-muted">No Jobs Yet</h5>
    <p class="text-muted small">Once customers book your services, they'll appear here.</p>
</div>
<% } else { %>
<div class="d-flex flex-column gap-3">
    <% for (Booking b : bookings) {
        String status = b.getStatus() != null ? b.getStatus() : "PENDING"; %>
    <div class="bg-white rounded-3 border shadow-sm p-4">
        <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
            <div>
                <div class="d-flex align-items-center gap-2 mb-1">
                    <span class="badge bg-light text-dark border fw-bold">#<%= b.getBookingId() %></span>
                    <span class="fw-bold fs-6"><%= b.getCustomerName() != null ? b.getCustomerName() : "Customer" %></span>
                </div>
                <div class="text-muted small">
                    <i class="bi bi-calendar3 me-1"></i><%= b.getBookingDate() != null ? b.getBookingDate().toString() : "—" %>
                    <% if (b.getBookingTime() != null) { %>&nbsp;&middot;&nbsp;<i class="bi bi-clock me-1"></i><%= b.getBookingTime().toString().substring(0,5) %><% } %>
                    &nbsp;&middot;&nbsp;<i class="bi bi-geo-alt me-1"></i><%= b.getDeliveryAddress() != null ? b.getDeliveryAddress() : "—" %>
                </div>
            </div>
            <div class="d-flex align-items-center gap-2">
                <span class="fw-bold text-success fs-6">&#8377;<%= b.getTotalAmount() %></span>
                <span class="badge bg-<%= "COMPLETED".equals(status) ? "success" : "CANCELLED".equals(status) ? "danger" : "PENDING".equals(status) ? "warning text-dark" : "IN_PROGRESS".equals(status) ? "primary" : "info" %> bg-opacity-15 text-<%= "COMPLETED".equals(status) ? "success" : "CANCELLED".equals(status) ? "danger" : "PENDING".equals(status) ? "warning" : "IN_PROGRESS".equals(status) ? "primary" : "info" %> fw-semibold">
                    <%= status %>
                </span>
            </div>
        </div>

        <% if (b.getNotes() != null && !b.getNotes().trim().isEmpty()) { %>
        <div class="mt-2 text-muted small p-2 bg-light rounded-2">
            <i class="bi bi-chat-left-quote me-1"></i><%= b.getNotes() %>
        </div>
        <% } %>

        <!-- Status Update Actions -->
        <% if (!"COMPLETED".equals(status) && !"CANCELLED".equals(status)) { %>
        <div class="mt-3 d-flex gap-2 flex-wrap">
            <% if ("PENDING".equals(status)) { %>
            <a href="<%= cp %>/provider/bookings?action=update&id=<%= b.getBookingId() %>&status=CONFIRMED"
               class="btn btn-outline-info btn-sm"><i class="bi bi-check-circle me-1"></i>Confirm Job</a>
            <% } %>
            <% if ("CONFIRMED".equals(status)) { %>
            <a href="<%= cp %>/provider/bookings?action=update&id=<%= b.getBookingId() %>&status=IN_PROGRESS"
               class="btn btn-outline-primary btn-sm"><i class="bi bi-play-circle me-1"></i>Start Service</a>
            <% } %>
            <% if ("IN_PROGRESS".equals(status)) { %>
            <a href="<%= cp %>/provider/bookings?action=update&id=<%= b.getBookingId() %>&status=COMPLETED"
               class="btn btn-success btn-sm"><i class="bi bi-check2-all me-1"></i>Mark Complete</a>
            <% } %>
        </div>
        <% } %>
    </div>
    <% } %>
</div>
<% } %>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
