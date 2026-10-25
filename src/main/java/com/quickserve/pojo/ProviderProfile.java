package com.quickserve.pojo;

public class ProviderProfile {
    private int providerId;
    private String businessName;
    private int experienceYears;
    private String description;
    private String verificationStatus; // PENDING, APPROVED, REJECTED
    private double rating;
    
    // Joined user details (for convenience)
    private User user;

    public ProviderProfile() {}

    public ProviderProfile(int providerId, String businessName, int experienceYears, String description, String verificationStatus, double rating) {
        this.providerId = providerId;
        this.businessName = businessName;
        this.experienceYears = experienceYears;
        this.description = description;
        this.verificationStatus = verificationStatus;
        this.rating = rating;
    }

    public int getProviderId() { return providerId; }
    public void setProviderId(int providerId) { this.providerId = providerId; }

    public String getBusinessName() { return businessName; }
    public void setBusinessName(String businessName) { this.businessName = businessName; }

    public int getExperienceYears() { return experienceYears; }
    public void setExperienceYears(int experienceYears) { this.experienceYears = experienceYears; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getVerificationStatus() { return verificationStatus; }
    public void setVerificationStatus(String verificationStatus) { this.verificationStatus = verificationStatus; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}
