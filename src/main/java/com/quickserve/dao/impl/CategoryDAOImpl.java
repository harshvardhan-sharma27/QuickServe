package com.quickserve.dao.impl;

import com.quickserve.dao.CategoryDAO;
import com.quickserve.exception.DAOException;
import com.quickserve.mapper.ResultSetMapper;
import com.quickserve.pojo.Category;
import com.quickserve.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAOImpl implements CategoryDAO {

    @Override
    public List<Category> findAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY category_name ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(ResultSetMapper.mapCategory(rs));
            }
        } catch (SQLException e) {
            throw new DAOException("Error fetching categories", e);
        }
        return list;
    }

    @Override
    public Category findById(int categoryId) {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return ResultSetMapper.mapCategory(rs);
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error finding category: " + categoryId, e);
        }
        return null;
    }

    @Override
    public int create(Category category) {
        String sql = "INSERT INTO categories (category_name, description, icon_class) VALUES (?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getIconClass() != null ? category.getIconClass() : "bi-gear");
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        category.setCategoryId(id);
                        return id;
                    }
                }
            }
        } catch (SQLException e) {
            throw new DAOException("Error creating category: " + category.getCategoryName(), e);
        }
        return 0;
    }

    @Override
    public boolean update(Category category) {
        String sql = "UPDATE categories SET category_name = ?, description = ?, icon_class = ? WHERE category_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getIconClass());
            ps.setInt(4, category.getCategoryId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error updating category: " + category.getCategoryId(), e);
        }
    }

    @Override
    public boolean delete(int categoryId) {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new DAOException("Error deleting category: " + categoryId, e);
        }
    }
}
