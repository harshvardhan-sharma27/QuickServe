package com.quickserve.controller;

import com.quickserve.pojo.Booking;
import com.quickserve.service.BookingService;
import com.quickserve.service.impl.BookingServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminBookingsServlet", urlPatterns = {"/admin/bookings"})
public class AdminBookingsServlet extends HttpServlet {

    private final BookingService bookingService = new BookingServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        String statusParam = request.getParameter("status");

        if ("update".equalsIgnoreCase(action) && idParam != null && statusParam != null) {
            try {
                int bookingId = Integer.parseInt(idParam);
                bookingService.updateBookingStatus(bookingId, statusParam, 0, "ADMIN");
                response.sendRedirect(request.getContextPath() + "/admin/bookings?msg=Booking+status+updated+to+" + statusParam);
                return;
            } catch (Exception ignored) {}
        }

        String filter = request.getParameter("filter");
        String pageParam = request.getParameter("page");
        int page = 1;
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {}
        }

        List<Booking> bookings = bookingService.getAllBookings(filter, page, 50);
        int total = bookingService.getTotalBookingsCount(filter);

        request.setAttribute("bookings", bookings);
        request.setAttribute("selectedFilter", filter);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalBookings", total);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("successMessage", msg);

        request.getRequestDispatcher("/WEB-INF/views/admin/bookings.jsp").forward(request, response);
    }
}
