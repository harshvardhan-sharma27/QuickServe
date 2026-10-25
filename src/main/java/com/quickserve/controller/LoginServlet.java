package com.quickserve.controller;

import com.quickserve.exception.AuthenticationException;
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

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectByRole(user, request, response);
            return;
        }

        String error = request.getParameter("error");
        String msg = request.getParameter("msg");
        String redirect = request.getParameter("redirect");

        if (error != null) request.setAttribute("errorMessage", error);
        if (msg != null) request.setAttribute("successMessage", msg);
        if (redirect != null) request.setAttribute("redirect", redirect);

        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");

        try {
            User user = userService.login(email, password);

            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);

            if (redirect != null && !redirect.trim().isEmpty() && !redirect.contains("login")) {
                response.sendRedirect(request.getContextPath() + redirect);
                return;
            }

            redirectByRole(user, request, response);

        } catch (AuthenticationException | ValidationException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("email", email);
            request.setAttribute("redirect", redirect);
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }

    private void redirectByRole(User user, HttpServletRequest request, HttpServletResponse response) throws IOException {
        String cp = request.getContextPath();
        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(cp + "/admin/dashboard");
        } else if ("PROVIDER".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(cp + "/provider/dashboard");
        } else {
            response.sendRedirect(cp + "/customer/dashboard");
        }
    }
}
