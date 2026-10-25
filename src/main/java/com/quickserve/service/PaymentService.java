package com.quickserve.service;

import com.quickserve.pojo.Payment;
import java.util.List;

public interface PaymentService {
    Payment getPaymentByBooking(int bookingId);
    boolean processPayment(int bookingId, String paymentMethod, String transactionReference);
    List<Payment> getAllPayments();
}
