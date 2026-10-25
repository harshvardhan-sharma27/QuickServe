<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
</main> <!-- Close main from header.jsp -->

<footer class="footer-custom">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-4">
                <a class="navbar-brand text-white mb-3" href="<%= request.getContextPath() %>/home">
                    <i class="bi bi-tools text-primary"></i>
                    <span class="text-white">Quick<span class="text-primary">Serve</span></span>
                </a>
                <p class="small text-muted mt-2">
                    India's premier verified home services platform. Connecting experienced, background-verified professionals with homeowners for fast, reliable maintenance, repairs, and sanitization.
                </p>
                <div class="d-flex gap-3 text-muted fs-5 mt-3">
                    <a href="#" class="text-muted"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="text-muted"><i class="bi bi-instagram"></i></a>
                    <a href="#" class="text-muted"><i class="bi bi-twitter-x"></i></a>
                    <a href="#" class="text-muted"><i class="bi bi-linkedin"></i></a>
                </div>
            </div>

            <div class="col-6 col-lg-2">
                <h5>Categories</h5>
                <a href="<%= request.getContextPath() %>/services?category=1" class="footer-link">Cleaning</a>
                <a href="<%= request.getContextPath() %>/services?category=2" class="footer-link">Electrical</a>
                <a href="<%= request.getContextPath() %>/services?category=3" class="footer-link">Plumbing</a>
                <a href="<%= request.getContextPath() %>/services?category=4" class="footer-link">AC Repair</a>
                <a href="<%= request.getContextPath() %>/services?category=5" class="footer-link">Carpentry</a>
            </div>

            <div class="col-6 col-lg-3">
                <h5>For Customers</h5>
                <a href="<%= request.getContextPath() %>/services" class="footer-link">Explore Services</a>
                <a href="<%= request.getContextPath() %>/customer/bookings" class="footer-link">Track Booking</a>
                <a href="<%= request.getContextPath() %>/customer/support" class="footer-link">Help & Support</a>
                <a href="<%= request.getContextPath() %>/register?role=PROVIDER" class="footer-link">Join as Service Partner</a>
            </div>

            <div class="col-lg-3">
                <h5>Tech Architecture</h5>
                <div class="d-flex flex-wrap gap-2 mt-2">
                    <span class="badge bg-dark border border-secondary text-light">Java 17</span>
                    <span class="badge bg-dark border border-secondary text-light">Jakarta Servlet</span>
                    <span class="badge bg-dark border border-secondary text-light">JSP & JSTL</span>
                    <span class="badge bg-dark border border-secondary text-light">JDBC Transactions</span>
                    <span class="badge bg-dark border border-secondary text-light">MySQL 8 (12 Tables)</span>
                    <span class="badge bg-dark border border-secondary text-light">Apache Tomcat 10.1</span>
                    <span class="badge bg-dark border border-secondary text-light">BCrypt Hashing</span>
                </div>
                <div class="small text-muted mt-3">
                    <i class="bi bi-shield-check text-success me-1"></i> Layered MVC &bull; PreparedStatement Protected
                </div>
            </div>
        </div>

        <div class="footer-bottom d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
            <div>
                &copy; <%= java.time.Year.now() %> QuickServe Inc. All rights reserved.
            </div>
            <div class="text-muted small">
                Crafted for Kiran Academy &bull; Enterprise MVC Architecture
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- QuickServe JS -->
<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>
