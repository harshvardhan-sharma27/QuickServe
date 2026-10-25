package com.quickserve.controller;

import com.quickserve.pojo.Notification;
import com.quickserve.pojo.User;
import com.quickserve.service.NotificationService;
import com.quickserve.service.impl.NotificationServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/customer/notifications", "/provider/notifications", "/notifications/mark-read", "/notifications/mark-all-read"})
public class NotificationServlet extends HttpServlet {

    private final NotificationService notificationService = new NotificationServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String servletPath = request.getServletPath();
        if ("/notifications/mark-all-read".equals(servletPath)) {
            notificationService.markAllAsRead(user.getUserId());
            redirectBack(user, response, request.getContextPath());
            return;
        }

        String markId = request.getParameter("id");
        if (markId != null) {
            try {
                notificationService.markAsRead(Integer.parseInt(markId), user.getUserId());
            } catch (NumberFormatException ignored) {}
            redirectBack(user, response, request.getContextPath());
            return;
        }

        List<Notification> notifications = notificationService.getUserNotifications(user.getUserId());
        request.setAttribute("notifications", notifications);

        request.getRequestDispatcher("/WEB-INF/views/notifications.jsp").forward(request, response);
    }

    private void redirectBack(User user, HttpServletResponse response, String cp) throws IOException {
        if ("PROVIDER".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(cp + "/provider/notifications");
        } else {
            response.sendRedirect(cp + "/customer/notifications");
        }
    }
}
