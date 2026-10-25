<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.quickserve.pojo.Category" %>
<%@ page import="com.quickserve.pojo.Service" %>
<%@ page import="com.quickserve.pojo.ProviderProfile" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<Service> featuredServices = (List<Service>) request.getAttribute("featuredServices");
    List<ProviderProfile> featuredProviders = (List<ProviderProfile>) request.getAttribute("featuredProviders");
%>

<!-- Hero Section -->
<div class="hero-banner rounded-4 mb-5 shadow-lg">
    <div class="container py-4">
        <div class="row align-items-center">
            <div class="col-lg-7">
                <span class="hero-badge">
                    <i class="bi bi-patch-check-fill text-warning"></i> 100% Verified Local Professionals
                </span>
                <h1 class="display-4 fw-extrabold text-white mb-3" style="font-weight: 800;">
                    Expert Home Services,<br>Delivered at Your Doorstep.
                </h1>
                <p class="lead text-light opacity-75 mb-4" style="max-width: 580px;">
                    From high-precision electrical work and AC power jet cleaning to deep sanitation and leak repairs — book vetted experts in minutes.
                </p>

                <!-- Search box in Hero -->
                <form action="<%= request.getContextPath() %>/services" method="GET" class="d-flex flex-column flex-sm-row gap-2 bg-white p-2 rounded-3 shadow" style="max-width: 540px;">
                    <div class="d-flex align-items-center flex-grow-1 px-3">
                        <i class="bi bi-search text-muted me-2"></i>
                        <input type="text" name="keyword" class="form-control border-0 shadow-none px-0" placeholder="What service do you need today?">
                    </div>
                    <button type="submit" class="btn btn-primary-qs px-4 py-2">
                        Find Experts
                    </button>
                </form>

                <div class="d-flex gap-4 mt-4 text-white opacity-75 small">
                    <div><i class="bi bi-shield-check text-success me-1"></i> Background Verified</div>
                    <div><i class="bi bi-clock-history text-info me-1"></i> On-Time Guarantee</div>
                    <div><i class="bi bi-wallet2 text-warning me-1"></i> Upfront Transparent Rates</div>
                </div>
            </div>

            <div class="col-lg-5 d-none d-lg-block text-center">
                <div class="p-3 bg-white bg-opacity-10 rounded-4 border border-white border-opacity-25 backdrop-blur">
                    <img src="https://images.unsplash.com/photo-1581578731548-c64695cc6952?auto=format&fit=crop&w=700&q=80" 
                         alt="Home Service" class="img-fluid rounded-3 shadow">
                    <div class="d-flex justify-content-around mt-3 text-white text-start">
                        <div>
                            <div class="fw-bold fs-5">15,000+</div>
                            <div class="small opacity-75">Services Done</div>
                        </div>
                        <div class="vr bg-white opacity-25"></div>
                        <div>
                            <div class="fw-bold fs-5">4.8 / 5.0</div>
                            <div class="small opacity-75">Average Rating</div>
                        </div>
                        <div class="vr bg-white opacity-25"></div>
                        <div>
                            <div class="fw-bold fs-5">100%</div>
                            <div class="small opacity-75">Safe & Insured</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Explore Categories -->
<section class="mb-5">
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <span class="text-primary fw-bold text-uppercase small tracking-wide">Browse by Need</span>
            <h2 class="h3 fw-bold mb-0">Popular Categories</h2>
        </div>
        <a href="<%= request.getContextPath() %>/services" class="btn btn-outline-qs btn-sm">
            View All Categories <i class="bi bi-arrow-right ms-1"></i>
        </a>
    </div>

    <div class="row row-cols-2 row-cols-sm-3 row-cols-md-4 row-cols-lg-4 g-3">
        <% if (categories != null) {
            for (Category cat : categories) { %>
            <div class="col">
                <a href="<%= request.getContextPath() %>/services?category=<%= cat.getCategoryId() %>" class="category-card">
                    <div class="category-icon">
                        <i class="bi <%= (cat.getIconClass() != null) ? cat.getIconClass() : "bi-gear" %>"></i>
                    </div>
                    <div class="fw-bold"><%= cat.getCategoryName() %></div>
                    <div class="text-muted small text-truncate"><%= (cat.getDescription() != null) ? cat.getDescription() : "Expert services" %></div>
                </a>
            </div>
        <% } } %>
    </div>
</section>

<!-- Featured / Popular Services -->
<section class="mb-5">
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <span class="text-primary fw-bold text-uppercase small">Top Rated</span>
            <h2 class="h3 fw-bold mb-0">Trending Services</h2>
        </div>
        <a href="<%= request.getContextPath() %>/services?sortBy=rating_desc" class="btn btn-outline-qs btn-sm">
            Explore All <i class="bi bi-arrow-right ms-1"></i>
        </a>
    </div>

    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <% if (featuredServices != null) {
            for (Service s : featuredServices) { %>
            <div class="col">
                <div class="service-card">
                    <div class="service-img-wrapper">
                        <img src="<%= (s.getImageUrl() != null && !s.getImageUrl().isEmpty()) ? s.getImageUrl() : "https://images.unsplash.com/photo-1581578731548-c64695cc6952?auto=format&fit=crop&w=600&q=80" %>" 
                             alt="<%= s.getServiceName() %>" class="service-img">
                        <span class="category-tag"><%= s.getCategoryName() %></span>
                        <span class="rating-tag"><i class="bi bi-star-fill text-warning"></i> <%= s.getProviderRating() %></span>
                    </div>
                    <div class="service-body">
                        <h3 class="service-title">
                            <a href="<%= request.getContextPath() %>/service-details?id=<%= s.getServiceId() %>" class="text-dark text-decoration-none">
                                <%= s.getServiceName() %>
                            </a>
                        </h3>
                        <div class="provider-meta">
                            <i class="bi bi-person-check text-primary"></i>
                            <span><%= s.getProviderBusinessName() %></span>
                        </div>
                        <p class="text-muted small mb-3 text-truncate">
                            <%= (s.getDescription() != null) ? s.getDescription() : "" %>
                        </p>
                        <div class="service-price-block">
                            <div>
                                <div class="service-price">&#8377;<%= s.getPrice() %></div>
                                <div class="service-duration"><i class="bi bi-clock me-1"></i><%= s.getDurationMinutes() %> mins</div>
                            </div>
                            <a href="<%= request.getContextPath() %>/customer/book-service?serviceId=<%= s.getServiceId() %>" class="btn btn-primary-qs btn-sm">
                                Book Now
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        <% } } %>
    </div>
</section>

<!-- Verified Service Partners Showcase -->
<section class="mb-5 py-4 bg-white rounded-4 border p-4 shadow-sm">
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <span class="text-primary fw-bold text-uppercase small">Top Rated Partners</span>
            <h2 class="h3 fw-bold mb-0">Certified Service Professionals</h2>
        </div>
        <a href="<%= request.getContextPath() %>/register?role=PROVIDER" class="btn btn-outline-primary btn-sm">
            <i class="bi bi-plus-circle me-1"></i>Become a Partner
        </a>
    </div>

    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-3">
        <% if (featuredProviders != null) {
            for (ProviderProfile p : featuredProviders) { %>
            <div class="col">
                <div class="p-3 border rounded-3 h-100 bg-light d-flex flex-column">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <div class="bg-primary bg-opacity-10 text-primary p-2 rounded-3">
                            <i class="bi bi-briefcase-fill fs-4"></i>
                        </div>
                        <span class="badge bg-success bg-opacity-10 text-success fw-bold">
                            <i class="bi bi-patch-check-fill me-1"></i>Verified
                        </span>
                    </div>
                    <div class="fw-bold fs-6 text-dark mb-1"><%= p.getBusinessName() %></div>
                    <div class="text-muted small mb-2"><%= p.getExperienceYears() %>+ Years Experience</div>
                    <p class="text-secondary small mb-3 flex-grow-1" style="font-size: 0.8rem;">
                        <%= (p.getDescription() != null) ? p.getDescription() : "" %>
                    </p>
                    <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                        <div class="text-warning small fw-bold">
                            <i class="bi bi-star-fill"></i> <%= p.getRating() %> / 5.0
                        </div>
                        <a href="<%= request.getContextPath() %>/services" class="text-primary small fw-semibold">
                            View Jobs <i class="bi bi-chevron-right"></i>
                        </a>
                    </div>
                </div>
            </div>
        <% } } %>
    </div>
</section>

<!-- How QuickServe Works -->
<section class="mb-5 text-center py-4">
    <span class="text-primary fw-bold text-uppercase small">Simple & Seamless</span>
    <h2 class="h3 fw-bold mb-5">How QuickServe Works</h2>

    <div class="row g-4">
        <div class="col-md-3">
            <div class="p-3">
                <div class="stat-icon primary mx-auto mb-3" style="width: 64px; height: 64px;">
                    <i class="bi bi-search fs-3"></i>
                </div>
                <h5 class="fw-bold mb-2">1. Choose a Service</h5>
                <p class="text-muted small">Select from our verified catalog of 14+ standardized home maintenance services.</p>
            </div>
        </div>
        <div class="col-md-3">
            <div class="p-3">
                <div class="stat-icon secondary mx-auto mb-3" style="width: 64px; height: 64px;">
                    <i class="bi bi-calendar-check fs-3"></i>
                </div>
                <h5 class="fw-bold mb-2">2. Pick Date & Slot</h5>
                <p class="text-muted small">Select your delivery address and choose a convenient appointment time from real availability.</p>
            </div>
        </div>
        <div class="col-md-3">
            <div class="p-3">
                <div class="stat-icon warning mx-auto mb-3" style="width: 64px; height: 64px;">
                    <i class="bi bi-credit-card fs-3"></i>
                </div>
                <h5 class="fw-bold mb-2">3. Instant Booking</h5>
                <p class="text-muted small">Atomic transaction booking with seamless UPI, Card, or Cash on Delivery options.</p>
            </div>
        </div>
        <div class="col-md-3">
            <div class="p-3">
                <div class="stat-icon success mx-auto mb-3" style="width: 64px; height: 64px;">
                    <i class="bi bi-star-fill fs-3"></i>
                </div>
                <h5 class="fw-bold mb-2">4. Relax & Review</h5>
                <p class="text-muted small">Track booking progress in real time. Rate and review your provider once service is completed.</p>
            </div>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
