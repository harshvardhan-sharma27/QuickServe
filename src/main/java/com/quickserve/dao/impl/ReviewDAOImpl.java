package com.quickserve.dao.impl;

import com.quickserve.dao.ReviewDAO;
import com.quickserve.exception.DAOException;
import com.quickserve.mapper.ResultSetMapper;
import com.quickserve.pojo.Review;
import com.quickserve.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAOImpl implements ReviewDAO {

    @Override
    public Review findByBookingId(int bookingId) {
        String sql = "SELECT r.*, u.full_name AS customer_name, p.business_name " +
                     "FROM reviews r " +
                     "INNER JOIN users u ON r.customer_id = u.user_id " +
                     "INNER JOIN provider_profiles p ON r.provider_id = p.provider_id " +
                     "WHERE r.booking_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return ResultSetMapper.mapReview(rs);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error finding review for booking: " + bookingId, e);
        }
        return null;
    }

    @Override
    public List<Review> findByProvider(int providerId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name AS customer_name, p.business_name " +
                     "FROM reviews r " +
                     "INNER JOIN users u ON r.customer_id = u.user_id " +
                     "INNER JOIN provider_profiles p ON r.provider_id = p.provider_id " +
                     "WHERE r.provider_id = ? ORDER BY r.review_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, providerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(ResultSetMapper.mapReview(rs));
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error fetching reviews for provider: " + providerId, e);
        }
        return list;
    }

    @Override
    public boolean create(Review review) {
        String sql = "INSERT INTO reviews (booking_id, customer_id, provider_id, rating, comment) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, review.getBookingId());
            ps.setInt(2, review.getCustomerId());
            ps.setInt(3, review.getProviderId());
            ps.setInt(4, review.getRating());
            ps.setString(5, review.getComment());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error creating review", e);
        }
    }

    @Override
    public double calculateAverageRating(int providerId) {
        String sql = "SELECT AVG(rating) FROM reviews WHERE provider_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, providerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double avg = rs.getDouble(1);
                    return rs.wasNull() ? 0.0 : Math.round(avg * 100.0) / 100.0;
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error calculating average rating for provider: " + providerId, e);
        }
        return 0.0;
    }
}
