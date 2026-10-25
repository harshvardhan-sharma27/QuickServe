package com.quickserve.dao;

import com.quickserve.pojo.Payment;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface PaymentDAO {
    Payment findByBookingId(int bookingId);
    boolean updateStatus(int bookingId, String status, String method, String txnRef);
    BigDecimal getTotalSuccessfulRevenue();
    BigDecimal getProviderEarnings(int providerId);
    List<Map<String, Object>> getMonthlyRevenue();
    List<Payment> findAll();
}
