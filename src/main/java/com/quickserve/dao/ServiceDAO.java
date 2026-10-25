package com.quickserve.dao;

import com.quickserve.pojo.Service;
import java.util.List;
import java.util.Map;

public interface ServiceDAO {
    List<Service> findAllActive(Integer categoryId, String keyword, String sortBy, int offset, int limit);
    int countActive(Integer categoryId, String keyword);
    Service findById(int serviceId);
    List<Service> findByProvider(int providerId);
    List<Service> findAllForAdmin();
    int create(Service service);
    boolean update(Service service);
    boolean updateStatus(int serviceId, String status);
    List<Map<String, Object>> findTopBookedServices(int limit);
}
