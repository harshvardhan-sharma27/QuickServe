package com.quickserve.dao;

import com.quickserve.pojo.Address;
import java.util.List;

public interface AddressDAO {
    List<Address> findByUser(int userId);
    Address findById(int addressId);
    int create(Address address);
    boolean update(Address address);
    boolean delete(int addressId, int userId);
    boolean setDefault(int addressId, int userId);
}
