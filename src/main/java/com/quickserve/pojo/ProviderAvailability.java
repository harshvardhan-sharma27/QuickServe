package com.quickserve.pojo;

import java.sql.Date;
import java.sql.Time;

public class ProviderAvailability {
    private int availabilityId;
    private int providerId;
    private Date availableDate;
    private Time startTime;
    private Time endTime;
    private String status; // AVAILABLE, BOOKED, BLOCKED

    public ProviderAvailability() {}

    public ProviderAvailability(int availabilityId, int providerId, Date availableDate, Time startTime, Time endTime, String status) {
        this.availabilityId = availabilityId;
        this.providerId = providerId;
        this.availableDate = availableDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = status;
    }

    public int getAvailabilityId() { return availabilityId; }
    public void setAvailabilityId(int availabilityId) { this.availabilityId = availabilityId; }

    public int getProviderId() { return providerId; }
    public void setProviderId(int providerId) { this.providerId = providerId; }

    public Date getAvailableDate() { return availableDate; }
    public void setAvailableDate(Date availableDate) { this.availableDate = availableDate; }

    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }

    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
