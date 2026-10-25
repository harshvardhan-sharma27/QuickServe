package com.quickserve.controller;

import com.quickserve.pojo.Category;
import com.quickserve.pojo.Service;
import com.quickserve.pojo.User;
import com.quickserve.service.ServiceCatalogService;
import com.quickserve.service.impl.ServiceCatalogServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "ProviderServicesServlet", urlPatterns = {"/provider/services"})
public class ProviderServicesServlet extends HttpServlet {

    private final ServiceCatalogService catalogService = new ServiceCatalogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if ("toggle".equalsIgnoreCase(action) && idParam != null) {
            try {
                int serviceId = Integer.parseInt(idParam);
                Service s = catalogService.getServiceById(serviceId);
                if (s != null && s.getProviderId() == user.getUserId()) {
                    String newStatus = "ACTIVE".equalsIgnoreCase(s.getStatus()) ? "INACTIVE" : "ACTIVE";
                    catalogService.updateServiceStatus(serviceId, newStatus);
                    response.sendRedirect(request.getContextPath() + "/provider/services?msg=Status+updated");
                    return;
                }
            } catch (Exception ignored) {}
        }

        List<Service> services = catalogService.getServicesByProvider(user.getUserId());
        List<Category> categories = catalogService.getAllCategories();

        request.setAttribute("services", services);
        request.setAttribute("categories", categories);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("successMessage", msg);

        request.getRequestDispatcher("/WEB-INF/views/provider/services.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String serviceName = request.getParameter("serviceName");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String description = request.getParameter("description");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int durationMinutes = Integer.parseInt(request.getParameter("durationMinutes"));
        String imageUrl = request.getParameter("imageUrl");

        try {
            Service s = new Service();
            s.setProviderId(user.getUserId());
            s.setCategoryId(categoryId);
            s.setServiceName(serviceName);
            s.setDescription(description);
            s.setPrice(price);
            s.setDurationMinutes(durationMinutes);
            s.setStatus("ACTIVE");
            s.setImageUrl(imageUrl);

            catalogService.createService(s);
            response.sendRedirect(request.getContextPath() + "/provider/services?msg=Service+added+successfully!");

        } catch (Exception e) {
            request.setAttribute("errorMessage", e.getMessage());
            doGet(request, response);
        }
    }
}
