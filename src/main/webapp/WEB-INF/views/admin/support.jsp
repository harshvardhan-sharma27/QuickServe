<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickserve.pojo.SupportTicket, java.util.List" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    List<SupportTicket> tickets = (List<SupportTicket>) request.getAttribute("tickets");
    String selectedFilter = (String) request.getAttribute("selectedFilter");
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 fw-bold mb-1">Support Tickets</h1>
        <p class="text-muted mb-0">Review and respond to customer support requests</p>
    </div>
    <span class="badge bg-danger bg-opacity-10 text-danger fw-bold px-3 py-2 rounded-3"><%= tickets != null ? tickets.size() : 0 %> tickets</span>
</div>

<!-- Filters -->
<div class="bg-white rounded-3 border shadow-sm p-3 mb-4">
    <div class="d-flex flex-wrap gap-2">
        <a href="<%= cp %>/admin/support" class="btn btn-sm <%= selectedFilter == null ? "btn-primary-qs" : "btn-outline-secondary" %>">All</a>
        <a href="<%= cp %>/admin/support?filter=OPEN" class="btn btn-sm <%= "OPEN".equals(selectedFilter) ? "btn-danger" : "btn-outline-danger" %>">Open</a>
        <a href="<%= cp %>/admin/support?filter=IN_PROGRESS" class="btn btn-sm <%= "IN_PROGRESS".equals(selectedFilter) ? "btn-warning text-dark" : "btn-outline-warning" %>">In Progress</a>
        <a href="<%= cp %>/admin/support?filter=RESOLVED" class="btn btn-sm <%= "RESOLVED".equals(selectedFilter) ? "btn-success" : "btn-outline-success" %>">Resolved</a>
        <a href="<%= cp %>/admin/support?filter=CLOSED" class="btn btn-sm <%= "CLOSED".equals(selectedFilter) ? "btn-secondary" : "btn-outline-secondary" %>">Closed</a>
    </div>
</div>

<div class="d-flex flex-column gap-3">
    <% if (tickets != null && !tickets.isEmpty()) {
        for (SupportTicket t : tickets) {
            String tStatus = t.getStatus() != null ? t.getStatus() : "OPEN"; %>
    <div class="bg-white rounded-3 border shadow-sm p-4">
        <div class="d-flex justify-content-between align-items-start mb-2">
            <div>
                <span class="badge bg-light text-dark border me-2">#<%= t.getTicketId() %></span>
                <span class="fw-bold fs-6"><%= t.getSubject() %></span>
                <% if (t.getBookingId() != null) { %>
                <a href="<%= cp %>/customer/booking-details?id=<%= t.getBookingId() %>" class="badge bg-primary bg-opacity-10 text-primary ms-2 text-decoration-none">Booking #<%= t.getBookingId() %></a>
                <% } %>
            </div>
            <div class="d-flex align-items-center gap-2">
                <span class="badge bg-<%= "RESOLVED".equals(tStatus) ? "success" : "CLOSED".equals(tStatus) ? "secondary" : "OPEN".equals(tStatus) ? "danger" : "warning text-dark" %> bg-opacity-15 text-<%= "RESOLVED".equals(tStatus) ? "success" : "CLOSED".equals(tStatus) ? "secondary" : "OPEN".equals(tStatus) ? "danger" : "warning" %> fw-semibold">
                    <%= tStatus %>
                </span>
                <span class="text-muted small"><%= t.getCreatedAt() != null ? t.getCreatedAt().toString().substring(0,10) : "—" %></span>
            </div>
        </div>

        <div class="text-muted small mb-1">
            <i class="bi bi-person me-1"></i><strong><%= t.getUserName() != null ? t.getUserName() : "User #" + t.getUserId() %></strong>
            <% if (t.getUserEmail() != null) { %> &lt;<%= t.getUserEmail() %>&gt;<% } %>
            <% if (t.getUserRole() != null) { %> &middot; <span class="badge bg-secondary bg-opacity-10 text-secondary"><%= t.getUserRole() %></span><% } %>
        </div>

        <p class="text-dark small mb-3 p-2 bg-light rounded-2"><%= t.getDescription() != null ? t.getDescription() : "" %></p>

        <% if (t.getAdminResponse() != null && !t.getAdminResponse().isEmpty()) { %>
        <div class="border-start border-success border-3 ps-3 mb-3 bg-success bg-opacity-5 rounded-2 p-2">
            <div class="small fw-semibold text-success mb-1"><i class="bi bi-reply me-1"></i>Admin Response:</div>
            <div class="small text-dark"><%= t.getAdminResponse() %></div>
        </div>
        <% } %>

        <% if (!"CLOSED".equals(tStatus) && !"RESOLVED".equals(tStatus)) { %>
        <form method="POST" action="<%= cp %>/admin/support" class="mt-2">
            <input type="hidden" name="ticketId" value="<%= t.getTicketId() %>">
            <div class="row g-2 align-items-end">
                <div class="col">
                    <textarea name="response" class="form-control form-control-sm" rows="2" placeholder="Type your response..."><%= t.getAdminResponse() != null ? t.getAdminResponse() : "" %></textarea>
                </div>
                <div class="col-auto">
                    <select name="status" class="form-select form-select-sm mb-2">
                        <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(tStatus) ? "selected" : "" %>>In Progress</option>
                        <option value="RESOLVED">Resolved</option>
                        <option value="CLOSED">Close Ticket</option>
                    </select>
                    <button type="submit" class="btn btn-primary-qs btn-sm w-100">Send &amp; Update</button>
                </div>
            </div>
        </form>
        <% } %>
    </div>
    <% } } else { %>
    <div class="bg-white rounded-3 border shadow-sm p-5 text-center text-muted">
        <i class="bi bi-chat-dots fs-1 d-block mb-2 opacity-25"></i>
        No support tickets found.
    </div>
    <% } %>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
