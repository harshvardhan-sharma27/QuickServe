package com.quickserve.service;

import com.quickserve.pojo.User;
import java.util.List;

public interface UserService {
    User login(String email, String password);
    User registerCustomer(String fullName, String email, String password, String phone);
    User registerProvider(String fullName, String email, String password, String phone, String businessName, int experienceYears, String description);
    User getUserById(int userId);
    boolean updateProfile(User user);
    boolean updateUserStatus(int userId, String status);
    List<User> getAllUsers(String roleFilter, String statusFilter);
}
