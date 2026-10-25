<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.quickserve.pojo.Address" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    List<Address> addresses = (List<Address>) request.getAttribute("addresses");
%>

<div class="row g-4 mb-5">
    <div class="col-lg-7">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="h4 fw-bold mb-0"><i class="bi bi-geo-alt text-primary me-2"></i>Saved Delivery Addresses</h2>
            <span class="text-muted small"><%= (addresses != null) ? addresses.size() : 0 %> Addresses</span>
        </div>

        <% if (addresses == null || addresses.isEmpty()) { %>
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center">
                <i class="bi bi-geo-alt-fill fs-1 text-muted opacity-50 mb-3 d-block"></i>
                <h6 class="fw-bold">No saved addresses</h6>
                <p class="text-muted small">Add your home or office address to book services quickly.</p>
            </div>
        <% } else { %>
            <div class="d-flex flex-column gap-3">
                <% for (Address a : addresses) { %>
                    <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <div class="d-flex align-items-center gap-2 mb-1">
                                    <span class="fw-bold text-dark"><%= a.getCity() %></span>
                                    <% if (a.isDefault()) { %>
                                        <span class="badge bg-success bg-opacity-10 text-success small">Default Address</span>
                                    <% } %>
                                </div>
                                <div class="text-secondary small"><%= a.getAddressLine() %></div>
                                <div class="text-muted small"><%= a.getState() %> - <%= a.getPincode() %></div>
                            </div>
                            <div class="d-flex gap-2">
                                <% if (!a.isDefault()) { %>
                                    <a href="<%= request.getContextPath() %>/customer/addresses?action=default&id=<%= a.getAddressId() %>" class="btn btn-sm btn-outline-secondary">
                                        Set Default
                                    </a>
                                <% } %>
                                <a href="<%= request.getContextPath() %>/customer/addresses?action=delete&id=<%= a.getAddressId() %>" 
                                   class="btn btn-sm btn-outline-danger" 
                                   onclick="return confirm('Delete this address?');">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- Add New Address Form -->
    <div class="col-lg-5">
        <div class="card border-0 shadow-sm rounded-4 p-4">
            <h5 class="fw-bold mb-3"><i class="bi bi-plus-circle-fill text-primary me-2"></i>Add New Address</h5>
            
            <form action="<%= request.getContextPath() %>/customer/addresses" method="POST">
                <div class="mb-3">
                    <label class="form-label small fw-semibold text-muted">House / Flat / Street Address</label>
                    <textarea name="addressLine" class="form-control form-control-sm" rows="3" placeholder="Flat 402, Green Valley Apartments, Road 4..." required></textarea>
                </div>

                <div class="row g-2 mb-3">
                    <div class="col-6">
                        <label class="form-label small fw-semibold text-muted">City</label>
                        <input type="text" name="city" class="form-control form-control-sm" placeholder="Pune" required>
                    </div>
                    <div class="col-6">
                        <label class="form-label small fw-semibold text-muted">State</label>
                        <input type="text" name="state" class="form-control form-control-sm" placeholder="Maharashtra" value="Maharashtra" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-semibold text-muted">Postal PIN Code</label>
                    <input type="text" name="pincode" class="form-control form-control-sm" placeholder="411001" required>
                </div>

                <div class="form-check mb-4">
                    <input type="checkbox" name="isDefault" value="true" class="form-check-input" id="defCheck">
                    <label class="form-check-label small text-muted" for="defCheck">Make this my default address</label>
                </div>

                <button type="submit" class="btn btn-primary-qs w-100 btn-sm">Save Address</button>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
