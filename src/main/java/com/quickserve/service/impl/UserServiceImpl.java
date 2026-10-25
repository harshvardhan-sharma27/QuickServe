package com.quickserve.service.impl;

import com.quickserve.dao.ProviderProfileDAO;
import com.quickserve.dao.UserDAO;
import com.quickserve.dao.impl.ProviderProfileDAOImpl;
import com.quickserve.dao.impl.UserDAOImpl;
import com.quickserve.exception.AuthenticationException;
import com.quickserve.exception.ServiceException;
import com.quickserve.pojo.ProviderProfile;
import com.quickserve.pojo.User;
import com.quickserve.service.UserService;
import com.quickserve.util.PasswordUtil;
import com.quickserve.util.ValidationUtil;

import java.util.List;

public class UserServiceImpl implements UserService {

    private final UserDAO userDAO = new UserDAOImpl();
    private final ProviderProfileDAO providerProfileDAO = new ProviderProfileDAOImpl();

    @Override
    public User login(String email, String password) {
        ValidationUtil.validateEmail(email);
        ValidationUtil.validateNotEmpty(password, "Password");

        User user = userDAO.findByEmail(email.trim().toLowerCase());
        if (user == null) {
            throw new AuthenticationException("Invalid email or password.");
        }

        if ("BLOCKED".equalsIgnoreCase(user.getStatus())) {
            throw new AuthenticationException("Your account has been deactivated. Please contact support.");
        }

        if (!PasswordUtil.checkPassword(password, user.getPasswordHash())) {
            throw new AuthenticationException("Invalid email or password.");
        }

        return user;
    }

    @Override
    public User registerCustomer(String fullName, String email, String password, String phone) {
        ValidationUtil.validateNotEmpty(fullName, "Full Name");
        ValidationUtil.validateEmail(email);
        ValidationUtil.validatePassword(password);
        ValidationUtil.validatePhone(phone);

        String cleanEmail = email.trim().toLowerCase();
        if (userDAO.findByEmail(cleanEmail) != null) {
            throw new ServiceException("An account with this email already exists.");
        }

        String hash = PasswordUtil.hashPassword(password);
        User user = new User();
        user.setFullName(fullName.trim());
        user.setEmail(cleanEmail);
        user.setPasswordHash(hash);
        user.setPhone(phone != null ? phone.trim() : null);
        user.setRole("CUSTOMER");
        user.setStatus("ACTIVE");

        int userId = userDAO.create(user);
        if (userId <= 0) {
            throw new ServiceException("Registration failed. Please try again.");
        }
        user.setUserId(userId);
        return user;
    }

    @Override
    public User registerProvider(String fullName, String email, String password, String phone, String businessName, int experienceYears, String description) {
        ValidationUtil.validateNotEmpty(fullName, "Full Name");
        ValidationUtil.validateEmail(email);
        ValidationUtil.validatePassword(password);
        ValidationUtil.validatePhone(phone);
        ValidationUtil.validateNotEmpty(businessName, "Business Name");

        String cleanEmail = email.trim().toLowerCase();
        if (userDAO.findByEmail(cleanEmail) != null) {
            throw new ServiceException("An account with this email already exists.");
        }

        String hash = PasswordUtil.hashPassword(password);
        User user = new User();
        user.setFullName(fullName.trim());
        user.setEmail(cleanEmail);
        user.setPasswordHash(hash);
        user.setPhone(phone != null ? phone.trim() : null);
        user.setRole("PROVIDER");
        user.setStatus("ACTIVE");

        int userId = userDAO.create(user);
        if (userId <= 0) {
            throw new ServiceException("Registration failed. Please try again.");
        }
        user.setUserId(userId);

        ProviderProfile profile = new ProviderProfile();
        profile.setProviderId(userId);
        profile.setBusinessName(businessName.trim());
        profile.setExperienceYears(experienceYears);
        profile.setDescription(description);
        profile.setVerificationStatus("PENDING");
        profile.setRating(0.0);

        providerProfileDAO.create(profile);
        return user;
    }

    @Override
    public User getUserById(int userId) {
        return userDAO.findById(userId);
    }

    @Override
    public boolean updateProfile(User user) {
        ValidationUtil.validateNotEmpty(user.getFullName(), "Full Name");
        ValidationUtil.validatePhone(user.getPhone());
        return userDAO.update(user);
    }

    @Override
    public boolean updateUserStatus(int userId, String status) {
        return userDAO.updateStatus(userId, status);
    }

    @Override
    public List<User> getAllUsers(String roleFilter, String statusFilter) {
        return userDAO.findAll(roleFilter, statusFilter);
    }
}
