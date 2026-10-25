package com.quickserve.filter;

import com.quickserve.pojo.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(filterName = "AuthorizationFilter", urlPatterns = {"/customer/*", "/provider/*", "/admin/*"})
public class AuthorizationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null) {
            String role = user.getRole();
            String uri = request.getRequestURI();
            String contextPath = request.getContextPath();
            String relative = uri.substring(contextPath.length());

            if (relative.startsWith("/admin") && !"ADMIN".equalsIgnoreCase(role)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin privileges required.");
                return;
            }

            if (relative.startsWith("/provider") && !"PROVIDER".equalsIgnoreCase(role)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Service Provider privileges required.");
                return;
            }

            if (relative.startsWith("/customer") && !"CUSTOMER".equalsIgnoreCase(role)) {
                // If an admin or provider attempts customer actions, redirect or restrict
                if ("ADMIN".equalsIgnoreCase(role)) {
                    response.sendRedirect(contextPath + "/admin/dashboard");
                    return;
                } else if ("PROVIDER".equalsIgnoreCase(role)) {
                    response.sendRedirect(contextPath + "/provider/dashboard");
                    return;
                }
            }
        }

        chain.doFilter(req, res);
    }
}
