<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickserve.pojo.ProviderProfile, com.quickserve.pojo.User" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    ProviderProfile profile = (ProviderProfile) request.getAttribute("profile");
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 fw-bold mb-1">Business Profile</h1>
        <p class="text-muted mb-0">Update your business information and profile details</p>
    </div>
    <% if (profile != null && profile.getVerificationStatus() != null) { %>
    <span class="badge bg-<%= "APPROVED".equals(profile.getVerificationStatus()) ? "success" : "REJECTED".equals(profile.getVerificationStatus()) ? "danger" : "warning text-dark" %> bg-opacity-10 text-<%= "APPROVED".equals(profile.getVerificationStatus()) ? "success" : "REJECTED".equals(profile.getVerificationStatus()) ? "danger" : "warning" %> fw-semibold px-3 py-2 rounded-3">
        <i class="bi bi-patch-check me-1"></i><%= profile.getVerificationStatus() %>
    </span>
    <% } %>
</div>

<div class="row g-4">
    <div class="col-lg-8">
        <div class="bg-white rounded-3 border shadow-sm p-4">
            <h5 class="fw-bold mb-4"><i class="bi bi-person-badge me-2 text-primary"></i>Edit Profile</h5>
            <form method="POST" action="<%= cp %>/provider/profile">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">Full Name <span class="text-danger">*</span></label>
                        <input type="text" name="fullName" class="form-control" value="<%= currentUser != null ? currentUser.getFullName() : "" %>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">Phone</label>
                        <input type="tel" name="phone" class="form-control" value="<%= currentUser != null && currentUser.getPhone() != null ? currentUser.getPhone() : "" %>">
                    </div>
                    <div class="col-md-8">
                        <label class="form-label fw-semibold small">Business Name <span class="text-danger">*</span></label>
                        <input type="text" name="businessName" class="form-control" value="<%= profile != null && profile.getBusinessName() != null ? profile.getBusinessName() : "" %>" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold small">Experience (Years)</label>
                        <input type="number" name="experienceYears" class="form-control" min="0" max="50" value="<%= profile != null ? profile.getExperienceYears() : 0 %>">
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-semibold small">Business Description</label>
                        <textarea name="description" class="form-control" rows="4" placeholder="Describe your services, expertise, and why customers should choose you..."><%= profile != null && profile.getDescription() != null ? profile.getDescription() : "" %></textarea>
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary-qs px-4">
                            <i class="bi bi-save me-2"></i>Save Changes
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="col-lg-4">
        <div class="bg-white rounded-3 border shadow-sm p-4 mb-3">
            <h6 class="fw-bold mb-3"><i class="bi bi-graph-up me-2 text-success"></i>Profile Stats</h6>
            <div class="d-flex justify-content-between py-2 border-bottom">
                <span class="text-muted small">Rating</span>
                <span class="fw-bold text-warning"><i class="bi bi-star-fill me-1"></i><%= profile != null ? String.format("%.1f", profile.getRating()) : "N/A" %></span>
            </div>
            <div class="d-flex justify-content-between py-2 border-bottom">
                <span class="text-muted small">Experience</span>
                <span class="fw-bold"><%= profile != null ? profile.getExperienceYears() : 0 %> yrs</span>
            </div>
            <div class="d-flex justify-content-between py-2">
                <span class="text-muted small">Account Email</span>
                <span class="fw-semibold small text-truncate ms-2"><%= currentUser != null ? currentUser.getEmail() : "—" %></span>
            </div>
        </div>

        <div class="bg-primary bg-opacity-5 border border-primary border-opacity-25 rounded-3 p-3">
            <h6 class="fw-semibold text-primary mb-2"><i class="bi bi-info-circle me-1"></i>Verification Note</h6>
            <p class="small text-muted mb-0">
                Your profile must be approved by admin before customers can book your services.
                <% if (profile != null && "PENDING".equals(profile.getVerificationStatus())) { %>
                Your profile is <strong>under review</strong>.
                <% } else if (profile != null && "APPROVED".equals(profile.getVerificationStatus())) { %>
                Your profile is <strong class="text-success">approved</strong> and visible to customers!
                <% } %>
            </p>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
