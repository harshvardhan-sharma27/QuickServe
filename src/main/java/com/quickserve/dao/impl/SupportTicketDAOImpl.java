package com.quickserve.dao.impl;

import com.quickserve.dao.SupportTicketDAO;
import com.quickserve.exception.DAOException;
import com.quickserve.mapper.ResultSetMapper;
import com.quickserve.pojo.SupportTicket;
import com.quickserve.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SupportTicketDAOImpl implements SupportTicketDAO {

    @Override
    public int create(SupportTicket ticket) {
        String sql = "INSERT INTO support_tickets (user_id, booking_id, subject, description, status) VALUES (?, ?, ?, ?, 'OPEN')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, ticket.getUserId());
            if (ticket.getBookingId() != null && ticket.getBookingId() > 0) {
                ps.setInt(2, ticket.getBookingId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, ticket.getSubject());
            ps.setString(4, ticket.getDescription());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        ticket.setTicketId(id);
                        return id;
                    }
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error creating support ticket", e);
        }
        return 0;
    }

    @Override
    public SupportTicket findById(int ticketId) {
        String sql = "SELECT t.*, u.full_name AS user_name, u.email AS user_email, u.role AS user_role " +
                     "FROM support_tickets t " +
                     "INNER JOIN users u ON t.user_id = u.user_id " +
                     "WHERE t.ticket_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return ResultSetMapper.mapSupportTicket(rs);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error finding support ticket: " + ticketId, e);
        }
        return null;
    }

    @Override
    public List<SupportTicket> findByUser(int userId) {
        List<SupportTicket> list = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name AS user_name, u.email AS user_email, u.role AS user_role " +
                     "FROM support_tickets t " +
                     "INNER JOIN users u ON t.user_id = u.user_id " +
                     "WHERE t.user_id = ? ORDER BY t.ticket_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(ResultSetMapper.mapSupportTicket(rs));
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error finding tickets for user: " + userId, e);
        }
        return list;
    }

    @Override
    public List<SupportTicket> findAll(String statusFilter) {
        List<SupportTicket> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT t.*, u.full_name AS user_name, u.email AS user_email, u.role AS user_role " +
            "FROM support_tickets t " +
            "INNER JOIN users u ON t.user_id = u.user_id "
        );
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("ALL")) {
            sql.append("WHERE t.status = ? ");
        }
        sql.append("ORDER BY t.ticket_id DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("ALL")) {
                ps.setString(1, statusFilter);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(ResultSetMapper.mapSupportTicket(rs));
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error fetching support tickets", e);
        }
        return list;
    }

    @Override
    public boolean updateStatusAndResponse(int ticketId, String status, String response) {
        String sql = "UPDATE support_tickets SET status = ?, admin_response = ? WHERE ticket_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, response);
            ps.setInt(3, ticketId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error resolving ticket: " + ticketId, e);
        }
    }

    @Override
    public int countOpenTickets() {
        String sql = "SELECT COUNT(*) FROM support_tickets WHERE status IN ('OPEN', 'IN_PROGRESS')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new DAOException("Error counting open tickets", e);
        }
        return 0;
    }
}
