package com.quickserve.dao;

import com.quickserve.pojo.ProviderProfile;
import java.util.List;

public interface ProviderProfileDAO {
    ProviderProfile findById(int providerId);
    boolean create(ProviderProfile profile);
    boolean update(ProviderProfile profile);
    boolean updateVerificationStatus(int providerId, String status);
    boolean updateRating(int providerId, double rating);
    List<ProviderProfile> findAll(String statusFilter);
    List<ProviderProfile> findFeatured(int limit);
}
