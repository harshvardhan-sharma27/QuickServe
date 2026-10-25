package com.quickserve.controller;

import com.quickserve.dto.CustomerDashboardDTO;
import com.quickserve.pojo.User;
import com.quickserve.service.BookingService;
import com.quickserve.service.impl.BookingServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "CustomerDashboardServlet", urlPatterns = {"/customer/dashboard"})
public class CustomerDashboardServlet extends HttpServlet {

    private final BookingService bookingService = new BookingServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        CustomerDashboardDTO dashboard = bookingService.getCustomerDashboard(user.getUserId());
        request.setAttribute("dashboard", dashboard);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("successMessage", msg);

        request.getRequestDispatcher("/WEB-INF/views/customer/dashboard.jsp").forward(request, response);
    }
}
