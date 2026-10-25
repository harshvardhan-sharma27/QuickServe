package com.quickserve.dao.impl;

import com.quickserve.dao.NotificationDAO;
import com.quickserve.exception.DAOException;
import com.quickserve.mapper.ResultSetMapper;
import com.quickserve.pojo.Notification;
import com.quickserve.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAOImpl implements NotificationDAO {

    @Override
    public List<Notification> findByUser(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY notification_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(ResultSetMapper.mapNotification(rs));
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error fetching notifications for user: " + userId, e);
        }
        return list;
    }

    @Override
    public int create(int userId, String message) {
        String sql = "INSERT INTO notifications (user_id, message, is_read) VALUES (?, ?, FALSE)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setString(2, message);
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error creating notification", e);
        }
        return 0;
    }

    @Override
    public boolean markAsRead(int notificationId, int userId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE notification_id = ? AND user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error marking notification as read", e);
        }
    }

    @Override
    public boolean markAllAsRead(int userId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error marking all notifications as read", e);
        }
    }

    @Override
    public int getUnreadCount(int userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = FALSE";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error counting unread notifications", e);
        }
        return 0;
    }
}
