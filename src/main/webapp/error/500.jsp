<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Server Error | QuickServe</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/css/style.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center min-vh-100">
    <div class="text-center p-4" style="max-width: 520px;">
        <div class="display-1 fw-bold text-warning mb-2">500</div>
        <h2 class="fw-bold mb-3">Something Went Wrong</h2>
        <p class="text-muted mb-4">
            Our server encountered an unexpected error while processing your request. Please try again or return home.
        </p>
        <div class="d-flex justify-content-center gap-3">
            <a href="<%= request.getContextPath() %>/home" class="btn btn-primary-qs px-4">
                <i class="bi bi-house-door me-2"></i>Go to Home
            </a>
            <a href="<%= request.getContextPath() %>/services" class="btn btn-outline-qs px-4">
                <i class="bi bi-arrow-repeat me-2"></i>Browse Services
            </a>
        </div>
    </div>
</body>
</html>
