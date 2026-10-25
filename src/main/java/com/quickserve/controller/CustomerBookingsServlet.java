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
import java.util.List;

@WebServlet(name = "CustomerBookingsServlet", urlPatterns = {"/customer/bookings"})
public class CustomerBookingsServlet extends HttpServlet {

    private final BookingService bookingService = new BookingServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String cancelIdParam = request.getParameter("cancelId");
        if (cancelIdParam != null && !cancelIdParam.trim().isEmpty()) {
            try {
                int cancelId = Integer.parseInt(cancelIdParam);
                boolean ok = bookingService.cancelBooking(cancelId, user.getUserId());
                if (ok) {
                    request.setAttribute("successMessage", "Booking #" + cancelId + " was cancelled successfully.");
                } else {
                    request.setAttribute("errorMessage", "Unable to cancel booking.");
                }
            } catch (Exception e) {
                request.setAttribute("errorMessage", e.getMessage());
            }
        }

        List<Booking> bookings = bookingService.getCustomerBookings(user.getUserId());
        request.setAttribute("bookings", bookings);

        request.getRequestDispatcher("/WEB-INF/views/customer/bookings.jsp").forward(request, response);
    }
}
