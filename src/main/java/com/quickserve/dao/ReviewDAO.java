package com.quickserve.dao;

import com.quickserve.pojo.Review;
import java.util.List;

public interface ReviewDAO {
    Review findByBookingId(int bookingId);
    List<Review> findByProvider(int providerId);
    boolean create(Review review);
    double calculateAverageRating(int providerId);
}
