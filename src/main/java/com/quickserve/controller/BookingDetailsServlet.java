package com.quickserve.controller;

import com.quickserve.pojo.Booking;
import com.quickserve.pojo.User;
import com.quickserve.service.BookingService;
import com.quickserve.service.impl.BookingServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "BookingDetailsServlet", urlPatterns = {"/customer/booking-details", "/provider/booking-details"})
public class BookingDetailsServlet extends HttpServlet {

    private final BookingService bookingService = new BookingServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            redirectDashboard(user, response, request.getContextPath());
            return;
        }

        try {
            int bookingId = Integer.parseInt(idParam);
            Booking booking = bookingService.getBookingDetails(bookingId);

            if (booking == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found.");
                return;
            }

            // Authorization check
            if ("CUSTOMER".equalsIgnoreCase(user.getRole()) && booking.getCustomerId() != user.getUserId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied.");
                return;
            }
            if ("PROVIDER".equalsIgnoreCase(user.getRole()) && booking.getProviderId() != user.getUserId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied.");
                return;
            }

            request.setAttribute("booking", booking);

            if (request.getParameter("success") != null) {
                request.setAttribute("successMessage", "Booking confirmed successfully! Your provider has been notified.");
            }

            request.getRequestDispatcher("/WEB-INF/views/customer/booking-details.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            redirectDashboard(user, response, request.getContextPath());
        }
    }

    private void redirectDashboard(User user, HttpServletResponse response, String cp) throws IOException {
        if ("PROVIDER".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(cp + "/provider/dashboard");
        } else {
            response.sendRedirect(cp + "/customer/dashboard");
        }
    }
}
