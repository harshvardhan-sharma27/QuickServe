package com.quickserve.dao;

import com.quickserve.pojo.Category;
import java.util.List;

public interface CategoryDAO {
    List<Category> findAll();
    Category findById(int categoryId);
    int create(Category category);
    boolean update(Category category);
    boolean delete(int categoryId);
}
