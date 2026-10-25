package com.quickserve.service;

import com.quickserve.pojo.SupportTicket;
import java.util.List;

public interface SupportService {
    int createTicket(int userId, Integer bookingId, String subject, String description);
    List<SupportTicket> getUserTickets(int userId);
    List<SupportTicket> getAllTickets(String statusFilter);
    SupportTicket getTicketById(int ticketId);
    boolean resolveTicket(int ticketId, String adminResponse, String status);
}
