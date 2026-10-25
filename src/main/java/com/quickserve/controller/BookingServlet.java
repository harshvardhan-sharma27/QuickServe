package com.quickserve.controller;

import com.quickserve.dao.AddressDAO;
import com.quickserve.dao.ProviderAvailabilityDAO;
import com.quickserve.dao.impl.AddressDAOImpl;
import com.quickserve.dao.impl.ProviderAvailabilityDAOImpl;
import com.quickserve.exception.BookingException;
import com.quickserve.pojo.*;
import com.quickserve.service.BookingService;
import com.quickserve.service.ServiceCatalogService;
import com.quickserve.service.impl.BookingServiceImpl;
import com.quickserve.service.impl.ServiceCatalogServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "BookingServlet", urlPatterns = {"/customer/book-service"})
public class BookingServlet extends HttpServlet {

    private final BookingService bookingService = new BookingServiceImpl();
    private final ServiceCatalogService catalogService = new ServiceCatalogServiceImpl();
    private final AddressDAO addressDAO = new AddressDAOImpl();
    private final ProviderAvailabilityDAO availabilityDAO = new ProviderAvailabilityDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String serviceIdParam = request.getParameter("serviceId");
        if (serviceIdParam == null || serviceIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/services");
            return;
        }

        try {
            int serviceId = Integer.parseInt(serviceIdParam);
            Service service = catalogService.getServiceById(serviceId);
            if (service == null) {
                response.sendRedirect(request.getContextPath() + "/services");
                return;
            }

            List<Address> addresses = addressDAO.findByUser(user.getUserId());
            List<ProviderAvailability> slots = availabilityDAO.findByProvider(service.getProviderId());
            List<Service> providerServices = catalogService.getServicesByProvider(service.getProviderId());

            request.setAttribute("selectedService", service);
            request.setAttribute("addresses", addresses);
            request.setAttribute("slots", slots);
            request.setAttribute("providerServices", providerServices);

            request.getRequestDispatcher("/WEB-INF/views/customer/book-service.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/services");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        int providerId = Integer.parseInt(request.getParameter("providerId"));
        int addressId = Integer.parseInt(request.getParameter("addressId"));
        String dateStr = request.getParameter("bookingDate");
        String timeStr = request.getParameter("bookingTime");
        String paymentMethod = request.getParameter("paymentMethod");
        String notes = request.getParameter("notes");
        String slotIdStr = request.getParameter("availabilityId");

        String[] serviceIdStrs = request.getParameterValues("serviceIds");
        List<Integer> serviceIds = new ArrayList<>();
        if (serviceIdStrs != null) {
            for (String s : serviceIdStrs) {
                try {
                    serviceIds.add(Integer.parseInt(s));
                } catch (NumberFormatException ignored) {}
            }
        }

        Integer availabilityId = null;
        if (slotIdStr != null && !slotIdStr.trim().isEmpty()) {
            try {
                availabilityId = Integer.parseInt(slotIdStr);
            } catch (NumberFormatException ignored) {}
        }

        try {
            Date bookingDate = Date.valueOf(dateStr);
            Time bookingTime = Time.valueOf(timeStr.length() == 5 ? timeStr + ":00" : timeStr);

            int bookingId = bookingService.createBooking(
                user.getUserId(), providerId, addressId,
                bookingDate, bookingTime, serviceIds,
                paymentMethod, notes, availabilityId
            );

            response.sendRedirect(request.getContextPath() + "/customer/booking-details?id=" + bookingId + "&success=1");

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Booking failed: " + e.getMessage());
            doGet(request, response);
        }
    }
}
