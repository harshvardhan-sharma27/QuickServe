package com.quickserve.dao.impl;

import com.quickserve.dao.UserDAO;
import com.quickserve.exception.DAOException;
import com.quickserve.mapper.ResultSetMapper;
import com.quickserve.pojo.User;
import com.quickserve.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAOImpl implements UserDAO {

    @Override
    public User findById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return ResultSetMapper.mapUser(rs);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error finding user by ID: " + userId, e);
        }
        return null;
    }

    @Override
    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return ResultSetMapper.mapUser(rs);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error finding user by email: " + email, e);
        }
        return null;
    }

    @Override
    public int create(User user) {
        String sql = "INSERT INTO users (full_name, email, password_hash, phone, role, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole() != null ? user.getRole() : "CUSTOMER");
            ps.setString(6, user.getStatus() != null ? user.getStatus() : "ACTIVE");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        user.setUserId(id);
                        return id;
                    }
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error creating user: " + user.getEmail(), e);
        }
        return 0;
    }

    @Override
    public boolean update(User user) {
        String sql = "UPDATE users SET full_name = ?, phone = ? WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setInt(3, user.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error updating user: " + user.getUserId(), e);
        }
    }

    @Override
    public boolean updateStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ? WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error updating status for user: " + userId, e);
        }
    }

    @Override
    public List<User> findAll(String roleFilter, String statusFilter) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE 1=1 ");
        if (roleFilter != null && !roleFilter.trim().isEmpty() && !roleFilter.equalsIgnoreCase("ALL")) {
            sql.append("AND role = ? ");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("ALL")) {
            sql.append("AND status = ? ");
        }
        sql.append("ORDER BY user_id DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int idx = 1;
            if (roleFilter != null && !roleFilter.trim().isEmpty() && !roleFilter.equalsIgnoreCase("ALL")) {
                ps.setString(idx++, roleFilter);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("ALL")) {
                ps.setString(idx++, statusFilter);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(ResultSetMapper.mapUser(rs));
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error fetching users", e);
        }
        return list;
    }

    @Override
    public int countByRole(String role) {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error counting users by role: " + role, e);
        }
        return 0;
    }
}
