package com.quickserve.pojo;

import java.sql.Timestamp;

public class SupportTicket {
    private int ticketId;
    private int userId;
    private Integer bookingId;
    private String subject;
    private String description;
    private String status; // OPEN, IN_PROGRESS, RESOLVED, CLOSED
    private String adminResponse;
    private Timestamp createdAt;

    // Joined fields
    private String userName;
    private String userEmail;
    private String userRole;

    public SupportTicket() {}

    public SupportTicket(int ticketId, int userId, Integer bookingId, String subject, String description, String status, String adminResponse, Timestamp createdAt) {
        this.ticketId = ticketId;
        this.userId = userId;
        this.bookingId = bookingId;
        this.subject = subject;
        this.description = description;
        this.status = status;
        this.adminResponse = adminResponse;
        this.createdAt = createdAt;
    }

    public int getTicketId() { return ticketId; }
    public void setTicketId(int ticketId) { this.ticketId = ticketId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Integer getBookingId() { return bookingId; }
    public void setBookingId(Integer bookingId) { this.bookingId = bookingId; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAdminResponse() { return adminResponse; }
    public void setAdminResponse(String adminResponse) { this.adminResponse = adminResponse; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public String getUserRole() { return userRole; }
    public void setUserRole(String userRole) { this.userRole = userRole; }
}
