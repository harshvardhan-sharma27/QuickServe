package com.quickserve.controller;

import com.quickserve.dao.PaymentDAO;
import com.quickserve.dao.impl.PaymentDAOImpl;
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
import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "ProviderEarningsServlet", urlPatterns = {"/provider/earnings"})
public class ProviderEarningsServlet extends HttpServlet {

    private final PaymentDAO paymentDAO = new PaymentDAOImpl();
    private final BookingService bookingService = new BookingServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        BigDecimal totalEarnings = paymentDAO.getProviderEarnings(user.getUserId());
        List<Booking> allBookings = bookingService.getProviderBookings(user.getUserId());

        List<Booking> paidBookings = allBookings.stream()
                .filter(b -> "SUCCESS".equalsIgnoreCase(b.getPaymentStatus()))
                .collect(Collectors.toList());

        request.setAttribute("totalEarnings", totalEarnings != null ? totalEarnings : BigDecimal.ZERO);
        request.setAttribute("paidBookings", paidBookings);

        request.getRequestDispatcher("/WEB-INF/views/provider/earnings.jsp").forward(request, response);
    }
}
