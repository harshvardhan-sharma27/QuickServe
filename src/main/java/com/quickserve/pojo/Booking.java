package com.quickserve.pojo;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Booking {
    private int bookingId;
    private int customerId;
    private int providerId;
    private int addressId;
    private Date bookingDate;
    private Time bookingTime;
    private BigDecimal totalAmount;
    private String status; // PENDING, CONFIRMED, IN_PROGRESS, COMPLETED, CANCELLED
    private String notes;
    private Timestamp createdAt;

    // Joined fields for display
    private String customerName;
    private String customerEmail;
    private String customerPhone;
    private String providerBusinessName;
    private String providerPhone;
    private String addressDetails;
    private String paymentStatus;
    private String paymentMethod;
    private String transactionReference;
    private Integer rating;
    private String reviewComment;

    private List<BookingItem> items = new ArrayList<>();

    public Booking() {}

    public Booking(int bookingId, int customerId, int providerId, int addressId, Date bookingDate, Time bookingTime, BigDecimal totalAmount, String status, String notes, Timestamp createdAt) {
        this.bookingId = bookingId;
        this.customerId = customerId;
        this.providerId = providerId;
        this.addressId = addressId;
        this.bookingDate = bookingDate;
        this.bookingTime = bookingTime;
        this.totalAmount = totalAmount;
        this.status = status;
        this.notes = notes;
        this.createdAt = createdAt;
    }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public int getProviderId() { return providerId; }
    public void setProviderId(int providerId) { this.providerId = providerId; }

    public int getAddressId() { return addressId; }
    public void setAddressId(int addressId) { this.addressId = addressId; }

    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }

    public Time getBookingTime() { return bookingTime; }
    public void setBookingTime(Time bookingTime) { this.bookingTime = bookingTime; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }

    public String getProviderBusinessName() { return providerBusinessName; }
    public void setProviderBusinessName(String providerBusinessName) { this.providerBusinessName = providerBusinessName; }

    public String getProviderPhone() { return providerPhone; }
    public void setProviderPhone(String providerPhone) { this.providerPhone = providerPhone; }

    public String getAddressDetails() { return addressDetails; }
    public void setAddressDetails(String addressDetails) { this.addressDetails = addressDetails; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getTransactionReference() { return transactionReference; }
    public void setTransactionReference(String transactionReference) { this.transactionReference = transactionReference; }

    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { this.rating = rating; }

    public String getReviewComment() { return reviewComment; }
    public void setReviewComment(String reviewComment) { this.reviewComment = reviewComment; }

    public List<BookingItem> getItems() { return items; }
    public void setItems(List<BookingItem> items) { this.items = items; }
}
