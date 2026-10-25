package com.quickserve.service;

import com.quickserve.pojo.Category;
import com.quickserve.pojo.Service;

import java.util.List;

public interface ServiceCatalogService {
    List<Category> getAllCategories();
    Category getCategoryById(int categoryId);
    boolean saveCategory(Category category);
    boolean deleteCategory(int categoryId);

    List<Service> getServices(Integer categoryId, String keyword, String sortBy, int page, int pageSize);
    int getTotalServiceCount(Integer categoryId, String keyword);
    Service getServiceById(int serviceId);
    List<Service> getServicesByProvider(int providerId);
    List<Service> getAllServicesForAdmin();

    int createService(Service service);
    boolean updateService(Service service);
    boolean updateServiceStatus(int serviceId, String status);
}
