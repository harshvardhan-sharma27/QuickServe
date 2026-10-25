package com.quickserve.controller;

import com.quickserve.pojo.Service;
import com.quickserve.service.ServiceCatalogService;
import com.quickserve.service.impl.ServiceCatalogServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminServicesServlet", urlPatterns = {"/admin/services"})
public class AdminServicesServlet extends HttpServlet {

    private final ServiceCatalogService catalogService = new ServiceCatalogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        String statusParam = request.getParameter("status");

        if ("status".equalsIgnoreCase(action) && idParam != null && statusParam != null) {
            try {
                int serviceId = Integer.parseInt(idParam);
                catalogService.updateServiceStatus(serviceId, statusParam);
                response.sendRedirect(request.getContextPath() + "/admin/services?msg=Service+status+updated+to+" + statusParam);
                return;
            } catch (Exception ignored) {}
        }

        List<Service> services = catalogService.getAllServicesForAdmin();
        request.setAttribute("services", services);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("successMessage", msg);

        request.getRequestDispatcher("/WEB-INF/views/admin/services.jsp").forward(request, response);
    }
}
