package com.quickserve.dao;

import com.quickserve.pojo.User;
import java.util.List;

public interface UserDAO {
    User findById(int userId);
    User findByEmail(String email);
    int create(User user);
    boolean update(User user);
    boolean updateStatus(int userId, String status);
    List<User> findAll(String roleFilter, String statusFilter);
    int countByRole(String role);
}
