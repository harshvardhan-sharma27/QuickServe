package com.quickserve.controller;

import com.quickserve.dao.PaymentDAO;
import com.quickserve.dao.impl.PaymentDAOImpl;
import com.quickserve.pojo.Payment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "AdminPaymentsServlet", urlPatterns = {"/admin/payments"})
public class AdminPaymentsServlet extends HttpServlet {

    private final PaymentDAO paymentDAO = new PaymentDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Payment> payments = paymentDAO.findAll();
        BigDecimal totalRevenue = paymentDAO.getTotalSuccessfulRevenue();

        request.setAttribute("payments", payments);
        request.setAttribute("totalRevenue", totalRevenue != null ? totalRevenue : BigDecimal.ZERO);

        request.getRequestDispatcher("/WEB-INF/views/admin/payments.jsp").forward(request, response);
    }
}
