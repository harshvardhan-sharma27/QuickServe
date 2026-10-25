package com.quickserve.controller;

import com.quickserve.pojo.Service;
import com.quickserve.service.ServiceCatalogService;
import com.quickserve.service.impl.ServiceCatalogServiceImpl;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "AjaxSearchServlet", urlPatterns = {"/api/search-services"})
public class AjaxSearchServlet extends HttpServlet {

    private final ServiceCatalogService catalogService = new ServiceCatalogServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String query = request.getParameter("q");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        if (query == null || query.trim().length() < 2) {
            out.print("[]");
            return;
        }

        List<Service> services = catalogService.getServices(null, query.trim(), null, 1, 6);
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < services.size(); i++) {
            Service s = services.get(i);
            if (i > 0) json.append(",");
            json.append("{")
                .append("\"id\":").append(s.getServiceId()).append(",")
                .append("\"name\":").append(escapeJson(s.getServiceName())).append(",")
                .append("\"category\":").append(escapeJson(s.getCategoryName())).append(",")
                .append("\"provider\":").append(escapeJson(s.getProviderBusinessName())).append(",")
                .append("\"price\":").append(s.getPrice()).append(",")
                .append("\"rating\":").append(s.getProviderRating())
                .append("}");
        }
        json.append("]");
        out.print(json.toString());
    }

    private String escapeJson(String str) {
        if (str == null) return "\"\"";
        return "\"" + str.replace("\\", "\\\\")
                         .replace("\"", "\\\"")
                         .replace("\n", "\\n")
                         .replace("\r", "\\r") + "\"";
    }
}
