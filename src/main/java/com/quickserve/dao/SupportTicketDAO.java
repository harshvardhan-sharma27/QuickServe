package com.quickserve.dao;

import com.quickserve.pojo.SupportTicket;
import java.util.List;

public interface SupportTicketDAO {
    int create(SupportTicket ticket);
    SupportTicket findById(int ticketId);
    List<SupportTicket> findByUser(int userId);
    List<SupportTicket> findAll(String statusFilter);
    boolean updateStatusAndResponse(int ticketId, String status, String response);
    int countOpenTickets();
}
