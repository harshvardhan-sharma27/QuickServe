package com.quickserve.controller;

import com.quickserve.pojo.Booking;
import com.quickserve.pojo.User;
import com.quickserve.service.BookingService;
import com.quickserve.service.ReviewService;
import com.quickserve.service.impl.BookingServiceImpl;
import com.quickserve.service.impl.ReviewServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/customer/review"})
public class ReviewServlet extends HttpServlet {

    private final BookingService bookingService = new BookingServiceImpl();
    private final ReviewService reviewService = new ReviewServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        Booking booking = bookingService.getBookingDetails(bookingId);
        if (booking == null || booking.getCustomerId() != user.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/customer/bookings");
            return;
        }

        try {
            reviewService.addReview(bookingId, user.getUserId(), booking.getProviderId(), rating, comment);
            response.sendRedirect(request.getContextPath() + "/customer/booking-details?id=" + bookingId + "&msg=Review+submitted+successfully!");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/customer/booking-details?id=" + bookingId + "&error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}
