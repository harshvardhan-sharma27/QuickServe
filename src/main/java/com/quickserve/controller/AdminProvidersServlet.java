package com.quickserve.controller;

import com.quickserve.pojo.ProviderProfile;
import com.quickserve.service.ProviderService;
import com.quickserve.service.impl.ProviderServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminProvidersServlet", urlPatterns = {"/admin/providers"})
public class AdminProvidersServlet extends HttpServlet {

    private final ProviderService providerService = new ProviderServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        String statusParam = request.getParameter("status");

        if ("verify".equalsIgnoreCase(action) && idParam != null && statusParam != null) {
            try {
                int providerId = Integer.parseInt(idParam);
                providerService.updateVerificationStatus(providerId, statusParam);
                response.sendRedirect(request.getContextPath() + "/admin/providers?msg=Provider+verification+updated+to+" + statusParam);
                return;
            } catch (Exception ignored) {}
        }

        String filter = request.getParameter("filter");
        List<ProviderProfile> providers = providerService.getAllProviders(filter);

        request.setAttribute("providers", providers);
        request.setAttribute("selectedFilter", filter);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("successMessage", msg);

        request.getRequestDispatcher("/WEB-INF/views/admin/providers.jsp").forward(request, response);
    }
}
