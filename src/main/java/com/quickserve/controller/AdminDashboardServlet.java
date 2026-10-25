package com.quickserve.controller;

import com.quickserve.dto.DashboardDTO;
import com.quickserve.service.AdminDashboardService;
import com.quickserve.service.impl.AdminDashboardServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private final AdminDashboardService dashboardService = new AdminDashboardServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DashboardDTO stats = dashboardService.getDashboardData();
        request.setAttribute("stats", stats);

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}
