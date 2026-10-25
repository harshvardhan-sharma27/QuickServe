package com.quickserve.controller;

import com.quickserve.pojo.Category;
import com.quickserve.service.ServiceCatalogService;
import com.quickserve.service.impl.ServiceCatalogServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCategoriesServlet", urlPatterns = {"/admin/categories"})
public class AdminCategoriesServlet extends HttpServlet {

    private final ServiceCatalogService catalogService = new ServiceCatalogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if ("delete".equalsIgnoreCase(action) && idParam != null) {
            try {
                int catId = Integer.parseInt(idParam);
                catalogService.deleteCategory(catId);
                response.sendRedirect(request.getContextPath() + "/admin/categories?msg=Category+deleted");
                return;
            } catch (Exception ignored) {}
        }

        List<Category> categories = catalogService.getAllCategories();
        request.setAttribute("categories", categories);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("successMessage", msg);

        request.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("categoryId");
        String name = request.getParameter("categoryName");
        String description = request.getParameter("description");
        String iconClass = request.getParameter("iconClass");

        try {
            Category c = new Category();
            if (idParam != null && !idParam.trim().isEmpty()) {
                c.setCategoryId(Integer.parseInt(idParam));
            }
            c.setCategoryName(name);
            c.setDescription(description);
            c.setIconClass(iconClass != null && !iconClass.trim().isEmpty() ? iconClass : "bi-gear");

            catalogService.saveCategory(c);
            response.sendRedirect(request.getContextPath() + "/admin/categories?msg=Category+saved+successfully");

        } catch (Exception e) {
            request.setAttribute("errorMessage", e.getMessage());
            doGet(request, response);
        }
    }
}
