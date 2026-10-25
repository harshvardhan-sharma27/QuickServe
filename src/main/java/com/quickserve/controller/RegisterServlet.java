package com.quickserve.controller;

import com.quickserve.exception.ServiceException;
import com.quickserve.exception.ValidationException;
import com.quickserve.pojo.User;
import com.quickserve.service.UserService;
import com.quickserve.service.impl.UserServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("role");
        if (role != null) {
            request.setAttribute("selectedRole", role.toUpperCase());
        }
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("role");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");

        try {
            User registeredUser;
            if ("PROVIDER".equalsIgnoreCase(role)) {
                String businessName = request.getParameter("businessName");
                int experienceYears = 0;
                try {
                    experienceYears = Integer.parseInt(request.getParameter("experienceYears"));
                } catch (Exception ignored) {}
                String description = request.getParameter("description");

                registeredUser = userService.registerProvider(fullName, email, password, phone, businessName, experienceYears, description);
            } else {
                registeredUser = userService.registerCustomer(fullName, email, password, phone);
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("user", registeredUser);

            String cp = request.getContextPath();
            if ("PROVIDER".equalsIgnoreCase(registeredUser.getRole())) {
                response.sendRedirect(cp + "/provider/dashboard?msg=" + java.net.URLEncoder.encode("Provider account registered successfully! Profile verification is pending.", "UTF-8"));
            } else {
                response.sendRedirect(cp + "/customer/dashboard?msg=" + java.net.URLEncoder.encode("Welcome to QuickServe! Your account is active.", "UTF-8"));
            }

        } catch (ServiceException | ValidationException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("selectedRole", role);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("businessName", request.getParameter("businessName"));
            request.setAttribute("experienceYears", request.getParameter("experienceYears"));
            request.setAttribute("description", request.getParameter("description"));
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}
