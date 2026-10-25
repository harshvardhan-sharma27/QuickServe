<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="row justify-content-center my-4">
    <div class="col-md-7 col-lg-5">
        <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="card-header bg-primary text-white text-center py-4 border-0">
                <i class="bi bi-shield-lock-fill fs-1 text-white opacity-75 mb-2 d-block"></i>
                <h3 class="fw-bold mb-1">Welcome Back</h3>
                <p class="small text-light opacity-75 mb-0">Sign in to your QuickServe account</p>
            </div>
            
            <div class="card-body p-4 p-md-5">
                <form action="<%= request.getContextPath() %>/login" method="POST">
                    <input type="hidden" name="redirect" value="<%= (request.getAttribute("redirect") != null) ? request.getAttribute("redirect") : "" %>">

                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-muted">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-envelope text-muted"></i></span>
                            <input type="email" name="email" id="loginEmail" class="form-control border-start-0" 
                                   placeholder="name@example.com" 
                                   value="<%= (request.getAttribute("email") != null) ? request.getAttribute("email") : "" %>" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <label class="form-label small fw-semibold text-muted mb-0">Password</label>
                            <span class="text-muted small">BCrypt Secured</span>
                        </div>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-key text-muted"></i></span>
                            <input type="password" name="password" id="loginPassword" class="form-control border-start-0" 
                                   placeholder="Enter your password" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary-qs w-100 py-2 fs-6 fw-bold mb-3 shadow-sm">
                        <i class="bi bi-box-arrow-in-right me-2"></i>Sign In
                    </button>
                </form>

                <div class="text-center small text-muted mt-2 mb-4">
                    Don't have an account? 
                    <a href="<%= request.getContextPath() %>/register" class="fw-bold text-primary">Sign up here</a>
                </div>

                <!-- 1-Click Demo Login Box -->
                <div class="p-3 bg-light rounded-3 border">
                    <div class="fw-bold text-dark small mb-2 d-flex align-items-center">
                        <i class="bi bi-lightning-charge-fill text-warning me-1"></i> Quick Demo Logins (Click to Autofill)
                    </div>
                    <div class="d-grid gap-2">
                        <button type="button" class="btn btn-outline-danger btn-sm text-start d-flex justify-content-between align-items-center"
                                onclick="fillCreds('admin@quickserve.com', 'Admin@123')">
                            <span><i class="bi bi-shield-lock me-1"></i> <strong>Admin</strong> (System Admin)</span>
                            <span class="badge bg-danger">Admin@123</span>
                        </button>
                        <button type="button" class="btn btn-outline-warning btn-sm text-start d-flex justify-content-between align-items-center"
                                onclick="fillCreds('rahul.electric@quickserve.com', 'Password@123')">
                            <span><i class="bi bi-lightning me-1"></i> <strong>Provider</strong> (Rahul - Electrician)</span>
                            <span class="badge bg-secondary">Password@123</span>
                        </button>
                        <button type="button" class="btn btn-outline-info btn-sm text-start d-flex justify-content-between align-items-center"
                                onclick="fillCreds('priya.clean@quickserve.com', 'Password@123')">
                            <span><i class="bi bi-stars me-1"></i> <strong>Provider</strong> (Priya - Deep Cleaning)</span>
                            <span class="badge bg-secondary">Password@123</span>
                        </button>
                        <button type="button" class="btn btn-outline-primary btn-sm text-start d-flex justify-content-between align-items-center"
                                onclick="fillCreds('harsh@quickserve.com', 'Password@123')">
                            <span><i class="bi bi-person me-1"></i> <strong>Customer</strong> (Harshvardhan)</span>
                            <span class="badge bg-secondary">Password@123</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function fillCreds(email, pass) {
    document.getElementById('loginEmail').value = email;
    document.getElementById('loginPassword').value = pass;
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
