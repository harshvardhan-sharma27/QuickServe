<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickserve.pojo.User, java.util.List" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    List<User> users = (List<User>) request.getAttribute("users");
    String roleFilter = (String) request.getAttribute("roleFilter");
    String statusFilter = (String) request.getAttribute("statusFilter");
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 fw-bold mb-1">User Management</h1>
        <p class="text-muted mb-0">View, filter, and manage all platform users</p>
    </div>
</div>

<!-- Filters -->
<div class="bg-white rounded-3 border shadow-sm p-3 mb-4">
    <form method="GET" action="<%= cp %>/admin/users" class="row g-2 align-items-end">
        <div class="col-auto">
            <label class="form-label small fw-semibold">Role</label>
            <select name="role" class="form-select form-select-sm">
                <option value="">All Roles</option>
                <option value="CUSTOMER" <%= "CUSTOMER".equals(roleFilter) ? "selected" : "" %>>Customer</option>
                <option value="PROVIDER" <%= "PROVIDER".equals(roleFilter) ? "selected" : "" %>>Provider</option>
                <option value="ADMIN" <%= "ADMIN".equals(roleFilter) ? "selected" : "" %>>Admin</option>
            </select>
        </div>
        <div class="col-auto">
            <label class="form-label small fw-semibold">Status</label>
            <select name="statusFilter" class="form-select form-select-sm">
                <option value="">All Status</option>
                <option value="ACTIVE" <%= "ACTIVE".equals(statusFilter) ? "selected" : "" %>>Active</option>
                <option value="INACTIVE" <%= "INACTIVE".equals(statusFilter) ? "selected" : "" %>>Inactive</option>
                <option value="SUSPENDED" <%= "SUSPENDED".equals(statusFilter) ? "selected" : "" %>>Suspended</option>
            </select>
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-primary-qs btn-sm">Apply Filters</button>
            <a href="<%= cp %>/admin/users" class="btn btn-outline-secondary btn-sm ms-1">Reset</a>
        </div>
    </form>
</div>

<!-- User Table -->
<div class="bg-white rounded-3 border shadow-sm p-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold mb-0"><i class="bi bi-people me-2 text-primary"></i>All Users</h5>
        <span class="badge bg-primary bg-opacity-10 text-primary fw-bold px-3"><%= (users != null ? users.size() : 0) %> found</span>
    </div>
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
                <tr>
                    <th>#ID</th><th>Full Name</th><th>Email</th><th>Phone</th>
                    <th>Role</th><th>Status</th><th>Joined</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (users != null && !users.isEmpty()) {
                    for (User u : users) { %>
                <tr>
                    <td><span class="badge bg-light text-dark border"><%= u.getUserId() %></span></td>
                    <td class="fw-semibold"><%= u.getFullName() %></td>
                    <td class="text-muted small"><%= u.getEmail() %></td>
                    <td class="text-muted small"><%= u.getPhone() != null ? u.getPhone() : "—" %></td>
                    <td>
                        <span class="badge bg-<%= "ADMIN".equals(u.getRole()) ? "danger" : "PROVIDER".equals(u.getRole()) ? "warning text-dark" : "primary" %> bg-opacity-15 text-<%= "ADMIN".equals(u.getRole()) ? "danger" : "PROVIDER".equals(u.getRole()) ? "warning" : "primary" %> fw-semibold">
                            <%= u.getRole() %>
                        </span>
                    </td>
                    <td>
                        <span class="badge bg-<%= "ACTIVE".equals(u.getStatus()) ? "success" : "SUSPENDED".equals(u.getStatus()) ? "danger" : "secondary" %> bg-opacity-15 text-<%= "ACTIVE".equals(u.getStatus()) ? "success" : "SUSPENDED".equals(u.getStatus()) ? "danger" : "secondary" %> fw-semibold">
                            <%= u.getStatus() != null ? u.getStatus() : "ACTIVE" %>
                        </span>
                    </td>
                    <td class="text-muted small"><%= u.getCreatedAt() != null ? u.getCreatedAt().toString().substring(0,10) : "—" %></td>
                    <td>
                        <% if (!"ADMIN".equals(u.getRole())) { %>
                            <% if ("ACTIVE".equals(u.getStatus()) || u.getStatus() == null) { %>
                            <a href="<%= cp %>/admin/users?action=status&id=<%= u.getUserId() %>&status=SUSPENDED"
                               class="btn btn-outline-danger btn-sm py-0 px-2"
                               onclick="return confirm('Suspend this user?')">Suspend</a>
                            <% } else { %>
                            <a href="<%= cp %>/admin/users?action=status&id=<%= u.getUserId() %>&status=ACTIVE"
                               class="btn btn-outline-success btn-sm py-0 px-2">Activate</a>
                            <% } %>
                        <% } else { %>
                        <span class="text-muted small">—</span>
                        <% } %>
                    </td>
                </tr>
                <% } } else { %>
                <tr><td colspan="8" class="text-center text-muted py-4">No users found</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
