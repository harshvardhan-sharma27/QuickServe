<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickserve.pojo.Service, java.util.List" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    List<Service> services = (List<Service>) request.getAttribute("services");
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 fw-bold mb-1">Service Management</h1>
        <p class="text-muted mb-0">View and moderate all platform services</p>
    </div>
    <span class="badge bg-primary bg-opacity-10 text-primary fw-bold px-3 py-2 rounded-3"><%= services != null ? services.size() : 0 %> services</span>
</div>

<div class="bg-white rounded-3 border shadow-sm p-4">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
                <tr><th>#ID</th><th>Service Name</th><th>Provider</th><th>Category</th><th>Price</th><th>Duration</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
                <% if (services != null && !services.isEmpty()) {
                    for (Service s : services) {
                        String sStatus = s.getStatus() != null ? s.getStatus() : "ACTIVE"; %>
                <tr>
                    <td><span class="badge bg-light text-dark border"><%= s.getServiceId() %></span></td>
                    <td>
                        <div class="fw-semibold"><%= s.getServiceName() %></div>
                        <div class="text-muted small text-truncate" style="max-width:200px"><%= s.getDescription() != null ? s.getDescription() : "" %></div>
                    </td>
                    <td class="text-muted small"><%= s.getProviderBusinessName() != null ? s.getProviderBusinessName() : "—" %></td>
                    <td><span class="badge bg-primary bg-opacity-10 text-primary"><%= s.getCategoryName() != null ? s.getCategoryName() : "—" %></span></td>
                    <td class="fw-bold text-success">&#8377;<%= s.getPrice() %></td>
                    <td class="text-muted small"><%= s.getDurationMinutes() %> min</td>
                    <td>
                        <span class="badge bg-<%= "ACTIVE".equals(sStatus) ? "success" : "secondary" %> bg-opacity-15 text-<%= "ACTIVE".equals(sStatus) ? "success" : "secondary" %> fw-semibold">
                            <%= sStatus %>
                        </span>
                    </td>
                    <td>
                        <% if ("ACTIVE".equals(sStatus)) { %>
                        <a href="<%= cp %>/admin/services?action=status&id=<%= s.getServiceId() %>&status=INACTIVE"
                           class="btn btn-outline-warning btn-sm py-0 px-2"
                           onclick="return confirm('Deactivate this service?')">Deactivate</a>
                        <% } else { %>
                        <a href="<%= cp %>/admin/services?action=status&id=<%= s.getServiceId() %>&status=ACTIVE"
                           class="btn btn-outline-success btn-sm py-0 px-2">Activate</a>
                        <% } %>
                    </td>
                </tr>
                <% } } else { %>
                <tr><td colspan="8" class="text-center text-muted py-4">No services found</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
