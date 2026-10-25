package com.quickserve.service.impl;

import com.quickserve.dao.BookingDAO;
import com.quickserve.dao.PaymentDAO;
import com.quickserve.dao.ProviderProfileDAO;
import com.quickserve.dao.ServiceDAO;
import com.quickserve.dao.impl.BookingDAOImpl;
import com.quickserve.dao.impl.PaymentDAOImpl;
import com.quickserve.dao.impl.ProviderProfileDAOImpl;
import com.quickserve.dao.impl.ServiceDAOImpl;
import com.quickserve.dto.ProviderDashboardDTO;
import com.quickserve.pojo.Booking;
import com.quickserve.pojo.ProviderProfile;
import com.quickserve.service.ProviderService;
import com.quickserve.util.ValidationUtil;

import java.math.BigDecimal;
import java.util.List;

public class ProviderServiceImpl implements ProviderService {

    private final ProviderProfileDAO providerProfileDAO = new ProviderProfileDAOImpl();
    private final BookingDAO bookingDAO = new BookingDAOImpl();
    private final PaymentDAO paymentDAO = new PaymentDAOImpl();
    private final ServiceDAO serviceDAO = new ServiceDAOImpl();

    @Override
    public ProviderProfile getProfile(int providerId) {
        return providerProfileDAO.findById(providerId);
    }

    @Override
    public boolean updateProfile(ProviderProfile profile) {
        ValidationUtil.validateNotEmpty(profile.getBusinessName(), "Business Name");
        return providerProfileDAO.update(profile);
    }

    @Override
    public boolean updateVerificationStatus(int providerId, String status) {
        return providerProfileDAO.updateVerificationStatus(providerId, status);
    }

    @Override
    public List<ProviderProfile> getAllProviders(String statusFilter) {
        return providerProfileDAO.findAll(statusFilter);
    }

    @Override
    public List<ProviderProfile> getFeaturedProviders(int limit) {
        return providerProfileDAO.findFeatured(limit);
    }

    @Override
    public ProviderDashboardDTO getDashboardStats(int providerId) {
        ProviderDashboardDTO dto = new ProviderDashboardDTO();
        ProviderProfile profile = providerProfileDAO.findById(providerId);
        if (profile != null) {
            dto.setRating(profile.getRating());
        }

        BigDecimal earnings = paymentDAO.getProviderEarnings(providerId);
        dto.setTotalEarnings(earnings != null ? earnings : BigDecimal.ZERO);

        int total = bookingDAO.countByProvider(providerId, null);
        int pending = bookingDAO.countByProvider(providerId, "PENDING");
        int completed = bookingDAO.countByProvider(providerId, "COMPLETED");

        dto.setTotalBookings(total);
        dto.setPendingBookings(pending);
        dto.setCompletedBookings(completed);
        dto.setActiveServicesCount(serviceDAO.findByProvider(providerId).size());

        List<Booking> bookings = bookingDAO.findByProvider(providerId);
        if (bookings.size() > 5) {
            dto.setRecentBookings(bookings.subList(0, 5));
        } else {
            dto.setRecentBookings(bookings);
        }

        return dto;
    }
}
