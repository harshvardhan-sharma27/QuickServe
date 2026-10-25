package com.quickserve.service.impl;

import com.quickserve.dao.NotificationDAO;
import com.quickserve.dao.SupportTicketDAO;
import com.quickserve.dao.impl.NotificationDAOImpl;
import com.quickserve.dao.impl.SupportTicketDAOImpl;
import com.quickserve.pojo.SupportTicket;
import com.quickserve.service.SupportService;
import com.quickserve.util.ValidationUtil;

import java.util.List;

public class SupportServiceImpl implements SupportService {

    private final SupportTicketDAO supportTicketDAO = new SupportTicketDAOImpl();
    private final NotificationDAO notificationDAO = new NotificationDAOImpl();

    @Override
    public int createTicket(int userId, Integer bookingId, String subject, String description) {
        ValidationUtil.validateNotEmpty(subject, "Subject");
        ValidationUtil.validateNotEmpty(description, "Description");

        SupportTicket ticket = new SupportTicket();
        ticket.setUserId(userId);
        ticket.setBookingId(bookingId);
        ticket.setSubject(subject.trim());
        ticket.setDescription(description.trim());

        return supportTicketDAO.create(ticket);
    }

    @Override
    public List<SupportTicket> getUserTickets(int userId) {
        return supportTicketDAO.findByUser(userId);
    }

    @Override
    public List<SupportTicket> getAllTickets(String statusFilter) {
        return supportTicketDAO.findAll(statusFilter);
    }

    @Override
    public SupportTicket getTicketById(int ticketId) {
        return supportTicketDAO.findById(ticketId);
    }

    @Override
    public boolean resolveTicket(int ticketId, String adminResponse, String status) {
        ValidationUtil.validateNotEmpty(adminResponse, "Response");
        boolean ok = supportTicketDAO.updateStatusAndResponse(ticketId, status != null ? status : "RESOLVED", adminResponse.trim());
        if (ok) {
            SupportTicket t = supportTicketDAO.findById(ticketId);
            if (t != null) {
                notificationDAO.create(t.getUserId(), "Support Ticket #" + ticketId + " has been updated by Admin: " + adminResponse);
            }
        }
        return ok;
    }
}
