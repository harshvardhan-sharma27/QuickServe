package com.quickserve.dao.impl;

import com.quickserve.dao.AddressDAO;
import com.quickserve.exception.DAOException;
import com.quickserve.mapper.ResultSetMapper;
import com.quickserve.pojo.Address;
import com.quickserve.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddressDAOImpl implements AddressDAO {

    @Override
    public List<Address> findByUser(int userId) {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC, address_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(ResultSetMapper.mapAddress(rs));
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error fetching addresses for user: " + userId, e);
        }
        return list;
    }

    @Override
    public Address findById(int addressId) {
        String sql = "SELECT * FROM addresses WHERE address_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, addressId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return ResultSetMapper.mapAddress(rs);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error finding address: " + addressId, e);
        }
        return null;
    }

    @Override
    public int create(Address address) {
        String sql = "INSERT INTO addresses (user_id, address_line, city, state, pincode, is_default) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getAddressLine());
            ps.setString(3, address.getCity());
            ps.setString(4, address.getState());
            ps.setString(5, address.getPincode());
            ps.setBoolean(6, address.isDefault());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        address.setAddressId(id);
                        if (address.isDefault()) {
                            setDefault(id, address.getUserId());
                        }
                        return id;
                    }
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error creating address", e);
        }
        return 0;
    }

    @Override
    public boolean update(Address address) {
        String sql = "UPDATE addresses SET address_line = ?, city = ?, state = ?, pincode = ?, is_default = ? WHERE address_id = ? AND user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, address.getAddressLine());
            ps.setString(2, address.getCity());
            ps.setString(3, address.getState());
            ps.setString(4, address.getPincode());
            ps.setBoolean(5, address.isDefault());
            ps.setInt(6, address.getAddressId());
            ps.setInt(7, address.getUserId());
            boolean success = ps.executeUpdate() > 0;
            if (success && address.isDefault()) {
                setDefault(address.getAddressId(), address.getUserId());
            }
            return success;
        } catch (SQLException e) {
            throw new DAOException("Error updating address: " + address.getAddressId(), e);
        }
    }

    @Override
    public boolean delete(int addressId, int userId) {
        String sql = "DELETE FROM addresses WHERE address_id = ? AND user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, addressId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error deleting address: " + addressId, e);
        }
    }

    @Override
    public boolean setDefault(int addressId, int userId) {
        String resetSql = "UPDATE addresses SET is_default = FALSE WHERE user_id = ?";
        String setSql = "UPDATE addresses SET is_default = TRUE WHERE address_id = ? AND user_id = ?";
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement ps1 = con.prepareStatement(resetSql);
                 PreparedStatement ps2 = con.prepareStatement(setSql)) {
                ps1.setInt(1, userId);
                ps1.executeUpdate();

                ps2.setInt(1, addressId);
                ps2.setInt(2, userId);
                ps2.executeUpdate();

                con.commit();
                return true;
            } catch (SQLException ex) {
                con.rollback();
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new DAOException("Error setting default address", e);
        }
    }
}
