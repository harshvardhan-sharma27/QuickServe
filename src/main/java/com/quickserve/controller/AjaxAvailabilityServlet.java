package com.quickserve.controller;

import com.quickserve.dao.ProviderAvailabilityDAO;
import com.quickserve.dao.impl.ProviderAvailabilityDAOImpl;
import com.quickserve.pojo.ProviderAvailability;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "AjaxAvailabilityServlet", urlPatterns = {"/api/provider-slots"})
public class AjaxAvailabilityServlet extends HttpServlet {

    private final ProviderAvailabilityDAO availabilityDAO = new ProviderAvailabilityDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String providerIdParam = request.getParameter("providerId");
        String dateParam = request.getParameter("date");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (providerIdParam == null || dateParam == null) {
            out.print("[]");
            return;
        }

        try {
            int providerId = Integer.parseInt(providerIdParam);
            Date date = Date.valueOf(dateParam);
            List<ProviderAvailability> slots = availabilityDAO.findAvailableByProviderAndDate(providerId, date);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < slots.size(); i++) {
                ProviderAvailability slot = slots.get(i);
                if (i > 0) json.append(",");
                json.append("{")
                    .append("\"id\":").append(slot.getAvailabilityId()).append(",")
                    .append("\"startTime\":\"").append(slot.getStartTime().toString().substring(0, 5)).append("\",")
                    .append("\"endTime\":\"").append(slot.getEndTime().toString().substring(0, 5)).append("\"")
                    .append("}");
            }
            json.append("]");
            out.print(json.toString());

        } catch (Exception e) {
            out.print("[]");
        }
    }
}
