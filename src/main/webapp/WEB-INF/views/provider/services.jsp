<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.quickserve.pojo.Service" %>
<%@ page import="com.quickserve.pojo.Category" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    List<Service> services = (List<Service>) request.getAttribute("services");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>

<div class="row g-4 mb-5">
    <div class="col-lg-8">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h2 class="h4 fw-bold mb-0"><i class="bi bi-wrench-adjustable text-primary me-2"></i>My Service Offerings</h2>
                <span class="text-muted small">Manage services listed under your business profile</span>
            </div>
            <span class="badge bg-primary px-3 py-2"><%= (services != null) ? services.size() : 0 %> Listed</span>
        </div>

        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
            <div class="table-responsive">
                <table class="table table-custom mb-0">
                    <thead>
                        <tr>
                            <th>Service Name</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Duration</th>
                            <th>Status</th>
                            <th class="text-end">Toggle</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (services != null && !services.isEmpty()) {
                            for (Service s : services) { %>
                            <tr>
                                <td>
                                    <div class="fw-bold text-dark"><%= s.getServiceName() %></div>
                                    <div class="text-muted small text-truncate" style="max-width: 250px;"><%= s.getDescription() %></div>
                                </td>
                                <td><span class="badge bg-light text-dark"><%= s.getCategoryName() %></span></td>
                                <td class="fw-bold">&#8377;<%= s.getPrice() %></td>
                                <td><%= s.getDurationMinutes() %>m</td>
                                <td>
                                    <span class="badge-status <%= s.getStatus() %>"><%= s.getStatus() %></span>
                                </td>
                                <td class="text-end">
                                    <a href="<%= request.getContextPath() %>/provider/services?action=toggle&id=<%= s.getServiceId() %>" 
                                       class="btn btn-sm <%= "ACTIVE".equalsIgnoreCase(s.getStatus()) ? "btn-outline-danger" : "btn-outline-success" %>">
                                        <%= "ACTIVE".equalsIgnoreCase(s.getStatus()) ? "Deactivate" : "Activate" %>
                                    </a>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">
                                    You have not added any services yet. Add your first service using the form.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Add Service Form -->
    <div class="col-lg-4">
        <div class="card border-0 shadow-sm rounded-4 p-4">
            <h5 class="fw-bold mb-3"><i class="bi bi-plus-circle-fill text-primary me-2"></i>Add New Service</h5>

            <form action="<%= request.getContextPath() %>/provider/services" method="POST">
                <div class="mb-3">
                    <label class="form-label small fw-semibold text-muted">Service Title</label>
                    <input type="text" name="serviceName" class="form-control form-control-sm" placeholder="e.g. Split AC Jet Wash" required>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-semibold text-muted">Category</label>
                    <select name="categoryId" class="form-select form-select-sm" required>
                        <option value="">-- Choose Category --</option>
                        <% if (categories != null) {
                            for (Category c : categories) { %>
                                <option value="<%= c.getCategoryId() %>"><%= c.getCategoryName() %></option>
                        <% } } %>
                    </select>
                </div>

                <div class="row g-2 mb-3">
                    <div class="col-6">
                        <label class="form-label small fw-semibold text-muted">Price (&#8377;)</label>
                        <input type="number" step="0.01" name="price" class="form-control form-control-sm" placeholder="499.00" required>
                    </div>
                    <div class="col-6">
                        <label class="form-label small fw-semibold text-muted">Est. Duration (Mins)</label>
                        <input type="number" name="durationMinutes" class="form-control form-control-sm" placeholder="45" value="45" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-semibold text-muted">Image URL (Unsplash or CDN)</label>
                    <input type="url" name="imageUrl" class="form-control form-control-sm" placeholder="https://images.unsplash.com/photo-...">
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-semibold text-muted">Detailed Description</label>
                    <textarea name="description" class="form-control form-control-sm" rows="3" placeholder="What does this service include?" required></textarea>
                </div>

                <button type="submit" class="btn btn-primary-qs w-100 btn-sm">Add Service</button>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
