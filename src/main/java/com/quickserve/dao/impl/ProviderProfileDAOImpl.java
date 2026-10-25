package com.quickserve.dao.impl;

import com.quickserve.dao.ProviderProfileDAO;
import com.quickserve.exception.DAOException;
import com.quickserve.mapper.ResultSetMapper;
import com.quickserve.pojo.ProviderProfile;
import com.quickserve.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProviderProfileDAOImpl implements ProviderProfileDAO {

    @Override
    public ProviderProfile findById(int providerId) {
        String sql = "SELECT p.*, u.full_name, u.email, u.phone, u.status " +
                     "FROM provider_profiles p " +
                     "INNER JOIN users u ON p.provider_id = u.user_id " +
                     "WHERE p.provider_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, providerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return ResultSetMapper.mapProviderProfile(rs);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error finding provider profile: " + providerId, e);
        }
        return null;
    }

    @Override
    public boolean create(ProviderProfile profile) {
        String sql = "INSERT INTO provider_profiles (provider_id, business_name, experience_years, description, verification_status, rating) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, profile.getProviderId());
            ps.setString(2, profile.getBusinessName());
            ps.setInt(3, profile.getExperienceYears());
            ps.setString(4, profile.getDescription());
            ps.setString(5, profile.getVerificationStatus() != null ? profile.getVerificationStatus() : "PENDING");
            ps.setDouble(6, profile.getRating());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error creating provider profile: " + profile.getProviderId(), e);
        }
    }

    @Override
    public boolean update(ProviderProfile profile) {
        String sql = "UPDATE provider_profiles SET business_name = ?, experience_years = ?, description = ? WHERE provider_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, profile.getBusinessName());
            ps.setInt(2, profile.getExperienceYears());
            ps.setString(3, profile.getDescription());
            ps.setInt(4, profile.getProviderId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error updating provider profile: " + profile.getProviderId(), e);
        }
    }

    @Override
    public boolean updateVerificationStatus(int providerId, String status) {
        String sql = "UPDATE provider_profiles SET verification_status = ? WHERE provider_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, providerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error updating provider status: " + providerId, e);
        }
    }

    @Override
    public boolean updateRating(int providerId, double rating) {
        String sql = "UPDATE provider_profiles SET rating = ? WHERE provider_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDouble(1, rating);
            ps.setInt(2, providerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error updating provider rating: " + providerId, e);
        }
    }

    @Override
    public List<ProviderProfile> findAll(String statusFilter) {
        List<ProviderProfile> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.*, u.full_name, u.email, u.phone, u.status " +
            "FROM provider_profiles p " +
            "INNER JOIN users u ON p.provider_id = u.user_id "
        );
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("ALL")) {
            sql.append("WHERE p.verification_status = ? ");
        }
        sql.append("ORDER BY p.rating DESC, p.provider_id DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equalsIgnoreCase("ALL")) {
                ps.setString(1, statusFilter);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(ResultSetMapper.mapProviderProfile(rs));
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error fetching provider profiles", e);
        }
        return list;
    }

    @Override
    public List<ProviderProfile> findFeatured(int limit) {
        List<ProviderProfile> list = new ArrayList<>();
        String sql = "SELECT p.*, u.full_name, u.email, u.phone, u.status " +
                     "FROM provider_profiles p " +
                     "INNER JOIN users u ON p.provider_id = u.user_id " +
                     "WHERE p.verification_status = 'APPROVED' AND u.status = 'ACTIVE' " +
                     "ORDER BY p.rating DESC, p.experience_years DESC LIMIT ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(ResultSetMapper.mapProviderProfile(rs));
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error fetching featured providers", e);
        }
        return list;
    }
}
