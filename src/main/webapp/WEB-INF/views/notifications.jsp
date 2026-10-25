<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.quickserve.pojo.Notification" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
%>

<div class="row justify-content-center mb-5">
    <div class="col-lg-8">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="h4 fw-bold mb-0"><i class="bi bi-bell text-primary me-2"></i>Notifications</h2>
                <span class="text-muted small">Stay updated on your bookings and service alerts</span>
            </div>
            <% if (notifications != null && !notifications.isEmpty()) { %>
                <a href="<%= request.getContextPath() %>/notifications/mark-all-read" class="btn btn-outline-qs btn-sm">
                    <i class="bi bi-check2-all me-1"></i>Mark All Read
                </a>
            <% } %>
        </div>

        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
            <% if (notifications == null || notifications.isEmpty()) { %>
                <div class="text-center py-5">
                    <i class="bi bi-bell-slash fs-1 text-muted opacity-50 mb-3 d-block"></i>
                    <h5 class="fw-bold">No notifications yet</h5>
                    <p class="text-muted small">You will receive notifications when booking updates occur.</p>
                </div>
            <% } else { %>
                <div class="list-group list-group-flush">
                    <% for (Notification n : notifications) { %>
                        <div class="list-group-item p-3 d-flex justify-content-between align-items-center <%= !n.isRead() ? "bg-light border-start border-4 border-primary" : "" %>">
                            <div class="d-flex align-items-start gap-3">
                                <div class="bg-primary bg-opacity-10 text-primary p-2 rounded-circle mt-1">
                                    <i class="bi bi-info-circle-fill"></i>
                                </div>
                                <div>
                                    <div class="text-dark <%= !n.isRead() ? "fw-bold" : "" %>"><%= n.getMessage() %></div>
                                    <div class="text-muted small mt-1"><%= n.getCreatedAt() %></div>
                                </div>
                            </div>
                            <% if (!n.isRead()) { %>
                                <a href="<%= request.getContextPath() %>/notifications/mark-read?id=<%= n.getNotificationId() %>" class="btn btn-sm btn-outline-secondary">
                                    Mark read
                                </a>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
