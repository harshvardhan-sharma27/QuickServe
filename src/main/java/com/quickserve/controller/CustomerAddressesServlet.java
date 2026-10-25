package com.quickserve.controller;

import com.quickserve.dao.AddressDAO;
import com.quickserve.dao.impl.AddressDAOImpl;
import com.quickserve.pojo.Address;
import com.quickserve.pojo.User;
import com.quickserve.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CustomerAddressesServlet", urlPatterns = {"/customer/addresses"})
public class CustomerAddressesServlet extends HttpServlet {

    private final AddressDAO addressDAO = new AddressDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if ("delete".equalsIgnoreCase(action) && idParam != null) {
            try {
                int addressId = Integer.parseInt(idParam);
                addressDAO.delete(addressId, user.getUserId());
                response.sendRedirect(request.getContextPath() + "/customer/addresses?msg=Address+deleted");
                return;
            } catch (Exception ignored) {}
        }

        if ("default".equalsIgnoreCase(action) && idParam != null) {
            try {
                int addressId = Integer.parseInt(idParam);
                addressDAO.setDefault(addressId, user.getUserId());
                response.sendRedirect(request.getContextPath() + "/customer/addresses?msg=Default+address+updated");
                return;
            } catch (Exception ignored) {}
        }

        List<Address> addresses = addressDAO.findByUser(user.getUserId());
        request.setAttribute("addresses", addresses);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("successMessage", msg);

        request.getRequestDispatcher("/WEB-INF/views/customer/addresses.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String line = request.getParameter("addressLine");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");
        boolean isDefault = request.getParameter("isDefault") != null;

        try {
            ValidationUtil.validateNotEmpty(line, "Address Line");
            ValidationUtil.validateNotEmpty(city, "City");
            ValidationUtil.validatePincode(pincode);

            Address a = new Address();
            a.setUserId(user.getUserId());
            a.setAddressLine(line.trim());
            a.setCity(city.trim());
            a.setState(state != null ? state.trim() : "");
            a.setPincode(pincode != null ? pincode.trim() : "");
            a.setDefault(isDefault);

            addressDAO.create(a);
            response.sendRedirect(request.getContextPath() + "/customer/addresses?msg=Address+saved+successfully");

        } catch (Exception e) {
            request.setAttribute("errorMessage", e.getMessage());
            doGet(request, response);
        }
    }
}
