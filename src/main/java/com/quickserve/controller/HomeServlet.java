package com.quickserve.controller;

import com.quickserve.pojo.Category;
import com.quickserve.pojo.ProviderProfile;
import com.quickserve.pojo.Service;
import com.quickserve.service.ProviderService;
import com.quickserve.service.ServiceCatalogService;
import com.quickserve.service.impl.ProviderServiceImpl;
import com.quickserve.service.impl.ServiceCatalogServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home", "/index"})
public class HomeServlet extends HttpServlet {

    private final ServiceCatalogService catalogService = new ServiceCatalogServiceImpl();
    private final ProviderService providerService = new ProviderServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = catalogService.getAllCategories();
        List<Service> featuredServices = catalogService.getServices(null, null, "rating_desc", 1, 6);
        List<ProviderProfile> featuredProviders = providerService.getFeaturedProviders(4);

        request.setAttribute("categories", categories);
        request.setAttribute("featuredServices", featuredServices);
        request.setAttribute("featuredProviders", featuredProviders);

        request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
    }
}
