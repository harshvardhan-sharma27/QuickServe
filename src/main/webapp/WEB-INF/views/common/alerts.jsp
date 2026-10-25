<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String err = (String) request.getAttribute("errorMessage");
    String succ = (String) request.getAttribute("successMessage");
    String warn = (String) request.getAttribute("warningMessage");
    if (err == null) err = request.getParameter("error");
    if (succ == null) succ = request.getParameter("msg");
%>
<% if (err != null && !err.trim().isEmpty()) { %>
    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-4" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
        <div><%= err %></div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
<% } %>
<% if (succ != null && !succ.trim().isEmpty()) { %>
    <div class="alert alert-success alert-dismissible fade show d-flex align-items-center mb-4" role="alert">
        <i class="bi bi-check-circle-fill me-2 fs-5"></i>
        <div><%= succ %></div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
<% } %>
<% if (warn != null && !warn.trim().isEmpty()) { %>
    <div class="alert alert-warning alert-dismissible fade show d-flex align-items-center mb-4" role="alert">
        <i class="bi bi-info-circle-fill me-2 fs-5"></i>
        <div><%= warn %></div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
<% } %>
