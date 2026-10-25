package com.quickserve.pojo;

import java.math.BigDecimal;

public class BookingItem {
    private int bookingItemId;
    private int bookingId;
    private int serviceId;
    private int quantity;
    private BigDecimal unitPrice;

    // Joined field for display
    private String serviceName;

    public BookingItem() {}

    public BookingItem(int bookingItemId, int bookingId, int serviceId, int quantity, BigDecimal unitPrice) {
        this.bookingItemId = bookingItemId;
        this.bookingId = bookingId;
        this.serviceId = serviceId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public int getBookingItemId() { return bookingItemId; }
    public void setBookingItemId(int bookingItemId) { this.bookingItemId = bookingItemId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public BigDecimal getSubTotal() {
        return unitPrice.multiply(BigDecimal.valueOf(quantity));
    }
}
