package com.quickserve.dao.impl;

import com.quickserve.dao.BookingItemDAO;
import com.quickserve.exception.DAOException;
import com.quickserve.mapper.ResultSetMapper;
import com.quickserve.pojo.BookingItem;
import com.quickserve.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookingItemDAOImpl implements BookingItemDAO {

    @Override
    public List<BookingItem> findByBookingId(int bookingId) {
        List<BookingItem> list = new ArrayList<>();
        String sql = "SELECT bi.*, s.service_name FROM booking_items bi " +
                     "INNER JOIN services s ON bi.service_id = s.service_id " +
                     "WHERE bi.booking_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(ResultSetMapper.mapBookingItem(rs));
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error fetching booking items for booking: " + bookingId, e);
        }
        return list;
    }
}
