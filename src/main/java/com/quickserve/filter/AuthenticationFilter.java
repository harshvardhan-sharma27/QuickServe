package com.quickserve.filter;

import com.quickserve.pojo.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/customer/*", "/provider/*", "/admin/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            String requestURI = request.getRequestURI();
            String contextPath = request.getContextPath();
            String targetPath = requestURI.substring(contextPath.length());
            response.sendRedirect(contextPath + "/login?error=" + java.net.URLEncoder.encode("Please log in to continue.", "UTF-8") + "&redirect=" + java.net.URLEncoder.encode(targetPath, "UTF-8"));
            return;
        }

        chain.doFilter(req, res);
    }
}
