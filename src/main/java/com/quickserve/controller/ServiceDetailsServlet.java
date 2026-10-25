package com.quickserve.controller;

import com.quickserve.pojo.ProviderProfile;
import com.quickserve.pojo.Review;
import com.quickserve.pojo.Service;
import com.quickserve.service.ProviderService;
import com.quickserve.service.ReviewService;
import com.quickserve.service.ServiceCatalogService;
import com.quickserve.service.impl.ProviderServiceImpl;
import com.quickserve.service.impl.ReviewServiceImpl;
import com.quickserve.service.impl.ServiceCatalogServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ServiceDetailsServlet", urlPatterns = {"/service-details"})
public class ServiceDetailsServlet extends HttpServlet {

    private final ServiceCatalogService catalogService = new ServiceCatalogServiceImpl();
    private final ProviderService providerService = new ProviderServiceImpl();
    private final ReviewService reviewService = new ReviewServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/services");
            return;
        }

        try {
            int serviceId = Integer.parseInt(idParam);
            Service service = catalogService.getServiceById(serviceId);
            if (service == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Service not found.");
                return;
            }

            ProviderProfile provider = providerService.getProfile(service.getProviderId());
            List<Service> providerOtherServices = catalogService.getServicesByProvider(service.getProviderId());
            List<Review> reviews = reviewService.getReviewsByProvider(service.getProviderId());

            request.setAttribute("service", service);
            request.setAttribute("provider", provider);
            request.setAttribute("providerOtherServices", providerOtherServices);
            request.setAttribute("reviews", reviews);

            request.getRequestDispatcher("/WEB-INF/views/service-details.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/services");
        }
    }
}
