package com.quickserve.dao;

import com.quickserve.pojo.Notification;
import java.util.List;

public interface NotificationDAO {
    List<Notification> findByUser(int userId);
    int create(int userId, String message);
    boolean markAsRead(int notificationId, int userId);
    boolean markAllAsRead(int userId);
    int getUnreadCount(int userId);
}
