<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    String selRole = (String) request.getAttribute("selectedRole");
    if (selRole == null) selRole = "CUSTOMER";
    boolean isProvider = "PROVIDER".equalsIgnoreCase(selRole);
%>

<div class="row justify-content-center my-4">
    <div class="col-md-9 col-lg-7">
        <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="card-header bg-primary text-white text-center py-4 border-0">
                <i class="bi bi-person-plus-fill fs-1 text-white opacity-75 mb-2 d-block"></i>
                <h3 class="fw-bold mb-1">Create an Account</h3>
                <p class="small text-light opacity-75 mb-0">Join QuickServe as a customer or service professional</p>
            </div>

            <div class="card-body p-4 p-md-5">
                <!-- Role Selector Tabs -->
                <div class="d-flex p-1 bg-light rounded-3 mb-4">
                    <button type="button" class="btn <%= !isProvider ? "btn-primary shadow-sm" : "btn-light" %> flex-grow-1 fw-bold py-2" 
                            onclick="selectRole('CUSTOMER')">
                        <i class="bi bi-person me-2"></i>I Need Services (Customer)
                    </button>
                    <button type="button" class="btn <%= isProvider ? "btn-primary shadow-sm" : "btn-light" %> flex-grow-1 fw-bold py-2" 
                            onclick="selectRole('PROVIDER')">
                        <i class="bi bi-briefcase me-2"></i>I Provide Services (Partner)
                    </button>
                </div>

                <form action="<%= request.getContextPath() %>/register" method="POST">
                    <input type="hidden" name="role" id="roleInput" value="<%= selRole %>">

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Full Name</label>
                            <input type="text" name="fullName" class="form-control" placeholder="John Doe" 
                                   value="<%= (request.getAttribute("fullName") != null) ? request.getAttribute("fullName") : "" %>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Email Address</label>
                            <input type="email" name="email" class="form-control" placeholder="john@example.com" 
                                   value="<%= (request.getAttribute("email") != null) ? request.getAttribute("email") : "" %>" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Phone Number</label>
                            <input type="text" name="phone" class="form-control" placeholder="10-digit mobile number" 
                                   value="<%= (request.getAttribute("phone") != null) ? request.getAttribute("phone") : "" %>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Password (min 6 chars)</label>
                            <input type="password" name="password" class="form-control" placeholder="Create secure password" required>
                        </div>

                        <!-- Provider-Only Fields -->
                        <div id="providerFields" style="<%= isProvider ? "" : "display: none;" %>" class="col-12">
                            <div class="p-3 bg-light rounded-3 border mt-2">
                                <h6 class="fw-bold text-primary mb-3"><i class="bi bi-shop me-2"></i>Service Professional Details</h6>
                                
                                <div class="row g-3">
                                    <div class="col-md-8">
                                        <label class="form-label small fw-semibold text-muted">Business / Company Name</label>
                                        <input type="text" name="businessName" class="form-control" placeholder="e.g. Apex Electrical Solutions" 
                                               value="<%= (request.getAttribute("businessName") != null) ? request.getAttribute("businessName") : "" %>">
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label small fw-semibold text-muted">Experience (Years)</label>
                                        <input type="number" name="experienceYears" class="form-control" min="0" max="50" placeholder="5" 
                                               value="<%= (request.getAttribute("experienceYears") != null) ? request.getAttribute("experienceYears") : "1" %>">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label small fw-semibold text-muted">Profile Bio / Description</label>
                                        <textarea name="description" class="form-control" rows="3" placeholder="Tell customers about your skills, certifications, and service guarantee..."><%= (request.getAttribute("description") != null) ? request.getAttribute("description") : "" %></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-12 mt-4">
                            <button type="submit" class="btn btn-primary-qs w-100 py-2 fs-6 fw-bold shadow-sm">
                                <i class="bi bi-check-circle-fill me-2"></i>Create Account
                            </button>
                        </div>
                    </div>
                </form>

                <div class="text-center small text-muted mt-4">
                    Already registered? 
                    <a href="<%= request.getContextPath() %>/login" class="fw-bold text-primary">Login here</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function selectRole(role) {
    document.getElementById('roleInput').value = role;
    const providerFields = document.getElementById('providerFields');
    if (role === 'PROVIDER') {
        window.location.href = '<%= request.getContextPath() %>/register?role=PROVIDER';
    } else {
        window.location.href = '<%= request.getContextPath() %>/register?role=CUSTOMER';
    }
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
