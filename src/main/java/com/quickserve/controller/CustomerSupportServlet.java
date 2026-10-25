package com.quickserve.controller;

import com.quickserve.pojo.Booking;
import com.quickserve.pojo.SupportTicket;
import com.quickserve.pojo.User;
import com.quickserve.service.BookingService;
import com.quickserve.service.SupportService;
import com.quickserve.service.impl.BookingServiceImpl;
import com.quickserve.service.impl.SupportServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CustomerSupportServlet", urlPatterns = {"/customer/support"})
public class CustomerSupportServlet extends HttpServlet {

    private final SupportService supportService = new SupportServiceImpl();
    private final BookingService bookingService = new BookingServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        List<SupportTicket> tickets = supportService.getUserTickets(user.getUserId());
        List<Booking> customerBookings = bookingService.getCustomerBookings(user.getUserId());

        request.setAttribute("tickets", tickets);
        request.setAttribute("bookings", customerBookings);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("successMessage", msg);

        request.getRequestDispatcher("/WEB-INF/views/customer/support.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String subject = request.getParameter("subject");
        String description = request.getParameter("description");
        String bookingIdParam = request.getParameter("bookingId");

        Integer bookingId = null;
        if (bookingIdParam != null && !bookingIdParam.trim().isEmpty()) {
            try {
                bookingId = Integer.parseInt(bookingIdParam);
            } catch (NumberFormatException ignored) {}
        }

        try {
            supportService.createTicket(user.getUserId(), bookingId, subject, description);
            response.sendRedirect(request.getContextPath() + "/customer/support?msg=" + java.net.URLEncoder.encode("Support request raised successfully! Our team will respond shortly.", "UTF-8"));
        } catch (Exception e) {
            request.setAttribute("errorMessage", e.getMessage());
            doGet(request, response);
        }
    }
}
