package com.quickserve.service;

import com.quickserve.pojo.Review;
import java.util.List;

public interface ReviewService {
    boolean addReview(int bookingId, int customerId, int providerId, int rating, String comment);
    Review getReviewByBooking(int bookingId);
    List<Review> getReviewsByProvider(int providerId);
}
