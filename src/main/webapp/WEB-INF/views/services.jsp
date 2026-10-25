<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.quickserve.pojo.Category" %>
<%@ page import="com.quickserve.pojo.Service" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    List<Service> services = (List<Service>) request.getAttribute("services");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    Integer selectedCategory = (Integer) request.getAttribute("selectedCategory");
    String keyword = (String) request.getAttribute("keyword");
    String sortBy = (String) request.getAttribute("sortBy");
    int currentPage = (Integer) request.getAttribute("currentPage");
    int totalPages = (Integer) request.getAttribute("totalPages");
    int totalServices = (Integer) request.getAttribute("totalServices");
%>

<div class="row g-4 mb-5">
    <!-- Filters Sidebar -->
    <div class="col-lg-3">
        <div class="card border-0 shadow-sm rounded-4 p-3 sticky-top" style="top: 85px;">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold mb-0"><i class="bi bi-funnel me-1 text-primary"></i> Filters</h5>
                <a href="<%= request.getContextPath() %>/services" class="text-muted small">Reset</a>
            </div>

            <form action="<%= request.getContextPath() %>/services" method="GET">
                <!-- Search term -->
                <div class="mb-3">
                    <label class="form-label small fw-semibold text-muted">Keyword</label>
                    <input type="text" name="keyword" class="form-control form-control-sm" placeholder="e.g. AC, leak, wiring..." 
                           value="<%= (keyword != null) ? keyword : "" %>">
                </div>

                <!-- Sort By -->
                <div class="mb-3">
                    <label class="form-label small fw-semibold text-muted">Sort By</label>
                    <select name="sortBy" class="form-select form-select-sm" onchange="this.form.submit()">
                        <option value="" <%= (sortBy == null || sortBy.isEmpty()) ? "selected" : "" %>>Featured / Newest</option>
                        <option value="rating_desc" <%= "rating_desc".equalsIgnoreCase(sortBy) ? "selected" : "" %>>Highest Rated</option>
                        <option value="price_asc" <%= "price_asc".equalsIgnoreCase(sortBy) ? "selected" : "" %>>Price: Low to High</option>
                        <option value="price_desc" <%= "price_desc".equalsIgnoreCase(sortBy) ? "selected" : "" %>>Price: High to Low</option>
                    </select>
                </div>

                <!-- Categories -->
                <div class="mb-3">
                    <label class="form-label small fw-semibold text-muted mb-2">Category</label>
                    <div class="list-group list-group-flush border-0">
                        <a href="<%= request.getContextPath() %>/services?keyword=<%= (keyword != null) ? keyword : "" %>&sortBy=<%= (sortBy != null) ? sortBy : "" %>" 
                           class="list-group-item list-group-item-action d-flex justify-content-between align-items-center rounded-2 mb-1 border-0 <%= (selectedCategory == null) ? "bg-primary text-white" : "" %>">
                            <span>All Categories</span>
                        </a>
                        <% if (categories != null) {
                            for (Category cat : categories) {
                                boolean isSel = (selectedCategory != null && selectedCategory == cat.getCategoryId());
                        %>
                            <a href="<%= request.getContextPath() %>/services?category=<%= cat.getCategoryId() %>&keyword=<%= (keyword != null) ? keyword : "" %>&sortBy=<%= (sortBy != null) ? sortBy : "" %>" 
                               class="list-group-item list-group-item-action d-flex justify-content-between align-items-center rounded-2 mb-1 border-0 <%= isSel ? "bg-primary text-white" : "" %>">
                                <span><i class="bi <%= cat.getIconClass() %> me-2"></i><%= cat.getCategoryName() %></span>
                            </a>
                        <% } } %>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary-qs w-100 btn-sm">Apply Filters</button>
            </form>
        </div>
    </div>

    <!-- Services Grid -->
    <div class="col-lg-9">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="h4 fw-bold mb-0">Browse Services</h2>
                <span class="text-muted small">Showing <%= totalServices %> services available</span>
            </div>
        </div>

        <% if (services == null || services.isEmpty()) { %>
            <div class="text-center py-5 bg-white rounded-4 border">
                <i class="bi bi-search fs-1 text-muted opacity-50 mb-3 d-block"></i>
                <h5 class="fw-bold">No services found</h5>
                <p class="text-muted small">Try tweaking your search keywords or removing filters.</p>
                <a href="<%= request.getContextPath() %>/services" class="btn btn-outline-qs btn-sm">View All Services</a>
            </div>
        <% } else { %>
            <div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4">
                <% for (Service s : services) { %>
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
                <% } %>
            </div>

            <!-- Pagination -->
            <% if (totalPages > 1) { %>
                <nav class="mt-5">
                    <ul class="pagination justify-content-center">
                        <li class="page-item <%= (currentPage <= 1) ? "disabled" : "" %>">
                            <a class="page-link" href="<%= request.getContextPath() %>/services?page=<%= currentPage - 1 %><%= (selectedCategory != null) ? "&category=" + selectedCategory : "" %><%= (keyword != null) ? "&keyword=" + keyword : "" %><%= (sortBy != null) ? "&sortBy=" + sortBy : "" %>">Previous</a>
                        </li>
                        <% for (int p = 1; p <= totalPages; p++) { %>
                            <li class="page-item <%= (p == currentPage) ? "active" : "" %>">
                                <a class="page-link" href="<%= request.getContextPath() %>/services?page=<%= p %><%= (selectedCategory != null) ? "&category=" + selectedCategory : "" %><%= (keyword != null) ? "&keyword=" + keyword : "" %><%= (sortBy != null) ? "&sortBy=" + sortBy : "" %>"><%= p %></a>
                            </li>
                        <% } %>
                        <li class="page-item <%= (currentPage >= totalPages) ? "disabled" : "" %>">
                            <a class="page-link" href="<%= request.getContextPath() %>/services?page=<%= currentPage + 1 %><%= (selectedCategory != null) ? "&category=" + selectedCategory : "" %><%= (keyword != null) ? "&keyword=" + keyword : "" %><%= (sortBy != null) ? "&sortBy=" + sortBy : "" %>">Next</a>
                        </li>
                    </ul>
                </nav>
            <% } %>
        <% } %>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
