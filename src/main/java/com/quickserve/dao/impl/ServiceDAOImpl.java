package com.quickserve.dao.impl;

import com.quickserve.dao.ServiceDAO;
import com.quickserve.exception.DAOException;
import com.quickserve.mapper.ResultSetMapper;
import com.quickserve.pojo.Service;
import com.quickserve.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ServiceDAOImpl implements ServiceDAO {

    @Override
    public List<Service> findAllActive(Integer categoryId, String keyword, String sortBy, int offset, int limit) {
        List<Service> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT s.*, c.category_name, p.business_name, p.rating " +
            "FROM services s " +
            "INNER JOIN categories c ON s.category_id = c.category_id " +
            "INNER JOIN provider_profiles p ON s.provider_id = p.provider_id " +
            "INNER JOIN users u ON p.provider_id = u.user_id " +
            "WHERE s.status = 'ACTIVE' AND p.verification_status = 'APPROVED' AND u.status = 'ACTIVE' "
        );

        if (categoryId != null && categoryId > 0) {
            sql.append("AND s.category_id = ? ");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (s.service_name LIKE ? OR s.description LIKE ? OR c.category_name LIKE ?) ");
        }

        // Sorting
        if ("price_asc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY s.price ASC ");
        } else if ("price_desc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY s.price DESC ");
        } else if ("rating_desc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY p.rating DESC, s.service_id DESC ");
        } else {
            sql.append("ORDER BY s.service_id DESC ");
        }

        sql.append("LIMIT ? OFFSET ?");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int idx = 1;
            if (categoryId != null && categoryId > 0) {
                ps.setInt(idx++, categoryId);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String term = "%" + keyword.trim() + "%";
                ps.setString(idx++, term);
                ps.setString(idx++, term);
                ps.setString(idx++, term);
            }
            ps.setInt(idx++, limit > 0 ? limit : 20);
            ps.setInt(idx++, Math.max(offset, 0));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(ResultSetMapper.mapService(rs));
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error fetching services with filters", e);
        }
        return list;
    }

    @Override
    public int countActive(Integer categoryId, String keyword) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM services s " +
            "INNER JOIN categories c ON s.category_id = c.category_id " +
            "INNER JOIN provider_profiles p ON s.provider_id = p.provider_id " +
            "INNER JOIN users u ON p.provider_id = u.user_id " +
            "WHERE s.status = 'ACTIVE' AND p.verification_status = 'APPROVED' AND u.status = 'ACTIVE' "
        );

        if (categoryId != null && categoryId > 0) {
            sql.append("AND s.category_id = ? ");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (s.service_name LIKE ? OR s.description LIKE ? OR c.category_name LIKE ?) ");
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int idx = 1;
            if (categoryId != null && categoryId > 0) {
                ps.setInt(idx++, categoryId);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String term = "%" + keyword.trim() + "%";
                ps.setString(idx++, term);
                ps.setString(idx++, term);
                ps.setString(idx++, term);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error counting active services", e);
        }
        return 0;
    }

    @Override
    public Service findById(int serviceId) {
        String sql = "SELECT s.*, c.category_name, p.business_name, p.rating " +
                     "FROM services s " +
                     "INNER JOIN categories c ON s.category_id = c.category_id " +
                     "INNER JOIN provider_profiles p ON s.provider_id = p.provider_id " +
                     "WHERE s.service_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return ResultSetMapper.mapService(rs);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error finding service by id: " + serviceId, e);
        }
        return null;
    }

    @Override
    public List<Service> findByProvider(int providerId) {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.*, c.category_name, p.business_name, p.rating " +
                     "FROM services s " +
                     "INNER JOIN categories c ON s.category_id = c.category_id " +
                     "INNER JOIN provider_profiles p ON s.provider_id = p.provider_id " +
                     "WHERE s.provider_id = ? ORDER BY s.service_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, providerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(ResultSetMapper.mapService(rs));
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error finding services for provider: " + providerId, e);
        }
        return list;
    }

    @Override
    public List<Service> findAllForAdmin() {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT s.*, c.category_name, p.business_name, p.rating " +
                     "FROM services s " +
                     "INNER JOIN categories c ON s.category_id = c.category_id " +
                     "INNER JOIN provider_profiles p ON s.provider_id = p.provider_id " +
                     "ORDER BY s.service_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(ResultSetMapper.mapService(rs));
            }
        } catch (SQLException e) {
            throw new DAOException("Error finding all services for admin", e);
        }
        return list;
    }

    @Override
    public int create(Service service) {
        String sql = "INSERT INTO services (provider_id, category_id, service_name, description, price, duration_minutes, status, image_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, service.getProviderId());
            ps.setInt(2, service.getCategoryId());
            ps.setString(3, service.getServiceName());
            ps.setString(4, service.getDescription());
            ps.setBigDecimal(5, service.getPrice());
            ps.setInt(6, service.getDurationMinutes());
            ps.setString(7, service.getStatus() != null ? service.getStatus() : "ACTIVE");
            ps.setString(8, service.getImageUrl());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        service.setServiceId(id);
                        return id;
                    }
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error creating service: " + service.getServiceName(), e);
        }
        return 0;
    }

    @Override
    public boolean update(Service service) {
        String sql = "UPDATE services SET category_id = ?, service_name = ?, description = ?, price = ?, duration_minutes = ?, image_url = ? " +
                     "WHERE service_id = ? AND provider_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, service.getCategoryId());
            ps.setString(2, service.getServiceName());
            ps.setString(3, service.getDescription());
            ps.setBigDecimal(4, service.getPrice());
            ps.setInt(5, service.getDurationMinutes());
            ps.setString(6, service.getImageUrl());
            ps.setInt(7, service.getServiceId());
            ps.setInt(8, service.getProviderId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error updating service: " + service.getServiceId(), e);
        }
    }

    @Override
    public boolean updateStatus(int serviceId, String status) {
        String sql = "UPDATE services SET status = ? WHERE service_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, serviceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error updating status for service: " + serviceId, e);
        }
    }

    @Override
    public List<Map<String, Object>> findTopBookedServices(int limit) {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT s.service_id, s.service_name, COUNT(bi.service_id) AS total_bookings " +
                     "FROM booking_items bi " +
                     "INNER JOIN services s ON bi.service_id = s.service_id " +
                     "GROUP BY s.service_id, s.service_name " +
                     "ORDER BY total_bookings DESC LIMIT ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("serviceId", rs.getInt("service_id"));
                    map.put("serviceName", rs.getString("service_name"));
                    map.put("bookingsCount", rs.getInt("total_bookings"));
                    result.add(map);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error getting top booked services", e);
        }
        return result;
    }
}
