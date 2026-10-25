<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.quickserve.pojo.ProviderAvailability" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
    List<ProviderAvailability> slots = (List<ProviderAvailability>) request.getAttribute("slots");
    String minDate = java.time.LocalDate.now().toString();
%>

<div class="row g-4 mb-5">
    <div class="col-lg-7">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h2 class="h4 fw-bold mb-0"><i class="bi bi-calendar3 text-primary me-2"></i>My Working Calendar</h2>
                <span class="text-muted small">Clients can book you only during registered open time slots</span>
            </div>
        </div>

        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
            <div class="table-responsive">
                <table class="table table-custom mb-0">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Time Window</th>
                            <th>Status</th>
                            <th class="text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (slots != null && !slots.isEmpty()) {
                            for (ProviderAvailability s : slots) { %>
                            <tr>
                                <td class="fw-bold"><%= s.getAvailableDate() %></td>
                                <td>
                                    <i class="bi bi-clock me-1 text-primary"></i>
                                    <%= s.getStartTime().toString().substring(0, 5) %> - <%= s.getEndTime().toString().substring(0, 5) %>
                                </td>
                                <td>
                                    <span class="badge <%= "AVAILABLE".equalsIgnoreCase(s.getStatus()) ? "bg-success" : "bg-secondary" %>">
                                        <%= s.getStatus() %>
                                    </span>
                                </td>
                                <td class="text-end">
                                    <a href="<%= request.getContextPath() %>/provider/availability?action=delete&id=<%= s.getAvailabilityId() %>" 
                                       class="btn btn-sm btn-outline-danger" 
                                       onclick="return confirm('Remove this schedule slot?');">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr>
                                <td colspan="4" class="text-center py-4 text-muted">
                                    No slots scheduled. Use the form to add your working hours.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Add Availability Slot -->
    <div class="col-lg-5">
        <div class="card border-0 shadow-sm rounded-4 p-4">
            <h5 class="fw-bold mb-3"><i class="bi bi-plus-circle-fill text-primary me-2"></i>Add Available Slot</h5>

            <form action="<%= request.getContextPath() %>/provider/availability" method="POST">
                <div class="mb-3">
                    <label class="form-label small fw-semibold text-muted">Work Date</label>
                    <input type="date" name="availableDate" class="form-control form-control-sm" min="<%= minDate %>" value="<%= minDate %>" required>
                </div>

                <div class="row g-2 mb-4">
                    <div class="col-6">
                        <label class="form-label small fw-semibold text-muted">Start Time</label>
                        <input type="time" name="startTime" class="form-control form-control-sm" value="09:00" required>
                    </div>
                    <div class="col-6">
                        <label class="form-label small fw-semibold text-muted">End Time</label>
                        <input type="time" name="endTime" class="form-control form-control-sm" value="12:00" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary-qs w-100 btn-sm">Save Availability Slot</button>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
