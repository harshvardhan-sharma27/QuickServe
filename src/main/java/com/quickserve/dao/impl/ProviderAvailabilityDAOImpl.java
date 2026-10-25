package com.quickserve.dao.impl;

import com.quickserve.dao.ProviderAvailabilityDAO;
import com.quickserve.exception.DAOException;
import com.quickserve.mapper.ResultSetMapper;
import com.quickserve.pojo.ProviderAvailability;
import com.quickserve.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProviderAvailabilityDAOImpl implements ProviderAvailabilityDAO {

    @Override
    public List<ProviderAvailability> findByProvider(int providerId) {
        List<ProviderAvailability> list = new ArrayList<>();
        String sql = "SELECT * FROM provider_availability WHERE provider_id = ? AND available_date >= CURDATE() " +
                     "ORDER BY available_date ASC, start_time ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, providerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(ResultSetMapper.mapAvailability(rs));
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error fetching availability for provider: " + providerId, e);
        }
        return list;
    }

    @Override
    public List<ProviderAvailability> findAvailableByProviderAndDate(int providerId, Date date) {
        List<ProviderAvailability> list = new ArrayList<>();
        String sql = "SELECT * FROM provider_availability WHERE provider_id = ? AND available_date = ? AND status = 'AVAILABLE' " +
                     "ORDER BY start_time ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, providerId);
            ps.setDate(2, date);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(ResultSetMapper.mapAvailability(rs));
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error fetching available slots", e);
        }
        return list;
    }

    @Override
    public ProviderAvailability findById(int availabilityId) {
        String sql = "SELECT * FROM provider_availability WHERE availability_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, availabilityId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return ResultSetMapper.mapAvailability(rs);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error finding availability slot: " + availabilityId, e);
        }
        return null;
    }

    @Override
    public int create(ProviderAvailability slot) {
        String sql = "INSERT INTO provider_availability (provider_id, available_date, start_time, end_time, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, slot.getProviderId());
            ps.setDate(2, slot.getAvailableDate());
            ps.setTime(3, slot.getStartTime());
            ps.setTime(4, slot.getEndTime());
            ps.setString(5, slot.getStatus() != null ? slot.getStatus() : "AVAILABLE");
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        slot.setAvailabilityId(id);
                        return id;
                    }
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error creating availability slot", e);
        }
        return 0;
    }

    @Override
    public boolean delete(int availabilityId, int providerId) {
        String sql = "DELETE FROM provider_availability WHERE availability_id = ? AND provider_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, availabilityId);
            ps.setInt(2, providerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error deleting availability slot: " + availabilityId, e);
        }
    }

    @Override
    public boolean updateStatus(int availabilityId, String status) {
        String sql = "UPDATE provider_availability SET status = ? WHERE availability_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, availabilityId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error updating status for slot: " + availabilityId, e);
        }
    }
}
