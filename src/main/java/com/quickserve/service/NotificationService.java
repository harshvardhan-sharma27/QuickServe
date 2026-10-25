package com.quickserve.service;

import com.quickserve.pojo.Notification;
import java.util.List;

public interface NotificationService {
    List<Notification> getUserNotifications(int userId);
    boolean markAsRead(int notificationId, int userId);
    boolean markAllAsRead(int userId);
    int getUnreadCount(int userId);
}
