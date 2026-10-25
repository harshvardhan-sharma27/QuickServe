package com.quickserve.controller;

import com.quickserve.pojo.Booking;
import com.quickserve.pojo.Payment;
import com.quickserve.pojo.User;
import com.quickserve.service.BookingService;
import com.quickserve.service.PaymentService;
import com.quickserve.service.impl.BookingServiceImpl;
import com.quickserve.service.impl.PaymentServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/customer/payment"})
public class PaymentServlet extends HttpServlet {

    private final BookingService bookingService = new BookingServiceImpl();
    private final PaymentService paymentService = new PaymentServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String bookingIdParam = request.getParameter("bookingId");
        if (bookingIdParam == null || bookingIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/bookings");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            Booking booking = bookingService.getBookingDetails(bookingId);

            if (booking == null || booking.getCustomerId() != user.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/customer/bookings");
                return;
            }

            Payment payment = paymentService.getPaymentByBooking(bookingId);

            request.setAttribute("booking", booking);
            request.setAttribute("payment", payment);

            request.getRequestDispatcher("/WEB-INF/views/customer/payment.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/customer/bookings");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String paymentMethod = request.getParameter("paymentMethod");

        Booking booking = bookingService.getBookingDetails(bookingId);
        if (booking == null || booking.getCustomerId() != user.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/customer/bookings");
            return;
        }

        String txnRef = "TXN_QS_" + System.currentTimeMillis();
        paymentService.processPayment(bookingId, paymentMethod, txnRef);

        response.sendRedirect(request.getContextPath() + "/customer/booking-details?id=" + bookingId + "&msg=Payment+completed+successfully");
    }
}
