package com.quickserve.service.impl;

import com.quickserve.dao.*;
import com.quickserve.dao.impl.*;
import com.quickserve.dto.DashboardDTO;
import com.quickserve.service.AdminDashboardService;

public class AdminDashboardServiceImpl implements AdminDashboardService {

    private final UserDAO userDAO = new UserDAOImpl();
    private final BookingDAO bookingDAO = new BookingDAOImpl();
    private final PaymentDAO paymentDAO = new PaymentDAOImpl();
    private final ServiceDAO serviceDAO = new ServiceDAOImpl();
    private final SupportTicketDAO supportTicketDAO = new SupportTicketDAOImpl();

    @Override
    public DashboardDTO getDashboardData() {
        DashboardDTO dto = new DashboardDTO();
        dto.setTotalCustomers(userDAO.countByRole("CUSTOMER"));
        dto.setTotalProviders(userDAO.countByRole("PROVIDER"));
        dto.setTotalBookings(bookingDAO.countAll(null));
        dto.setTotalRevenue(paymentDAO.getTotalSuccessfulRevenue());
        dto.setPendingBookings(bookingDAO.countAll("PENDING"));
        dto.setOpenTickets(supportTicketDAO.countOpenTickets());
        dto.setTopServices(serviceDAO.findTopBookedServices(6));
        dto.setMonthlyRevenue(paymentDAO.getMonthlyRevenue());
        dto.setRecentBookings(bookingDAO.findRecentBookings(8));
        return dto;
    }
}
