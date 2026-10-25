package com.quickserve.dao;

import com.quickserve.pojo.ProviderAvailability;
import java.sql.Date;
import java.util.List;

public interface ProviderAvailabilityDAO {
    List<ProviderAvailability> findByProvider(int providerId);
    List<ProviderAvailability> findAvailableByProviderAndDate(int providerId, Date date);
    ProviderAvailability findById(int availabilityId);
    int create(ProviderAvailability slot);
    boolean delete(int availabilityId, int providerId);
    boolean updateStatus(int availabilityId, String status);
}
