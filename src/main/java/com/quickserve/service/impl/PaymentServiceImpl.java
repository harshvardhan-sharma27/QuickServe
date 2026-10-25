package com.quickserve.service.impl;

import com.quickserve.dao.PaymentDAO;
import com.quickserve.dao.impl.PaymentDAOImpl;
import com.quickserve.pojo.Payment;
import com.quickserve.service.PaymentService;

import java.util.List;

public class PaymentServiceImpl implements PaymentService {

    private final PaymentDAO paymentDAO = new PaymentDAOImpl();

    @Override
    public Payment getPaymentByBooking(int bookingId) {
        return paymentDAO.findByBookingId(bookingId);
    }

    @Override
    public boolean processPayment(int bookingId, String paymentMethod, String transactionReference) {
        String ref = (transactionReference != null && !transactionReference.trim().isEmpty())
                ? transactionReference.trim()
                : "TXN_" + System.currentTimeMillis();
        return paymentDAO.updateStatus(bookingId, "SUCCESS", paymentMethod, ref);
    }

    @Override
    public List<Payment> getAllPayments() {
        return paymentDAO.findAll();
    }
}
