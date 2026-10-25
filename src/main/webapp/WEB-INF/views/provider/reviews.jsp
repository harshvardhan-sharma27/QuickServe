<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickserve.pojo.Review, com.quickserve.pojo.ProviderProfile, java.util.List" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    ProviderProfile profile = (ProviderProfile) request.getAttribute("profile");
    double avg = 0.0;
    if (reviews != null && !reviews.isEmpty()) {
        for (Review r : reviews) avg += r.getRating();
        avg = avg / reviews.size();
    }
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 fw-bold mb-1">Client Reviews</h1>
        <p class="text-muted mb-0">Customer feedback on your services</p>
    </div>
    <% if (reviews != null && !reviews.isEmpty()) { %>
    <div class="text-center bg-white border rounded-3 px-4 py-2 shadow-sm">
        <div class="h3 fw-bold text-warning mb-0"><%= String.format("%.1f", avg) %></div>
        <div class="small text-muted"><%= reviews.size() %> review<%= reviews.size() != 1 ? "s" : "" %></div>
    </div>
    <% } %>
</div>

<% if (reviews == null || reviews.isEmpty()) { %>
<div class="bg-white rounded-4 border shadow-sm p-5 text-center">
    <i class="bi bi-star fs-1 d-block mb-3 text-warning opacity-40"></i>
    <h5 class="fw-bold text-muted">No Reviews Yet</h5>
    <p class="text-muted small">Complete some bookings to start receiving customer feedback.</p>
</div>
<% } else { %>
<div class="d-flex flex-column gap-3">
    <% for (Review r : reviews) { %>
    <div class="bg-white rounded-3 border shadow-sm p-4">
        <div class="d-flex justify-content-between align-items-start mb-2">
            <div class="d-flex align-items-center gap-3">
                <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width:40px;height:40px;flex-shrink:0">
                    <%= r.getCustomerName() != null ? r.getCustomerName().substring(0,1).toUpperCase() : "C" %>
                </div>
                <div>
                    <div class="fw-semibold"><%= r.getCustomerName() != null ? r.getCustomerName() : "Customer" %></div>
                    <div class="text-muted small"><%= r.getCreatedAt() != null ? r.getCreatedAt().toString().substring(0,10) : "—" %></div>
                </div>
            </div>
            <div class="d-flex gap-1">
                <% for (int i = 1; i <= 5; i++) { %>
                <i class="bi bi-star<%= i <= r.getRating() ? "-fill" : "" %> text-warning"></i>
                <% } %>
            </div>
        </div>
        <% if (r.getComment() != null && !r.getComment().isEmpty()) { %>
        <p class="text-dark mb-0 mt-2 ps-1" style="border-left: 3px solid #e2e8f0; padding-left: 12px;">
            "<%= r.getComment() %>"
        </p>
        <% } %>
        <div class="mt-2">
            <span class="badge bg-light text-muted border small">Booking #<%= r.getBookingId() %></span>
        </div>
    </div>
    <% } %>
</div>
<% } %>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
