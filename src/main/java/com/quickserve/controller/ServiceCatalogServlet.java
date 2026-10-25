package com.quickserve.controller;

import com.quickserve.pojo.Category;
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

@WebServlet(name = "ServiceCatalogServlet", urlPatterns = {"/services"})
public class ServiceCatalogServlet extends HttpServlet {

    private final ServiceCatalogService catalogService = new ServiceCatalogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String catParam = request.getParameter("category");
        String keyword = request.getParameter("keyword");
        String sortBy = request.getParameter("sortBy");
        String pageParam = request.getParameter("page");

        Integer categoryId = null;
        if (catParam != null && !catParam.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(catParam);
            } catch (NumberFormatException ignored) {}
        }

        int page = 1;
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {}
        }

        int pageSize = 9;
        List<Service> services = catalogService.getServices(categoryId, keyword, sortBy, page, pageSize);
        int totalServices = catalogService.getTotalServiceCount(categoryId, keyword);
        int totalPages = (int) Math.ceil((double) totalServices / pageSize);

        List<Category> categories = catalogService.getAllCategories();

        request.setAttribute("services", services);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("keyword", keyword);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalServices", totalServices);

        request.getRequestDispatcher("/WEB-INF/views/services.jsp").forward(request, response);
    }
}
