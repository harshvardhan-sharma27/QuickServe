package com.quickserve.dao;

import com.quickserve.pojo.BookingItem;
import java.util.List;

public interface BookingItemDAO {
    List<BookingItem> findByBookingId(int bookingId);
}
