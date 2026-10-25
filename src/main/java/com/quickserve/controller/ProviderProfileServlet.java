package com.quickserve.controller;

import com.quickserve.pojo.ProviderProfile;
import com.quickserve.pojo.User;
import com.quickserve.service.ProviderService;
import com.quickserve.service.UserService;
import com.quickserve.service.impl.ProviderServiceImpl;
import com.quickserve.service.impl.UserServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ProviderProfileServlet", urlPatterns = {"/provider/profile"})
public class ProviderProfileServlet extends HttpServlet {

    private final ProviderService providerService = new ProviderServiceImpl();
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        ProviderProfile profile = providerService.getProfile(user.getUserId());
        request.setAttribute("profile", profile);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("successMessage", msg);

        request.getRequestDispatcher("/WEB-INF/views/provider/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String businessName = request.getParameter("businessName");
        int experience = 0;
        try {
            experience = Integer.parseInt(request.getParameter("experienceYears"));
        } catch (NumberFormatException ignored) {}
        String description = request.getParameter("description");

        try {
            user.setFullName(fullName);
            user.setPhone(phone);
            userService.updateProfile(user);

            ProviderProfile profile = providerService.getProfile(user.getUserId());
            if (profile != null) {
                profile.setBusinessName(businessName);
                profile.setExperienceYears(experience);
                profile.setDescription(description);
                providerService.updateProfile(profile);
            }

            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/provider/profile?msg=Profile+updated+successfully");

        } catch (Exception e) {
            request.setAttribute("errorMessage", e.getMessage());
            doGet(request, response);
        }
    }
}
