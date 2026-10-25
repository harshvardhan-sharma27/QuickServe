<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.quickserve.pojo.Service" %>
<%@ page import="com.quickserve.pojo.ProviderProfile" %>
<%@ page import="com.quickserve.pojo.Review" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    Service service = (Service) request.getAttribute("service");
    ProviderProfile provider = (ProviderProfile) request.getAttribute("provider");
    List<Service> otherServices = (List<Service>) request.getAttribute("providerOtherServices");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
%>

<div class="row g-4 mb-5">
    <!-- Main Service Details -->
    <div class="col-lg-8">
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div style="height: 340px; background: #e2e8f0; position: relative;">
                <img src="<%= (service.getImageUrl() != null && !service.getImageUrl().isEmpty()) ? service.getImageUrl() : "https://images.unsplash.com/photo-1581578731548-c64695cc6952?auto=format&fit=crop&w=900&q=80" %>" 
                     alt="<%= service.getServiceName() %>" class="w-100 h-100 object-fit-cover">
                <span class="category-tag"><%= service.getCategoryName() %></span>
            </div>

            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <h1 class="h3 fw-bold mb-0"><%= service.getServiceName() %></h1>
                    <span class="badge bg-success bg-opacity-10 text-success fs-6 fw-bold">
                        <i class="bi bi-star-fill text-warning me-1"></i><%= service.getProviderRating() %>
                    </span>
                </div>

                <div class="text-muted small mb-3">
                    <i class="bi bi-person-check text-primary me-1"></i> Provided by <strong><%= service.getProviderBusinessName() %></strong>
                    <span class="mx-2">&bull;</span>
                    <i class="bi bi-clock me-1"></i> <%= service.getDurationMinutes() %> Minutes Standard Duration
                </div>

                <hr class="text-muted opacity-25">

                <h5 class="fw-bold mb-3">Service Description</h5>
                <p class="text-secondary leading-relaxed mb-4">
                    <%= (service.getDescription() != null) ? service.getDescription() : "Standard service package provided by certified and background-verified technicians." %>
                </p>

                <h5 class="fw-bold mb-3">What's Included in This Service</h5>
                <div class="row g-2 mb-4">
                    <div class="col-sm-6">
                        <div class="p-2 border rounded-3 bg-light small d-flex align-items-center">
                            <i class="bi bi-check-circle-fill text-success me-2 fs-5"></i>
                            Thorough inspection and safety protocol check
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="p-2 border rounded-3 bg-light small d-flex align-items-center">
                            <i class="bi bi-check-circle-fill text-success me-2 fs-5"></i>
                            Professional grade machinery and tools
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="p-2 border rounded-3 bg-light small d-flex align-items-center">
                            <i class="bi bi-check-circle-fill text-success me-2 fs-5"></i>
                            30-Day post-service satisfaction guarantee
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="p-2 border rounded-3 bg-light small d-flex align-items-center">
                            <i class="bi bi-check-circle-fill text-success me-2 fs-5"></i>
                            Clean-up after task completion
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Verified Reviews Section -->
        <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="h5 fw-bold mb-0">Customer Reviews & Ratings</h4>
                <div class="text-warning fw-bold">
                    <i class="bi bi-star-fill"></i> <%= service.getProviderRating() %> / 5.0
                    <span class="text-muted fw-normal small">(<%= (reviews != null) ? reviews.size() : 0 %> reviews)</span>
                </div>
            </div>

            <% if (reviews == null || reviews.isEmpty()) { %>
                <div class="text-muted small py-3">No reviews left for this provider yet. Be the first to book and share your feedback!</div>
            <% } else { %>
                <div class="d-flex flex-column gap-3">
                    <% for (Review r : reviews) { %>
                        <div class="border-bottom pb-3">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <div class="fw-bold small text-dark"><%= r.getCustomerName() %></div>
                                <div class="text-warning small">
                                    <% for (int i = 1; i <= 5; i++) { %>
                                        <i class="bi <%= (i <= r.getRating()) ? "bi-star-fill" : "bi-star" %>"></i>
                                    <% } %>
                                </div>
                            </div>
                            <div class="text-secondary small"><%= r.getComment() %></div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Right Sidebar Booking & Provider Card -->
    <div class="col-lg-4">
        <!-- Sticky Pricing & Booking Card -->
        <div class="card border-0 shadow rounded-4 p-4 mb-4 sticky-top" style="top: 85px;">
            <span class="text-muted small">Standard Package Rate</span>
            <div class="d-flex align-items-baseline gap-2 mb-3">
                <h2 class="display-6 fw-bold text-dark mb-0">&#8377;<%= service.getPrice() %></h2>
                <span class="text-muted small">/ session</span>
            </div>

            <div class="p-3 bg-light rounded-3 mb-4 small">
                <div class="d-flex justify-content-between mb-1">
                    <span class="text-muted">Estimated Duration:</span>
                    <span class="fw-bold"><%= service.getDurationMinutes() %> minutes</span>
                </div>
                <div class="d-flex justify-content-between mb-1">
                    <span class="text-muted">Cancellation:</span>
                    <span class="text-success fw-bold">Free up to 2 hrs</span>
                </div>
                <div class="d-flex justify-content-between">
                    <span class="text-muted">Payment:</span>
                    <span class="fw-bold">UPI / Card / Cash</span>
                </div>
            </div>

            <a href="<%= request.getContextPath() %>/customer/book-service?serviceId=<%= service.getServiceId() %>" class="btn btn-primary-qs w-100 py-3 fw-bold fs-6 shadow-sm mb-3">
                <i class="bi bi-calendar2-check me-2"></i>Book Service
            </a>

            <!-- Provider Profile Widget -->
            <% if (provider != null) { %>
                <hr class="text-muted opacity-25">
                <div class="d-flex align-items-center gap-3 mt-3">
                    <div class="bg-primary text-white rounded-3 p-3 text-center" style="width: 55px; height: 55px;">
                        <i class="bi bi-shop fs-4"></i>
                    </div>
                    <div>
                        <div class="fw-bold text-dark"><%= provider.getBusinessName() %></div>
                        <div class="text-muted small"><%= provider.getExperienceYears() %>+ Years in Business</div>
                        <div class="text-warning small fw-semibold">
                            <i class="bi bi-star-fill"></i> <%= provider.getRating() %> Rating &bull; Verified Partner
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
