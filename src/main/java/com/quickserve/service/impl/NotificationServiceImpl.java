package com.quickserve.service.impl;

import com.quickserve.dao.NotificationDAO;
import com.quickserve.dao.impl.NotificationDAOImpl;
import com.quickserve.pojo.Notification;
import com.quickserve.service.NotificationService;

import java.util.List;

public class NotificationServiceImpl implements NotificationService {

    private final NotificationDAO notificationDAO = new NotificationDAOImpl();

    @Override
    public List<Notification> getUserNotifications(int userId) {
        return notificationDAO.findByUser(userId);
    }

    @Override
    public boolean markAsRead(int notificationId, int userId) {
        return notificationDAO.markAsRead(notificationId, userId);
    }

    @Override
    public boolean markAllAsRead(int userId) {
        return notificationDAO.markAllAsRead(userId);
    }

    @Override
    public int getUnreadCount(int userId) {
        return notificationDAO.getUnreadCount(userId);
    }
}
