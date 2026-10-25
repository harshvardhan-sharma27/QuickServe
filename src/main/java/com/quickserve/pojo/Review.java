package com.quickserve.pojo;

import java.sql.Timestamp;

public class Review {
    private int reviewId;
    private int bookingId;
    private int customerId;
    private int providerId;
    private int rating;
    private String comment;
    private Timestamp createdAt;

    // Joined fields
    private String customerName;
    private String providerBusinessName;

    public Review() {}

    public Review(int reviewId, int bookingId, int customerId, int providerId, int rating, String comment, Timestamp createdAt) {
        this.reviewId = reviewId;
        this.bookingId = bookingId;
        this.customerId = customerId;
        this.providerId = providerId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public int getProviderId() { return providerId; }
    public void setProviderId(int providerId) { this.providerId = providerId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getProviderBusinessName() { return providerBusinessName; }
    public void setProviderBusinessName(String providerBusinessName) { this.providerBusinessName = providerBusinessName; }
}
