<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.quickserve.pojo.Booking" %>
<%@ page import="com.quickserve.pojo.Payment" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    Booking booking = (Booking) request.getAttribute("booking");
    Payment payment = (Payment) request.getAttribute("payment");
%>

<div class="row justify-content-center mb-5">
    <div class="col-md-8 col-lg-6">
        <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
            <div class="card-header bg-primary text-white text-center py-4 border-0">
                <i class="bi bi-credit-card-2-front-fill fs-1 text-white opacity-75 mb-2 d-block"></i>
                <h3 class="fw-bold mb-1">QuickServe Pay</h3>
                <p class="small text-light opacity-75 mb-0">Secure Payment Checkout for Booking #<%= booking.getBookingId() %></p>
            </div>

            <div class="card-body p-4 p-md-5">
                <div class="d-flex justify-content-between align-items-center p-3 bg-light rounded-3 mb-4 border">
                    <div>
                        <div class="small text-muted">Amount Payable:</div>
                        <div class="fw-extrabold display-6 text-primary fs-3">&#8377;<%= booking.getTotalAmount() %></div>
                    </div>
                    <span class="badge bg-warning text-dark px-3 py-2">PENDING</span>
                </div>

                <form action="<%= request.getContextPath() %>/customer/payment" method="POST">
                    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">

                    <h6 class="fw-bold text-dark mb-3">Choose Payment Mode</h6>

                    <div class="d-flex flex-column gap-3 mb-4">
                        <label class="p-3 border rounded-3 d-flex align-items-center gap-3 cursor-pointer bg-white">
                            <input type="radio" name="paymentMethod" value="UPI" checked class="form-check-input" onchange="togglePayMode('UPI')">
                            <i class="bi bi-qr-code fs-3 text-primary"></i>
                            <div>
                                <div class="fw-bold text-dark small">Instant UPI (QR / Apps)</div>
                                <div class="text-muted" style="font-size: 0.75rem;">Google Pay, PhonePe, Paytm, BHIM</div>
                            </div>
                        </label>

                        <label class="p-3 border rounded-3 d-flex align-items-center gap-3 cursor-pointer bg-white">
                            <input type="radio" name="paymentMethod" value="CARD" class="form-check-input" onchange="togglePayMode('CARD')">
                            <i class="bi bi-credit-card fs-3 text-info"></i>
                            <div>
                                <div class="fw-bold text-dark small">Credit or Debit Card</div>
                                <div class="text-muted" style="font-size: 0.75rem;">Visa, Mastercard, RuPay</div>
                            </div>
                        </label>
                    </div>

                    <!-- UPI Simulator View -->
                    <div id="upiBox" class="text-center p-3 bg-light rounded-3 border mb-4">
                        <img src="https://api.qrserver.com/v1/create-qr-code/?size=140x140&data=upi://pay?pa=quickserve@upi&pn=QuickServe&am=<%= booking.getTotalAmount() %>" 
                             alt="UPI QR Code" class="img-fluid rounded mb-2 border p-1 bg-white" style="width: 140px; height: 140px;">
                        <div class="small fw-bold text-dark">Scan with any UPI App or tap Pay Below</div>
                        <div class="text-muted" style="font-size: 0.75rem;">quickserve@upi</div>
                    </div>

                    <!-- Card Simulator View -->
                    <div id="cardBox" style="display: none;" class="p-3 bg-light rounded-3 border mb-4">
                        <div class="mb-2">
                            <label class="form-label small text-muted">Card Number</label>
                            <input type="text" class="form-control form-control-sm" placeholder="4242 &bull;&bull;&bull;&bull; &bull;&bull;&bull;&bull; 4242" value="4242 8899 1234 5678">
                        </div>
                        <div class="row g-2">
                            <div class="col-6">
                                <label class="form-label small text-muted">Expiry</label>
                                <input type="text" class="form-control form-control-sm" placeholder="MM/YY" value="12/28">
                            </div>
                            <div class="col-6">
                                <label class="form-label small text-muted">CVV</label>
                                <input type="password" class="form-control form-control-sm" placeholder="123" value="123">
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-success w-100 py-3 fw-bold fs-6 shadow">
                        <i class="bi bi-lock-fill me-1"></i> Authorize & Pay &#8377;<%= booking.getTotalAmount() %>
                    </button>
                </form>

                <div class="text-center text-muted small mt-3" style="font-size: 0.75rem;">
                    <i class="bi bi-shield-check text-success me-1"></i> 256-Bit SSL Encrypted Sandbox Payment Gateway
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function togglePayMode(mode) {
    document.getElementById('upiBox').style.display = (mode === 'UPI') ? 'block' : 'none';
    document.getElementById('cardBox').style.display = (mode === 'CARD') ? 'block' : 'none';
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
