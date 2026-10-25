<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickserve.pojo.User" %>
<%
    String cp = request.getContextPath();
    User currentUser = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QuickServe - Home Services on Demand</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- QuickServe Custom CSS -->
    <link href="<%= cp %>/css/style.css" rel="stylesheet">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container">
        <!-- Logo -->
        <a class="navbar-brand" href="<%= cp %>/home">
            <i class="bi bi-tools"></i>
            <span>Quick<span class="text-dark">Serve</span></span>
        </a>

        <!-- Mobile Toggler -->
        <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#quickServeNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Navbar Content -->
        <div class="collapse navbar-collapse" id="quickServeNav">
            <!-- Global Live Search -->
            <div class="mx-lg-auto my-2 my-lg-0 search-wrapper">
                <i class="bi bi-search search-icon"></i>
                <input type="text" class="form-control search-input js-live-search" placeholder="Search electrician, cleaning, plumbing..." data-context-path="<%= cp %>" autocomplete="off">
            </div>

            <ul class="navbar-nav align-items-lg-center gap-1">
                <li class="nav-item">
                    <a class="nav-link" href="<%= cp %>/services"><i class="bi bi-grid me-1"></i>Services</a>
                </li>

                <% if (currentUser == null) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/register?role=PROVIDER"><i class="bi bi-briefcase me-1"></i>Become a Partner</a>
                    </li>
                    <li class="nav-item ms-lg-2">
                        <a href="<%= cp %>/login" class="btn btn-outline-qs btn-sm px-3">Login</a>
                    </li>
                    <li class="nav-item">
                        <a href="<%= cp %>/register" class="btn btn-primary-qs btn-sm px-3">Register</a>
                    </li>
                <% } else if ("CUSTOMER".equalsIgnoreCase(currentUser.getRole())) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/customer/dashboard"><i class="bi bi-speedometer2 me-1"></i>Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/customer/bookings"><i class="bi bi-calendar-check me-1"></i>Bookings</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/customer/notifications" title="Notifications">
                            <i class="bi bi-bell"></i>
                        </a>
                    </li>
                    <!-- Customer Dropdown -->
                    <li class="nav-item dropdown ms-lg-2">
                        <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#" role="button" data-bs-toggle="dropdown">
                            <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; font-weight: 700; font-size: 0.85rem;">
                                <%= currentUser.getFullName().substring(0, 1).toUpperCase() %>
                            </div>
                            <span class="d-none d-lg-inline small fw-semibold"><%= currentUser.getFullName() %></span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                            <li><h6 class="dropdown-header text-primary fw-bold">Customer Portal</h6></li>
                            <li><a class="dropdown-item" href="<%= cp %>/customer/dashboard"><i class="bi bi-speedometer2 me-2"></i>My Dashboard</a></li>
                            <li><a class="dropdown-item" href="<%= cp %>/customer/bookings"><i class="bi bi-calendar-check me-2"></i>Booking History</a></li>
                            <li><a class="dropdown-item" href="<%= cp %>/customer/addresses"><i class="bi bi-geo-alt me-2"></i>Manage Addresses</a></li>
                            <li><a class="dropdown-item" href="<%= cp %>/customer/support"><i class="bi bi-question-circle me-2"></i>Help & Support</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="<%= cp %>/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                        </ul>
                    </li>
                <% } else if ("PROVIDER".equalsIgnoreCase(currentUser.getRole())) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/provider/dashboard"><i class="bi bi-speedometer2 me-1"></i>Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/provider/bookings"><i class="bi bi-clipboard-check me-1"></i>Jobs</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/provider/services"><i class="bi bi-wrench me-1"></i>My Services</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/provider/availability"><i class="bi bi-calendar3 me-1"></i>Calendar</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/provider/earnings"><i class="bi bi-cash-stack me-1"></i>Earnings</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/provider/notifications" title="Notifications"><i class="bi bi-bell"></i></a>
                    </li>
                    <!-- Provider Dropdown -->
                    <li class="nav-item dropdown ms-lg-2">
                        <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#" role="button" data-bs-toggle="dropdown">
                            <span class="badge bg-warning text-dark me-1">PRO</span>
                            <span class="d-none d-lg-inline small fw-semibold"><%= currentUser.getFullName() %></span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                            <li><h6 class="dropdown-header text-primary fw-bold">Provider Portal</h6></li>
                            <li><a class="dropdown-item" href="<%= cp %>/provider/profile"><i class="bi bi-person me-2"></i>Business Profile</a></li>
                            <li><a class="dropdown-item" href="<%= cp %>/provider/reviews"><i class="bi bi-star me-2"></i>Client Reviews</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="<%= cp %>/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                        </ul>
                    </li>
                <% } else if ("ADMIN".equalsIgnoreCase(currentUser.getRole())) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/admin/dashboard"><i class="bi bi-graph-up me-1"></i>Analytics</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/admin/users"><i class="bi bi-people me-1"></i>Users</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/admin/providers"><i class="bi bi-patch-check me-1"></i>Providers</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/admin/bookings"><i class="bi bi-calendar-event me-1"></i>Bookings</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/admin/categories"><i class="bi bi-tags me-1"></i>Categories</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/admin/services"><i class="bi bi-gear-wide-connected me-1"></i>Services</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/admin/payments"><i class="bi bi-credit-card me-1"></i>Payments</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= cp %>/admin/support"><i class="bi bi-chat-left-dots me-1"></i>Tickets</a>
                    </li>
                    <li class="nav-item ms-lg-2">
                        <a href="<%= cp %>/logout" class="btn btn-outline-danger btn-sm"><i class="bi bi-box-arrow-right me-1"></i>Logout</a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<main class="py-4">
    <div class="container">
        <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    </div>
