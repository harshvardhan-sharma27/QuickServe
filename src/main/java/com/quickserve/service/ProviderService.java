package com.quickserve.service;

import com.quickserve.dto.ProviderDashboardDTO;
import com.quickserve.pojo.ProviderProfile;
import java.util.List;

public interface ProviderService {
    ProviderProfile getProfile(int providerId);
    boolean updateProfile(ProviderProfile profile);
    boolean updateVerificationStatus(int providerId, String status);
    List<ProviderProfile> getAllProviders(String statusFilter);
    List<ProviderProfile> getFeaturedProviders(int limit);
    ProviderDashboardDTO getDashboardStats(int providerId);
}
