package com.quickserve.controller;

import com.quickserve.dto.ProviderDashboardDTO;
import com.quickserve.pojo.ProviderProfile;
import com.quickserve.pojo.User;
import com.quickserve.service.ProviderService;
import com.quickserve.service.impl.ProviderServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ProviderDashboardServlet", urlPatterns = {"/provider/dashboard"})
public class ProviderDashboardServlet extends HttpServlet {

    private final ProviderService providerService = new ProviderServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        ProviderProfile profile = providerService.getProfile(user.getUserId());
        ProviderDashboardDTO stats = providerService.getDashboardStats(user.getUserId());

        request.setAttribute("profile", profile);
        request.setAttribute("stats", stats);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("successMessage", msg);

        request.getRequestDispatcher("/WEB-INF/views/provider/dashboard.jsp").forward(request, response);
    }
}
