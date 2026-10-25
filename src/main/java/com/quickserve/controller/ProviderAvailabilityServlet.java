package com.quickserve.controller;

import com.quickserve.dao.ProviderAvailabilityDAO;
import com.quickserve.dao.impl.ProviderAvailabilityDAOImpl;
import com.quickserve.pojo.ProviderAvailability;
import com.quickserve.pojo.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

@WebServlet(name = "ProviderAvailabilityServlet", urlPatterns = {"/provider/availability"})
public class ProviderAvailabilityServlet extends HttpServlet {

    private final ProviderAvailabilityDAO availabilityDAO = new ProviderAvailabilityDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if ("delete".equalsIgnoreCase(action) && idParam != null) {
            try {
                int slotId = Integer.parseInt(idParam);
                availabilityDAO.delete(slotId, user.getUserId());
                response.sendRedirect(request.getContextPath() + "/provider/availability?msg=Slot+deleted");
                return;
            } catch (Exception ignored) {}
        }

        List<ProviderAvailability> slots = availabilityDAO.findByProvider(user.getUserId());
        request.setAttribute("slots", slots);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("successMessage", msg);

        request.getRequestDispatcher("/WEB-INF/views/provider/availability.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String dateStr = request.getParameter("availableDate");
        String startStr = request.getParameter("startTime");
        String endStr = request.getParameter("endTime");

        try {
            Date date = Date.valueOf(dateStr);
            Time start = Time.valueOf(startStr.length() == 5 ? startStr + ":00" : startStr);
            Time end = Time.valueOf(endStr.length() == 5 ? endStr + ":00" : endStr);

            ProviderAvailability slot = new ProviderAvailability();
            slot.setProviderId(user.getUserId());
            slot.setAvailableDate(date);
            slot.setStartTime(start);
            slot.setEndTime(end);
            slot.setStatus("AVAILABLE");

            availabilityDAO.create(slot);
            response.sendRedirect(request.getContextPath() + "/provider/availability?msg=Availability+slot+added");

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Invalid date/time input: " + e.getMessage());
            doGet(request, response);
        }
    }
}
