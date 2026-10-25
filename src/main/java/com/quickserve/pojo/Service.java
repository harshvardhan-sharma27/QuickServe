package com.quickserve.pojo;

import java.math.BigDecimal;

public class Service {
    private int serviceId;
    private int providerId;
    private int categoryId;
    private String serviceName;
    private String description;
    private BigDecimal price;
    private int durationMinutes;
    private String status; // ACTIVE, INACTIVE
    private String imageUrl;

    // Joined fields for display
    private String categoryName;
    private String providerBusinessName;
    private double providerRating;

    public Service() {}

    public Service(int serviceId, int providerId, int categoryId, String serviceName, String description, BigDecimal price, int durationMinutes, String status, String imageUrl) {
        this.serviceId = serviceId;
        this.providerId = providerId;
        this.categoryId = categoryId;
        this.serviceName = serviceName;
        this.description = description;
        this.price = price;
        this.durationMinutes = durationMinutes;
        this.status = status;
        this.imageUrl = imageUrl;
    }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public int getProviderId() { return providerId; }
    public void setProviderId(int providerId) { this.providerId = providerId; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getProviderBusinessName() { return providerBusinessName; }
    public void setProviderBusinessName(String providerBusinessName) { this.providerBusinessName = providerBusinessName; }

    public double getProviderRating() { return providerRating; }
    public void setProviderRating(double providerRating) { this.providerRating = providerRating; }
}
