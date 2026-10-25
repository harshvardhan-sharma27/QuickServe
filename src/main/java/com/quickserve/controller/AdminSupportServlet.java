package com.quickserve.controller;

import com.quickserve.pojo.SupportTicket;
import com.quickserve.service.SupportService;
import com.quickserve.service.impl.SupportServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminSupportServlet", urlPatterns = {"/admin/support"})
public class AdminSupportServlet extends HttpServlet {

    private final SupportService supportService = new SupportServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String filter = request.getParameter("filter");
        List<SupportTicket> tickets = supportService.getAllTickets(filter);

        request.setAttribute("tickets", tickets);
        request.setAttribute("selectedFilter", filter);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("successMessage", msg);

        request.getRequestDispatcher("/WEB-INF/views/admin/support.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int ticketId = Integer.parseInt(request.getParameter("ticketId"));
        String responseText = request.getParameter("response");
        String status = request.getParameter("status");

        try {
            supportService.resolveTicket(ticketId, responseText, status);
            response.sendRedirect(request.getContextPath() + "/admin/support?msg=Ticket+%23" + ticketId + "+updated+successfully");
        } catch (Exception e) {
            request.setAttribute("errorMessage", e.getMessage());
            doGet(request, response);
        }
    }
}
