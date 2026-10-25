package com.quickserve.service.impl;

import com.quickserve.dao.NotificationDAO;
import com.quickserve.dao.ProviderProfileDAO;
import com.quickserve.dao.ReviewDAO;
import com.quickserve.dao.impl.NotificationDAOImpl;
import com.quickserve.dao.impl.ProviderProfileDAOImpl;
import com.quickserve.dao.impl.ReviewDAOImpl;
import com.quickserve.exception.ServiceException;
import com.quickserve.pojo.Review;
import com.quickserve.service.ReviewService;
import com.quickserve.util.ValidationUtil;

import java.util.List;

public class ReviewServiceImpl implements ReviewService {

    private final ReviewDAO reviewDAO = new ReviewDAOImpl();
    private final ProviderProfileDAO providerProfileDAO = new ProviderProfileDAOImpl();
    private final NotificationDAO notificationDAO = new NotificationDAOImpl();

    @Override
    public boolean addReview(int bookingId, int customerId, int providerId, int rating, String comment) {
        ValidationUtil.validateRating(rating);

        Review existing = reviewDAO.findByBookingId(bookingId);
        if (existing != null) {
            throw new ServiceException("A review has already been submitted for this booking.");
        }

        Review r = new Review();
        r.setBookingId(bookingId);
        r.setCustomerId(customerId);
        r.setProviderId(providerId);
        r.setRating(rating);
        r.setComment(comment != null ? comment.trim() : "");

        boolean created = reviewDAO.create(r);
        if (created) {
            // Recalculate average rating for provider
            double newAvg = reviewDAO.calculateAverageRating(providerId);
            providerProfileDAO.updateRating(providerId, newAvg);

            notificationDAO.create(providerId, "You received a new " + rating + "-star review for booking #" + bookingId + "!");
        }
        return created;
    }

    @Override
    public Review getReviewByBooking(int bookingId) {
        return reviewDAO.findByBookingId(bookingId);
    }

    @Override
    public List<Review> getReviewsByProvider(int providerId) {
        return reviewDAO.findByProvider(providerId);
    }
}
