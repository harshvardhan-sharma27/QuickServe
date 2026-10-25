package com.quickserve.util;

import com.quickserve.exception.ValidationException;

import java.math.BigDecimal;
import java.util.regex.Pattern;

public class ValidationUtil {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9]{10,15}$");
    private static final Pattern PINCODE_PATTERN = Pattern.compile("^[0-9]{5,6}$");

    private ValidationUtil() {}

    public static void validateNotEmpty(String value, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            throw new ValidationException(fieldName + " is required.");
        }
    }

    public static void validateEmail(String email) {
        validateNotEmpty(email, "Email");
        if (!EMAIL_PATTERN.matcher(email.trim()).matches()) {
            throw new ValidationException("Invalid email format.");
        }
    }

    public static void validatePhone(String phone) {
        if (phone != null && !phone.trim().isEmpty()) {
            if (!PHONE_PATTERN.matcher(phone.trim()).matches()) {
                throw new ValidationException("Invalid phone number. Must be 10-15 digits.");
            }
        }
    }

    public static void validatePassword(String password) {
        validateNotEmpty(password, "Password");
        if (password.length() < 6) {
            throw new ValidationException("Password must be at least 6 characters long.");
        }
    }

    public static void validatePincode(String pincode) {
        if (pincode != null && !pincode.trim().isEmpty()) {
            if (!PINCODE_PATTERN.matcher(pincode.trim()).matches()) {
                throw new ValidationException("Invalid pincode format.");
            }
        }
    }

    public static void validatePrice(BigDecimal price) {
        if (price == null || price.compareTo(BigDecimal.ZERO) <= 0) {
            throw new ValidationException("Price must be a positive number.");
        }
    }

    public static void validateRating(int rating) {
        if (rating < 1 || rating > 5) {
            throw new ValidationException("Rating must be between 1 and 5.");
        }
    }
}
