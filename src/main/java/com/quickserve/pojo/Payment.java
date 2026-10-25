package com.quickserve.pojo;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment {
    private int paymentId;
    private int bookingId;
    private String transactionReference;
    private BigDecimal amount;
    private String paymentMethod; // UPI, CARD, CASH
    private String paymentStatus; // PENDING, SUCCESS, FAILED, REFUNDED
    private Timestamp paidAt;

    public Payment() {}

    public Payment(int paymentId, int bookingId, String transactionReference, BigDecimal amount, String paymentMethod, String paymentStatus, Timestamp paidAt) {
        this.paymentId = paymentId;
        this.bookingId = bookingId;
        this.transactionReference = transactionReference;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.paidAt = paidAt;
    }

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public String getTransactionReference() { return transactionReference; }
    public void setTransactionReference(String transactionReference) { this.transactionReference = transactionReference; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public Timestamp getPaidAt() { return paidAt; }
    public void setPaidAt(Timestamp paidAt) { this.paidAt = paidAt; }
}
