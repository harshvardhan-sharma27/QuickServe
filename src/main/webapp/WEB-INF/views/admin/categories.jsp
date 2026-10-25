<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickserve.pojo.Category, java.util.List" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 fw-bold mb-1">Category Management</h1>
        <p class="text-muted mb-0">Add, edit, and manage service categories</p>
    </div>
    <button class="btn btn-primary-qs btn-sm" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
        <i class="bi bi-plus-lg me-1"></i>Add Category
    </button>
</div>

<div class="bg-white rounded-3 border shadow-sm p-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold mb-0"><i class="bi bi-tags me-2 text-primary"></i>All Categories</h5>
        <span class="badge bg-primary bg-opacity-10 text-primary fw-bold px-3"><%= categories != null ? categories.size() : 0 %></span>
    </div>
    <div class="row g-3">
        <% if (categories != null && !categories.isEmpty()) {
            for (Category c : categories) { %>
        <div class="col-md-4 col-lg-3">
            <div class="border rounded-3 p-3 bg-light d-flex align-items-center gap-3 h-100">
                <div class="bg-primary bg-opacity-10 text-primary p-2 rounded-3" style="width:44px;height:44px;display:flex;align-items:center;justify-content:center;">
                    <i class="bi <%= c.getIconClass() != null ? c.getIconClass() : "bi-gear" %> fs-5"></i>
                </div>
                <div class="flex-grow-1 min-w-0">
                    <div class="fw-bold text-truncate"><%= c.getCategoryName() %></div>
                    <div class="text-muted small text-truncate"><%= c.getDescription() != null ? c.getDescription() : "" %></div>
                </div>
                <a href="<%= cp %>/admin/categories?action=delete&id=<%= c.getCategoryId() %>"
                   class="btn btn-outline-danger btn-sm py-0 px-1"
                   onclick="return confirm('Delete category &quot;<%= c.getCategoryName() %>&quot;? This cannot be undone.')">
                    <i class="bi bi-trash"></i>
                </a>
            </div>
        </div>
        <% } } else { %>
        <div class="col-12 text-center text-muted py-4">No categories found</div>
        <% } %>
    </div>
</div>

<!-- Add Category Modal -->
<div class="modal fade" id="addCategoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content rounded-4 border-0 shadow">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold">Add New Category</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form method="POST" action="<%= cp %>/admin/categories">
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Category Name <span class="text-danger">*</span></label>
                        <input type="text" name="categoryName" class="form-control" placeholder="e.g. Electrical Services" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Description</label>
                        <textarea name="description" class="form-control" rows="2" placeholder="Brief description..."></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Bootstrap Icon Class</label>
                        <input type="text" name="iconClass" class="form-control" placeholder="e.g. bi-lightning-charge" value="bi-gear">
                        <div class="form-text">Use any <a href="https://icons.getbootstrap.com/" target="_blank">Bootstrap icon</a> class name</div>
                    </div>
                    <div class="d-flex gap-2 pt-2">
                        <button type="submit" class="btn btn-primary-qs flex-grow-1">Save Category</button>
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
