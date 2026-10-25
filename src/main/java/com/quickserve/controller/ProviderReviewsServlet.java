package com.quickserve.controller;

import com.quickserve.pojo.ProviderProfile;
import com.quickserve.pojo.Review;
import com.quickserve.pojo.User;
import com.quickserve.service.ProviderService;
import com.quickserve.service.ReviewService;
import com.quickserve.service.impl.ProviderServiceImpl;
import com.quickserve.service.impl.ReviewServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProviderReviewsServlet", urlPatterns = {"/provider/reviews"})
public class ProviderReviewsServlet extends HttpServlet {

    private final ReviewService reviewService = new ReviewServiceImpl();
    private final ProviderService providerService = new ProviderServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        ProviderProfile profile = providerService.getProfile(user.getUserId());
        List<Review> reviews = reviewService.getReviewsByProvider(user.getUserId());

        request.setAttribute("profile", profile);
        request.setAttribute("reviews", reviews);

        request.getRequestDispatcher("/WEB-INF/views/provider/reviews.jsp").forward(request, response);
    }
}
