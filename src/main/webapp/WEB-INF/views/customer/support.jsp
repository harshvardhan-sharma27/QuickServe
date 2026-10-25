<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.quickserve.pojo.SupportTicket" %>
<%@ page import="com.quickserve.pojo.Booking" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    List<SupportTicket> tickets = (List<SupportTicket>) request.getAttribute("tickets");
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>

<div class="row g-4 mb-5">
    <!-- Existing Tickets -->
    <div class="col-lg-7">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="h4 fw-bold mb-0"><i class="bi bi-headset text-primary me-2"></i>My Support Requests</h2>
            <span class="text-muted small"><%= (tickets != null) ? tickets.size() : 0 %> Tickets</span>
        </div>

        <% if (tickets == null || tickets.isEmpty()) { %>
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center">
                <i class="bi bi-chat-heart fs-1 text-muted opacity-50 mb-3 d-block"></i>
                <h6 class="fw-bold">No tickets raised</h6>
                <p class="text-muted small">Need assistance with an invoice, booking, or provider? Raise a ticket on the right.</p>
            </div>
        <% } else { %>
            <div class="d-flex flex-column gap-3">
                <% for (SupportTicket t : tickets) { %>
                    <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div>
                                <span class="badge-status <%= t.getStatus() %> me-2"><%= t.getStatus() %></span>
                                <span class="fw-bold text-dark fs-6"><%= t.getSubject() %></span>
                            </div>
                            <span class="text-muted" style="font-size: 0.75rem;"><%= t.getCreatedAt() %></span>
                        </div>
                        <p class="text-secondary small mb-2"><%= t.getDescription() %></p>
                        <% if (t.getBookingId() != null && t.getBookingId() > 0) { %>
                            <div class="text-muted small mb-2"><i class="bi bi-link-45deg"></i> Related Booking: #<%= t.getBookingId() %></div>
                        <% } %>

                        <% if (t.getAdminResponse() != null && !t.getAdminResponse().trim().isEmpty()) { %>
                            <div class="p-2 bg-success bg-opacity-10 rounded-3 border border-success border-opacity-25 mt-2 small">
                                <strong class="text-success d-block mb-1"><i class="bi bi-shield-check me-1"></i>Support Agent Response:</strong>
                                <span class="text-dark"><%= t.getAdminResponse() %></span>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- Raise New Ticket -->
    <div class="col-lg-5">
        <div class="card border-0 shadow-sm rounded-4 p-4">
            <h5 class="fw-bold mb-3"><i class="bi bi-pencil-square text-primary me-2"></i>Raise New Ticket</h5>
            
            <form action="<%= request.getContextPath() %>/customer/support" method="POST">
                <div class="mb-3">
                    <label class="form-label small fw-semibold text-muted">Related Booking (Optional)</label>
                    <select name="bookingId" class="form-select form-select-sm">
                        <option value="">-- General Inquiry --</option>
                        <% if (bookings != null) {
                            for (Booking b : bookings) { %>
                                <option value="<%= b.getBookingId() %>">Booking #<%= b.getBookingId() %> (<%= b.getProviderBusinessName() %> - &#8377;<%= b.getTotalAmount() %>)</option>
                        <% } } %>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-semibold text-muted">Subject / Query Title</label>
                    <input type="text" name="subject" class="form-control form-control-sm" placeholder="e.g. Need invoice copy, reschedule request..." required>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-semibold text-muted">Detailed Description</label>
                    <textarea name="description" class="form-control form-control-sm" rows="4" placeholder="Explain your issue clearly so our support team can assist immediately..." required></textarea>
                </div>

                <button type="submit" class="btn btn-primary-qs w-100 btn-sm">Submit Ticket</button>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
