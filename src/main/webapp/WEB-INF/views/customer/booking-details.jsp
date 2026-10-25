<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickserve.pojo.Booking" %>
<%@ page import="com.quickserve.pojo.BookingItem" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    Booking booking = (Booking) request.getAttribute("booking");
%>

<div class="row justify-content-center mb-5">
    <div class="col-lg-9">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <a href="<%= request.getContextPath() %>/customer/bookings" class="text-muted small text-decoration-none">
                    <i class="bi bi-arrow-left me-1"></i> Back to Bookings
                </a>
                <h2 class="h3 fw-bold mt-2 mb-0">Booking Details #<%= booking.getBookingId() %></h2>
            </div>
            <span class="badge-status <%= booking.getStatus() %> fs-6 px-3 py-2"><%= booking.getStatus() %></span>
        </div>

        <!-- Status Progress Indicator -->
        <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
            <h6 class="fw-bold text-muted small text-uppercase mb-3">Service Progression</h6>
            <div class="row text-center g-2">
                <div class="col-3">
                    <div class="p-2 rounded-3 <%= ("PENDING".equals(booking.getStatus()) || "CONFIRMED".equals(booking.getStatus()) || "IN_PROGRESS".equals(booking.getStatus()) || "COMPLETED".equals(booking.getStatus())) ? "bg-primary text-white" : "bg-light text-muted" %> small fw-bold">
                        1. Requested
                    </div>
                </div>
                <div class="col-3">
                    <div class="p-2 rounded-3 <%= ("CONFIRMED".equals(booking.getStatus()) || "IN_PROGRESS".equals(booking.getStatus()) || "COMPLETED".equals(booking.getStatus())) ? "bg-primary text-white" : "bg-light text-muted" %> small fw-bold">
                        2. Confirmed
                    </div>
                </div>
                <div class="col-3">
                    <div class="p-2 rounded-3 <%= ("IN_PROGRESS".equals(booking.getStatus()) || "COMPLETED".equals(booking.getStatus())) ? "bg-primary text-white" : "bg-light text-muted" %> small fw-bold">
                        3. In Progress
                    </div>
                </div>
                <div class="col-3">
                    <div class="p-2 rounded-3 <%= ("COMPLETED".equals(booking.getStatus())) ? "bg-success text-white" : "bg-light text-muted" %> small fw-bold">
                        4. Completed
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <!-- Services and Items -->
            <div class="col-md-7">
                <div class="card border-0 shadow-sm rounded-4 p-4 h-100">
                    <h5 class="fw-bold mb-3">Services Included</h5>
                    <div class="list-group list-group-flush mb-3">
                        <% if (booking.getItems() != null) {
                            for (BookingItem item : booking.getItems()) { %>
                            <div class="list-group-item px-0 py-2 d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="fw-bold text-dark small"><%= item.getServiceName() %></div>
                                    <div class="text-muted" style="font-size: 0.75rem;">Qty: <%= item.getQuantity() %> &bull; &#8377;<%= item.getUnitPrice() %> each</div>
                                </div>
                                <div class="fw-bold">&#8377;<%= item.getSubTotal() %></div>
                            </div>
                        <% } } %>
                    </div>

                    <div class="d-flex justify-content-between pt-3 border-top mt-auto">
                        <span class="fw-bold fs-6">Total Amount Paid / Due:</span>
                        <span class="display-6 fw-bold text-primary fs-4">&#8377;<%= booking.getTotalAmount() %></span>
                    </div>

                    <% if (booking.getNotes() != null && !booking.getNotes().trim().isEmpty()) { %>
                        <div class="mt-3 p-2 bg-light rounded-3 small">
                            <span class="text-muted fw-bold">Customer Notes:</span> <%= booking.getNotes() %>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Provider & Schedule Info -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm rounded-4 p-4 h-100">
                    <h5 class="fw-bold mb-3">Appointment Info</h5>
                    
                    <div class="mb-3 small">
                        <span class="text-muted d-block">Scheduled Date & Time:</span>
                        <span class="fw-bold fs-6 text-dark"><i class="bi bi-calendar3 me-1"></i><%= booking.getBookingDate() %> at <%= booking.getBookingTime() %></span>
                    </div>

                    <div class="mb-3 small">
                        <span class="text-muted d-block">Service Provider:</span>
                        <span class="fw-bold text-dark"><%= booking.getProviderBusinessName() %></span>
                        <% if (booking.getProviderPhone() != null) { %>
                            <div class="text-muted mt-1"><i class="bi bi-telephone me-1"></i><%= booking.getProviderPhone() %></div>
                        <% } %>
                    </div>

                    <div class="mb-3 small">
                        <span class="text-muted d-block">Delivery Address:</span>
                        <span class="fw-semibold text-secondary"><%= booking.getAddressDetails() %></span>
                    </div>

                    <div class="p-3 bg-light rounded-3 border small mt-auto">
                        <div class="d-flex justify-content-between mb-1">
                            <span class="text-muted">Payment:</span>
                            <span class="badge <%= "SUCCESS".equalsIgnoreCase(booking.getPaymentStatus()) ? "bg-success" : "bg-warning text-dark" %>">
                                <%= booking.getPaymentStatus() %> (<%= booking.getPaymentMethod() %>)
                            </span>
                        </div>
                        <% if (booking.getTransactionReference() != null) { %>
                            <div class="text-muted" style="font-size: 0.75rem;">Ref: <%= booking.getTransactionReference() %></div>
                        <% } %>

                        <% if ("PENDING".equalsIgnoreCase(booking.getPaymentStatus())) { %>
                            <a href="<%= request.getContextPath() %>/customer/payment?bookingId=<%= booking.getBookingId() %>" class="btn btn-success btn-sm w-100 mt-2">
                                <i class="bi bi-credit-card me-1"></i>Pay &#8377;<%= booking.getTotalAmount() %> Online
                            </a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Rating & Review Section (if Completed) -->
        <% if ("COMPLETED".equalsIgnoreCase(booking.getStatus())) { %>
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                <% if (booking.getRating() != null && booking.getRating() > 0) { %>
                    <h5 class="fw-bold mb-2">Your Review</h5>
                    <div class="text-warning mb-2 fs-5">
                        <% for (int i = 1; i <= 5; i++) { %>
                            <i class="bi <%= (i <= booking.getRating()) ? "bi-star-fill" : "bi-star" %>"></i>
                        <% } %>
                        <span class="text-dark small ms-2 fw-bold"><%= booking.getRating() %> / 5.0</span>
                    </div>
                    <p class="text-secondary small mb-0"><%= (booking.getReviewComment() != null) ? booking.getReviewComment() : "No comment added." %></p>
                <% } else { %>
                    <h5 class="fw-bold mb-2"><i class="bi bi-star-fill text-warning me-2"></i>Rate & Review Your Experience</h5>
                    <p class="text-muted small mb-3">Help other homeowners by sharing your experience with <%= booking.getProviderBusinessName() %>.</p>
                    <form action="<%= request.getContextPath() %>/customer/review" method="POST">
                        <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                        <div class="row g-3">
                            <div class="col-sm-4">
                                <label class="form-label small fw-semibold text-muted">Star Rating</label>
                                <select name="rating" class="form-select form-select-sm" required>
                                    <option value="5">5 - Excellent ★★★★★</option>
                                    <option value="4">4 - Very Good ★★★★</option>
                                    <option value="3">3 - Average ★★★</option>
                                    <option value="2">2 - Poor ★★</option>
                                    <option value="1">1 - Terrible ★</option>
                                </select>
                            </div>
                            <div class="col-sm-8">
                                <label class="form-label small fw-semibold text-muted">Comments</label>
                                <input type="text" name="comment" class="form-control form-control-sm" placeholder="Great service, on-time and clean work..." required>
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn btn-primary-qs btn-sm">Submit Review</button>
                            </div>
                        </div>
                    </form>
                <% } %>
            </div>
        <% } %>

        <div class="d-flex justify-content-between align-items-center">
            <a href="<%= request.getContextPath() %>/customer/support" class="text-muted small">
                <i class="bi bi-question-circle me-1"></i>Need help with this booking? Raise a ticket
            </a>
            <% if ("PENDING".equalsIgnoreCase(booking.getStatus()) || "CONFIRMED".equalsIgnoreCase(booking.getStatus())) { %>
                <a href="<%= request.getContextPath() %>/customer/bookings?cancelId=<%= booking.getBookingId() %>" 
                   class="btn btn-outline-danger btn-sm"
                   onclick="return confirm('Are you sure you want to cancel booking #' + <%= booking.getBookingId() %> + '?');">
                    Cancel Booking
                </a>
            <% } %>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
