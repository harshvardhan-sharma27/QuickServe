<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickserve.dto.ProviderDashboardDTO" %>
<%@ page import="com.quickserve.pojo.ProviderProfile" %>
<%@ page import="com.quickserve.pojo.Booking" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    ProviderProfile profile = (ProviderProfile) request.getAttribute("profile");
    ProviderDashboardDTO stats = (ProviderDashboardDTO) request.getAttribute("stats");
%>

<div class="mb-4 d-flex justify-content-between align-items-center flex-wrap gap-2">
    <div>
        <h2 class="h3 fw-bold mb-1">Provider Dashboard: <%= (profile != null) ? profile.getBusinessName() : currentUser.getFullName() %></h2>
        <span class="text-muted small">Manage your business orders, schedule, and revenue.</span>
    </div>

    <div>
        <% if (profile != null && "APPROVED".equalsIgnoreCase(profile.getVerificationStatus())) { %>
            <span class="badge bg-success bg-opacity-10 text-success fs-6 px-3 py-2">
                <i class="bi bi-patch-check-fill me-1"></i>Verified Business Partner
            </span>
        <% } else { %>
            <span class="badge bg-warning bg-opacity-10 text-warning fs-6 px-3 py-2">
                <i class="bi bi-clock-history me-1"></i>Verification Pending Admin Review
            </span>
        <% } %>
    </div>
</div>

<!-- Stat Cards -->
<div class="row g-3 mb-4">
    <div class="col-sm-6 col-xl-3">
        <div class="stat-card">
            <div class="stat-icon success">
                <i class="bi bi-wallet2"></i>
            </div>
            <div>
                <div class="stat-number">&#8377;<%= (stats != null) ? stats.getTotalEarnings() : "0.00" %></div>
                <div class="stat-label">Total Realized Revenue</div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-3">
        <div class="stat-card">
            <div class="stat-icon warning">
                <i class="bi bi-star-fill"></i>
            </div>
            <div>
                <div class="stat-number"><%= (stats != null) ? stats.getRating() : "0.0" %> / 5.0</div>
                <div class="stat-label">Customer Satisfaction</div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-3">
        <div class="stat-card">
            <div class="stat-icon primary">
                <i class="bi bi-hourglass-split"></i>
            </div>
            <div>
                <div class="stat-number"><%= (stats != null) ? stats.getPendingBookings() : 0 %></div>
                <div class="stat-label">Pending Bookings</div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-3">
        <div class="stat-card">
            <div class="stat-icon secondary">
                <i class="bi bi-wrench"></i>
            </div>
            <div>
                <div class="stat-number"><%= (stats != null) ? stats.getActiveServicesCount() : 0 %></div>
                <div class="stat-label">Services Offered</div>
            </div>
        </div>
    </div>
</div>

<!-- Recent Jobs Table -->
<div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
    <div class="card-header bg-white py-3 px-4 d-flex justify-content-between align-items-center border-bottom">
        <h5 class="fw-bold mb-0">Incoming & Recent Bookings</h5>
        <a href="<%= request.getContextPath() %>/provider/bookings" class="btn btn-outline-qs btn-sm">All Bookings</a>
    </div>

    <div class="table-responsive">
        <table class="table table-custom mb-0">
            <thead>
                <tr>
                    <th>Booking #</th>
                    <th>Customer</th>
                    <th>Address</th>
                    <th>Date & Time</th>
                    <th>Total</th>
                    <th>Status</th>
                    <th class="text-end">Update Status</th>
                </tr>
            </thead>
            <tbody>
                <% if (stats != null && stats.getRecentBookings() != null && !stats.getRecentBookings().isEmpty()) {
                    for (Booking b : stats.getRecentBookings()) { %>
                    <tr>
                        <td class="fw-bold">#<%= b.getBookingId() %></td>
                        <td>
                            <div class="fw-semibold text-dark"><%= b.getCustomerName() %></div>
                            <div class="text-muted small"><%= b.getCustomerPhone() %></div>
                        </td>
                        <td class="small text-muted text-truncate" style="max-width: 200px;"><%= b.getAddressDetails() %></td>
                        <td>
                            <div class="small fw-semibold"><%= b.getBookingDate() %></div>
                            <div class="text-muted small"><%= b.getBookingTime() %></div>
                        </td>
                        <td class="fw-bold">&#8377;<%= b.getTotalAmount() %></td>
                        <td>
                            <span class="badge-status <%= b.getStatus() %>"><%= b.getStatus() %></span>
                        </td>
                        <td class="text-end">
                            <% if ("PENDING".equalsIgnoreCase(b.getStatus())) { %>
                                <a href="<%= request.getContextPath() %>/provider/bookings?action=update&id=<%= b.getBookingId() %>&status=CONFIRMED" class="btn btn-sm btn-success">
                                    <i class="bi bi-check2"></i> Accept
                                </a>
                                <a href="<%= request.getContextPath() %>/provider/bookings?action=update&id=<%= b.getBookingId() %>&status=CANCELLED" class="btn btn-sm btn-outline-danger">
                                    <i class="bi bi-x"></i> Reject
                                </a>
                            <% } else if ("CONFIRMED".equalsIgnoreCase(b.getStatus())) { %>
                                <a href="<%= request.getContextPath() %>/provider/bookings?action=update&id=<%= b.getBookingId() %>&status=IN_PROGRESS" class="btn btn-sm btn-primary">
                                    Start Job
                                </a>
                            <% } else if ("IN_PROGRESS".equalsIgnoreCase(b.getStatus())) { %>
                                <a href="<%= request.getContextPath() %>/provider/bookings?action=update&id=<%= b.getBookingId() %>&status=COMPLETED" class="btn btn-sm btn-success">
                                    Mark Done
                                </a>
                            <% } else { %>
                                <span class="text-muted small">No action</span>
                            <% } %>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr>
                        <td colspan="7" class="text-center py-4 text-muted">No booking requests found.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Provider Quick Navigation -->
<div class="row g-3">
    <div class="col-md-3">
        <a href="<%= request.getContextPath() %>/provider/services" class="card border-0 shadow-sm rounded-4 p-3 text-decoration-none text-dark d-flex align-items-center gap-3">
            <div class="stat-icon primary m-0" style="width: 44px; height: 44px; font-size: 1.3rem;"><i class="bi bi-wrench"></i></div>
            <div>
                <div class="fw-bold">My Services</div>
                <div class="text-muted small">Add or price services</div>
            </div>
        </a>
    </div>
    <div class="col-md-3">
        <a href="<%= request.getContextPath() %>/provider/availability" class="card border-0 shadow-sm rounded-4 p-3 text-decoration-none text-dark d-flex align-items-center gap-3">
            <div class="stat-icon secondary m-0" style="width: 44px; height: 44px; font-size: 1.3rem;"><i class="bi bi-calendar3"></i></div>
            <div>
                <div class="fw-bold">Set Availability</div>
                <div class="text-muted small">Working schedule</div>
            </div>
        </a>
    </div>
    <div class="col-md-3">
        <a href="<%= request.getContextPath() %>/provider/earnings" class="card border-0 shadow-sm rounded-4 p-3 text-decoration-none text-dark d-flex align-items-center gap-3">
            <div class="stat-icon success m-0" style="width: 44px; height: 44px; font-size: 1.3rem;"><i class="bi bi-cash-stack"></i></div>
            <div>
                <div class="fw-bold">Earnings</div>
                <div class="text-muted small">Payout summaries</div>
            </div>
        </a>
    </div>
    <div class="col-md-3">
        <a href="<%= request.getContextPath() %>/provider/reviews" class="card border-0 shadow-sm rounded-4 p-3 text-decoration-none text-dark d-flex align-items-center gap-3">
            <div class="stat-icon warning m-0" style="width: 44px; height: 44px; font-size: 1.3rem;"><i class="bi bi-star"></i></div>
            <div>
                <div class="fw-bold">Client Reviews</div>
                <div class="text-muted small">Read ratings & reviews</div>
            </div>
        </a>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
