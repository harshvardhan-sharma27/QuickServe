package com.quickserve.controller;

import com.quickserve.pojo.User;
import com.quickserve.service.UserService;
import com.quickserve.service.impl.UserServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUsersServlet", urlPatterns = {"/admin/users"})
public class AdminUsersServlet extends HttpServlet {

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        String statusParam = request.getParameter("status");

        if ("status".equalsIgnoreCase(action) && idParam != null && statusParam != null) {
            try {
                int userId = Integer.parseInt(idParam);
                userService.updateUserStatus(userId, statusParam);
                response.sendRedirect(request.getContextPath() + "/admin/users?msg=User+status+updated");
                return;
            } catch (Exception ignored) {}
        }

        String roleFilter = request.getParameter("role");
        String statusFilter = request.getParameter("statusFilter");

        List<User> users = userService.getAllUsers(roleFilter, statusFilter);
        request.setAttribute("users", users);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("statusFilter", statusFilter);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("successMessage", msg);

        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
    }
}
