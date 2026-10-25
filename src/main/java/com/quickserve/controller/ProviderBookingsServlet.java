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

@WebServlet(name = "ProviderBookingsServlet", urlPatterns = {"/provider/bookings"})
public class ProviderBookingsServlet extends HttpServlet {

    private final BookingService bookingService = new BookingServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        String statusParam = request.getParameter("status");

        if ("update".equalsIgnoreCase(action) && idParam != null && statusParam != null) {
            try {
                int bookingId = Integer.parseInt(idParam);
                bookingService.updateBookingStatus(bookingId, statusParam, user.getUserId(), "PROVIDER");
                response.sendRedirect(request.getContextPath() + "/provider/bookings?msg=Booking+status+updated+to+" + statusParam);
                return;
            } catch (Exception e) {
                request.setAttribute("errorMessage", e.getMessage());
            }
        }

        List<Booking> bookings = bookingService.getProviderBookings(user.getUserId());
        request.setAttribute("bookings", bookings);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("successMessage", msg);

        request.getRequestDispatcher("/WEB-INF/views/provider/bookings.jsp").forward(request, response);
    }
}
