<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickserve.pojo.ProviderProfile, java.util.List" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    List<ProviderProfile> providers = (List<ProviderProfile>) request.getAttribute("providers");
    String selectedFilter = (String) request.getAttribute("selectedFilter");
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 fw-bold mb-1">Provider Management</h1>
        <p class="text-muted mb-0">Review and verify service provider profiles</p>
    </div>
</div>

<!-- Filters -->
<div class="bg-white rounded-3 border shadow-sm p-3 mb-4">
    <div class="d-flex flex-wrap gap-2">
        <a href="<%= cp %>/admin/providers" class="btn btn-sm <%= selectedFilter == null ? "btn-primary-qs" : "btn-outline-secondary" %>">All</a>
        <a href="<%= cp %>/admin/providers?filter=PENDING" class="btn btn-sm <%= "PENDING".equals(selectedFilter) ? "btn-warning text-dark" : "btn-outline-warning" %>">Pending Verification</a>
        <a href="<%= cp %>/admin/providers?filter=APPROVED" class="btn btn-sm <%= "APPROVED".equals(selectedFilter) ? "btn-success" : "btn-outline-success" %>">Approved</a>
        <a href="<%= cp %>/admin/providers?filter=REJECTED" class="btn btn-sm <%= "REJECTED".equals(selectedFilter) ? "btn-danger" : "btn-outline-danger" %>">Rejected</a>
    </div>
</div>

<div class="bg-white rounded-3 border shadow-sm p-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold mb-0"><i class="bi bi-patch-check me-2 text-primary"></i>Providers</h5>
        <span class="badge bg-primary bg-opacity-10 text-primary fw-bold px-3"><%= (providers != null ? providers.size() : 0) %> found</span>
    </div>
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
                <tr><th>#ID</th><th>Business Name</th><th>Experience</th><th>Rating</th><th>Verification</th><th>Actions</th></tr>
            </thead>
            <tbody>
                <% if (providers != null && !providers.isEmpty()) {
                    for (ProviderProfile p : providers) {
                        String vs = p.getVerificationStatus() != null ? p.getVerificationStatus() : "PENDING"; %>
                <tr>
                    <td><span class="badge bg-light text-dark border"><%= p.getProviderId() %></span></td>
                    <td>
                        <div class="fw-semibold"><%= p.getBusinessName() != null ? p.getBusinessName() : "—" %></div>
                        <div class="text-muted small text-truncate" style="max-width:220px"><%= p.getDescription() != null ? p.getDescription() : "" %></div>
                    </td>
                    <td class="text-muted"><%= p.getExperienceYears() %> yrs</td>
                    <td>
                        <span class="text-warning fw-bold"><i class="bi bi-star-fill me-1"></i><%= String.format("%.1f", p.getRating()) %></span>
                    </td>
                    <td>
                        <span class="badge bg-<%= "APPROVED".equals(vs) ? "success" : "REJECTED".equals(vs) ? "danger" : "warning text-dark" %> bg-opacity-15 text-<%= "APPROVED".equals(vs) ? "success" : "REJECTED".equals(vs) ? "danger" : "warning" %> fw-semibold">
                            <%= vs %>
                        </span>
                    </td>
                    <td>
                        <% if (!"APPROVED".equals(vs)) { %>
                        <a href="<%= cp %>/admin/providers?action=verify&id=<%= p.getProviderId() %>&status=APPROVED"
                           class="btn btn-outline-success btn-sm py-0 px-2 me-1"
                           onclick="return confirm('Approve this provider?')">Approve</a>
                        <% } %>
                        <% if (!"REJECTED".equals(vs)) { %>
                        <a href="<%= cp %>/admin/providers?action=verify&id=<%= p.getProviderId() %>&status=REJECTED"
                           class="btn btn-outline-danger btn-sm py-0 px-2"
                           onclick="return confirm('Reject this provider?')">Reject</a>
                        <% } %>
                    </td>
                </tr>
                <% } } else { %>
                <tr><td colspan="6" class="text-center text-muted py-4">No providers found</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
