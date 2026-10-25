package com.quickserve.service.impl;

import com.quickserve.dao.CategoryDAO;
import com.quickserve.dao.ServiceDAO;
import com.quickserve.dao.impl.CategoryDAOImpl;
import com.quickserve.dao.impl.ServiceDAOImpl;
import com.quickserve.exception.ServiceException;
import com.quickserve.pojo.Category;
import com.quickserve.pojo.Service;
import com.quickserve.service.ServiceCatalogService;
import com.quickserve.util.ValidationUtil;

import java.util.List;

public class ServiceCatalogServiceImpl implements ServiceCatalogService {

    private final CategoryDAO categoryDAO = new CategoryDAOImpl();
    private final ServiceDAO serviceDAO = new ServiceDAOImpl();

    @Override
    public List<Category> getAllCategories() {
        return categoryDAO.findAll();
    }

    @Override
    public Category getCategoryById(int categoryId) {
        return categoryDAO.findById(categoryId);
    }

    @Override
    public boolean saveCategory(Category category) {
        ValidationUtil.validateNotEmpty(category.getCategoryName(), "Category Name");
        if (category.getCategoryId() > 0) {
            return categoryDAO.update(category);
        } else {
            return categoryDAO.create(category) > 0;
        }
    }

    @Override
    public boolean deleteCategory(int categoryId) {
        return categoryDAO.delete(categoryId);
    }

    @Override
    public List<Service> getServices(Integer categoryId, String keyword, String sortBy, int page, int pageSize) {
        int safePage = Math.max(page, 1);
        int safePageSize = (pageSize > 0) ? pageSize : 12;
        int offset = (safePage - 1) * safePageSize;
        return serviceDAO.findAllActive(categoryId, keyword, sortBy, offset, safePageSize);
    }

    @Override
    public int getTotalServiceCount(Integer categoryId, String keyword) {
        return serviceDAO.countActive(categoryId, keyword);
    }

    @Override
    public Service getServiceById(int serviceId) {
        return serviceDAO.findById(serviceId);
    }

    @Override
    public List<Service> getServicesByProvider(int providerId) {
        return serviceDAO.findByProvider(providerId);
    }

    @Override
    public List<Service> getAllServicesForAdmin() {
        return serviceDAO.findAllForAdmin();
    }

    @Override
    public int createService(Service service) {
        ValidationUtil.validateNotEmpty(service.getServiceName(), "Service Name");
        ValidationUtil.validatePrice(service.getPrice());
        if (service.getCategoryId() <= 0) {
            throw new ServiceException("Please select a category.");
        }
        return serviceDAO.create(service);
    }

    @Override
    public boolean updateService(Service service) {
        ValidationUtil.validateNotEmpty(service.getServiceName(), "Service Name");
        ValidationUtil.validatePrice(service.getPrice());
        return serviceDAO.update(service);
    }

    @Override
    public boolean updateServiceStatus(int serviceId, String status) {
        return serviceDAO.updateStatus(serviceId, status);
    }
}
