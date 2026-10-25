<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.quickserve.pojo.Service" %>
<%@ page import="com.quickserve.pojo.Address" %>
<%@ page import="com.quickserve.pojo.ProviderAvailability" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    Service selectedService = (Service) request.getAttribute("selectedService");
    List<Address> addresses = (List<Address>) request.getAttribute("addresses");
    List<ProviderAvailability> slots = (List<ProviderAvailability>) request.getAttribute("slots");
    List<Service> providerServices = (List<Service>) request.getAttribute("providerServices");
    String today = java.time.LocalDate.now().toString();
%>

<div class="row justify-content-center mb-5">
    <div class="col-lg-10 col-xl-9">
        <div class="mb-4">
            <a href="<%= request.getContextPath() %>/service-details?id=<%= selectedService.getServiceId() %>" class="text-muted small text-decoration-none">
                <i class="bi bi-arrow-left me-1"></i> Back to Service
            </a>
            <h2 class="h3 fw-bold mt-2 mb-0">Confirm & Complete Booking</h2>
            <span class="text-muted small">Professional service by <%= selectedService.getProviderBusinessName() %></span>
        </div>

        <form action="<%= request.getContextPath() %>/customer/book-service" method="POST" id="bookingForm">
            <input type="hidden" name="providerId" id="bookingProviderIdInput" value="<%= selectedService.getProviderId() %>">
            <input type="hidden" name="bookingTime" id="bookingTimeInput" value="10:00:00">

            <div class="row g-4">
                <!-- Left Column: Booking Options -->
                <div class="col-lg-7">
                    <!-- 1. Service Selection & Addons -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                        <h5 class="fw-bold mb-3 d-flex align-items-center">
                            <span class="badge bg-primary rounded-circle me-2 d-inline-flex align-items-center justify-content-center" style="width:24px; height:24px;">1</span>
                            Selected Services
                        </h5>

                        <div class="d-flex align-items-center justify-content-between p-3 bg-light rounded-3 mb-3 border">
                            <div class="d-flex align-items-center gap-3">
                                <input type="checkbox" name="serviceIds" value="<%= selectedService.getServiceId() %>" checked disabled class="form-check-input" style="transform: scale(1.2);">
                                <input type="hidden" name="serviceIds" value="<%= selectedService.getServiceId() %>">
                                <div>
                                    <div class="fw-bold text-dark"><%= selectedService.getServiceName() %></div>
                                    <div class="text-muted small"><%= selectedService.getDurationMinutes() %> mins &bull; Base package</div>
                                </div>
                            </div>
                            <div class="fw-bold fs-6">&#8377;<%= selectedService.getPrice() %></div>
                        </div>

                        <!-- Add-ons by same provider -->
                        <% if (providerServices != null && providerServices.size() > 1) { %>
                            <div class="small fw-bold text-muted mb-2">Optional Add-ons from <%= selectedService.getProviderBusinessName() %>:</div>
                            <div class="d-flex flex-column gap-2">
                                <% for (Service s : providerServices) {
                                    if (s.getServiceId() != selectedService.getServiceId()) { %>
                                    <label class="d-flex align-items-center justify-content-between p-2 border rounded-3 bg-white cursor-pointer hover-bg-light">
                                        <div class="d-flex align-items-center gap-2">
                                            <input type="checkbox" name="serviceIds" value="<%= s.getServiceId() %>" class="form-check-input addon-checkbox" data-price="<%= s.getPrice() %>" onchange="calculateTotal()">
                                            <span class="small fw-semibold text-dark"><%= s.getServiceName() %></span>
                                        </div>
                                        <span class="small fw-bold text-primary">+&#8377;<%= s.getPrice() %></span>
                                    </label>
                                <% } } %>
                            </div>
                        <% } %>
                    </div>

                    <!-- 2. Address Selection -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold mb-0 d-flex align-items-center">
                                <span class="badge bg-primary rounded-circle me-2 d-inline-flex align-items-center justify-content-center" style="width:24px; height:24px;">2</span>
                                Service Address
                            </h5>
                            <a href="<%= request.getContextPath() %>/customer/addresses" target="_blank" class="small text-primary fw-semibold">
                                <i class="bi bi-plus-circle me-1"></i>Add New Address
                            </a>
                        </div>

                        <% if (addresses == null || addresses.isEmpty()) { %>
                            <div class="alert alert-warning small mb-0">
                                You don't have any saved addresses. Please <a href="<%= request.getContextPath() %>/customer/addresses" target="_blank" class="fw-bold text-dark">add an address</a> first and refresh this page.
                            </div>
                        <% } else { %>
                            <div class="d-flex flex-column gap-2">
                                <% for (int i = 0; i < addresses.size(); i++) {
                                    Address a = addresses.get(i);
                                %>
                                    <label class="p-3 border rounded-3 d-flex align-items-start gap-3 cursor-pointer bg-white">
                                        <input type="radio" name="addressId" value="<%= a.getAddressId() %>" class="form-check-input mt-1" <%= (a.isDefault() || i == 0) ? "checked" : "" %>>
                                        <div class="flex-grow-1">
                                            <div class="d-flex justify-content-between">
                                                <span class="fw-bold text-dark small"><%= a.getCity() %> <%= a.isDefault() ? "<span class='badge bg-primary-soft text-primary ms-1'>Default</span>" : "" %></span>
                                            </div>
                                            <div class="text-secondary small mt-1"><%= a.getFormattedAddress() %></div>
                                        </div>
                                    </label>
                                <% } %>
                            </div>
                        <% } %>
                    </div>

                    <!-- 3. Date & Available Slots -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 mb-4">
                        <h5 class="fw-bold mb-3 d-flex align-items-center">
                            <span class="badge bg-primary rounded-circle me-2 d-inline-flex align-items-center justify-content-center" style="width:24px; height:24px;">3</span>
                            Preferred Date & Time
                        </h5>

                        <div class="row g-3 mb-3">
                            <div class="col-sm-6">
                                <label class="form-label small fw-semibold text-muted">Select Date</label>
                                <input type="date" name="bookingDate" id="bookingDateInput" class="form-control" 
                                       min="<%= today %>" value="<%= today %>" required data-context-path="<%= request.getContextPath() %>">
                            </div>
                        </div>

                        <label class="form-label small fw-semibold text-muted mb-2">Available Provider Slots</label>
                        <div id="availableSlotsContainer" class="p-2 border rounded-3 bg-light">
                            <% if (slots != null && !slots.isEmpty()) { %>
                                <div class="d-flex flex-wrap gap-2">
                                    <% for (int i = 0; i < slots.size(); i++) {
                                        ProviderAvailability s = slots.get(i);
                                        if ("AVAILABLE".equalsIgnoreCase(s.getStatus())) {
                                    %>
                                        <label class="btn btn-outline-primary btn-sm slot-btn">
                                            <input type="radio" name="availabilityId" value="<%= s.getAvailabilityId() %>" class="d-none" <%= (i == 0) ? "checked" : "" %> onchange="updateBookingTime('<%= s.getStartTime() %>')">
                                            <i class="bi bi-clock me-1"></i> <%= s.getStartTime().toString().substring(0, 5) %> - <%= s.getEndTime().toString().substring(0, 5) %>
                                        </label>
                                    <% } } %>
                                </div>
                            <% } else { %>
                                <div class="text-muted small">No specific schedule slot selected. Standard morning service (10:00 AM) will be assigned.</div>
                            <% } %>
                        </div>
                    </div>

                    <!-- 4. Notes / Instructions -->
                    <div class="card border-0 shadow-sm rounded-4 p-4">
                        <h5 class="fw-bold mb-3 d-flex align-items-center">
                            <span class="badge bg-primary rounded-circle me-2 d-inline-flex align-items-center justify-content-center" style="width:24px; height:24px;">4</span>
                            Instructions for Professional (Optional)
                        </h5>
                        <textarea name="notes" class="form-control" rows="2" placeholder="e.g. Please bring an extension cord, gate bell is out of order, etc."></textarea>
                    </div>
                </div>

                <!-- Right Column: Order Summary & Checkout -->
                <div class="col-lg-5">
                    <div class="card border-0 shadow rounded-4 p-4 sticky-top" style="top: 85px;">
                        <h5 class="fw-bold mb-3 border-bottom pb-2">Order Summary</h5>

                        <div class="d-flex justify-content-between mb-2 small">
                            <span class="text-muted">Base Service:</span>
                            <span class="fw-bold">&#8377;<%= selectedService.getPrice() %></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2 small">
                            <span class="text-muted">Add-on Services:</span>
                            <span class="fw-bold text-primary" id="addonsDisplay">&#8377;0.00</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2 small">
                            <span class="text-muted">Safety & Service Fee:</span>
                            <span class="text-success fw-bold">FREE</span>
                        </div>

                        <hr class="text-muted opacity-25 my-3">

                        <div class="d-flex justify-content-between align-items-baseline mb-4">
                            <span class="fw-bold text-dark fs-6">Grand Total:</span>
                            <span class="display-6 fw-extrabold text-primary" id="grandTotalDisplay">&#8377;<%= selectedService.getPrice() %></span>
                        </div>

                        <!-- Payment Method Selection -->
                        <label class="form-label small fw-semibold text-muted mb-2">Select Payment Method</label>
                        <div class="d-flex flex-column gap-2 mb-4">
                            <label class="p-2 border rounded-3 d-flex align-items-center gap-2 cursor-pointer bg-light">
                                <input type="radio" name="paymentMethod" value="UPI" checked class="form-check-input">
                                <i class="bi bi-qr-code text-primary fs-5"></i>
                                <span class="small fw-bold">Instant UPI (GPay / PhonePe / Paytm)</span>
                            </label>
                            <label class="p-2 border rounded-3 d-flex align-items-center gap-2 cursor-pointer bg-light">
                                <input type="radio" name="paymentMethod" value="CARD" class="form-check-input">
                                <i class="bi bi-credit-card text-info fs-5"></i>
                                <span class="small fw-bold">Credit / Debit Card</span>
                            </label>
                            <label class="p-2 border rounded-3 d-flex align-items-center gap-2 cursor-pointer bg-light">
                                <input type="radio" name="paymentMethod" value="CASH" class="form-check-input">
                                <i class="bi bi-cash-stack text-success fs-5"></i>
                                <span class="small fw-bold">Cash on Service Completion</span>
                            </label>
                        </div>

                        <button type="submit" class="btn btn-primary-qs w-100 py-3 fw-bold fs-6 shadow">
                            <i class="bi bi-lock-fill me-2"></i>Confirm & Book Now
                        </button>

                        <div class="text-center text-muted small mt-3" style="font-size: 0.75rem;">
                            <i class="bi bi-shield-check text-success me-1"></i> Atomic JDBC Transaction Secured &bull; Free Cancellation
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
const basePrice = <%= selectedService.getPrice() %>;

function calculateTotal() {
    let addonsTotal = 0;
    const checkboxes = document.querySelectorAll('.addon-checkbox:checked');
    checkboxes.forEach(cb => {
        addonsTotal += parseFloat(cb.dataset.price || 0);
    });

    document.getElementById('addonsDisplay').innerText = '₹' + addonsTotal.toFixed(2);
    const grandTotal = basePrice + addonsTotal;
    document.getElementById('grandTotalDisplay').innerText = '₹' + grandTotal.toFixed(2);
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
