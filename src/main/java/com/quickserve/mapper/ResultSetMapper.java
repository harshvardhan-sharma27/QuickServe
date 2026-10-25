package com.quickserve.mapper;

import com.quickserve.pojo.*;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

public class ResultSetMapper {

    public static boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData rsmd = rs.getMetaData();
        int columns = rsmd.getColumnCount();
        for (int x = 1; x <= columns; x++) {
            if (columnName.equalsIgnoreCase(rsmd.getColumnLabel(x)) || columnName.equalsIgnoreCase(rsmd.getColumnName(x))) {
                return true;
            }
        }
        return false;
    }

    public static User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setPhone(rs.getString("phone"));
        u.setRole(rs.getString("role"));
        u.setStatus(rs.getString("status"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }

    public static ProviderProfile mapProviderProfile(ResultSet rs) throws SQLException {
        ProviderProfile p = new ProviderProfile();
        p.setProviderId(rs.getInt("provider_id"));
        p.setBusinessName(rs.getString("business_name"));
        p.setExperienceYears(rs.getInt("experience_years"));
        p.setDescription(rs.getString("description"));
        p.setVerificationStatus(rs.getString("verification_status"));
        p.setRating(rs.getDouble("rating"));

        if (hasColumn(rs, "full_name")) {
            User u = new User();
            u.setUserId(p.getProviderId());
            u.setFullName(rs.getString("full_name"));
            if (hasColumn(rs, "email")) u.setEmail(rs.getString("email"));
            if (hasColumn(rs, "phone")) u.setPhone(rs.getString("phone"));
            if (hasColumn(rs, "status")) u.setStatus(rs.getString("status"));
            p.setUser(u);
        }
        return p;
    }

    public static Category mapCategory(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setCategoryId(rs.getInt("category_id"));
        c.setCategoryName(rs.getString("category_name"));
        c.setDescription(rs.getString("description"));
        c.setIconClass(rs.getString("icon_class"));
        return c;
    }

    public static Service mapService(ResultSet rs) throws SQLException {
        Service s = new Service();
        s.setServiceId(rs.getInt("service_id"));
        s.setProviderId(rs.getInt("provider_id"));
        s.setCategoryId(rs.getInt("category_id"));
        s.setServiceName(rs.getString("service_name"));
        s.setDescription(rs.getString("description"));
        s.setPrice(rs.getBigDecimal("price"));
        s.setDurationMinutes(rs.getInt("duration_minutes"));
        s.setStatus(rs.getString("status"));
        s.setImageUrl(rs.getString("image_url"));

        if (hasColumn(rs, "category_name")) {
            s.setCategoryName(rs.getString("category_name"));
        }
        if (hasColumn(rs, "business_name")) {
            s.setProviderBusinessName(rs.getString("business_name"));
        }
        if (hasColumn(rs, "rating")) {
            s.setProviderRating(rs.getDouble("rating"));
        }
        return s;
    }

    public static Address mapAddress(ResultSet rs) throws SQLException {
        Address a = new Address();
        a.setAddressId(rs.getInt("address_id"));
        a.setUserId(rs.getInt("user_id"));
        a.setAddressLine(rs.getString("address_line"));
        a.setCity(rs.getString("city"));
        a.setState(rs.getString("state"));
        a.setPincode(rs.getString("pincode"));
        a.setDefault(rs.getBoolean("is_default"));
        return a;
    }

    public static ProviderAvailability mapAvailability(ResultSet rs) throws SQLException {
        ProviderAvailability a = new ProviderAvailability();
        a.setAvailabilityId(rs.getInt("availability_id"));
        a.setProviderId(rs.getInt("provider_id"));
        a.setAvailableDate(rs.getDate("available_date"));
        a.setStartTime(rs.getTime("start_time"));
        a.setEndTime(rs.getTime("end_time"));
        a.setStatus(rs.getString("status"));
        return a;
    }

    public static Booking mapBooking(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setBookingId(rs.getInt("booking_id"));
        b.setCustomerId(rs.getInt("customer_id"));
        b.setProviderId(rs.getInt("provider_id"));
        b.setAddressId(rs.getInt("address_id"));
        b.setBookingDate(rs.getDate("booking_date"));
        b.setBookingTime(rs.getTime("booking_time"));
        b.setTotalAmount(rs.getBigDecimal("total_amount"));
        b.setStatus(rs.getString("status"));
        b.setNotes(rs.getString("notes"));
        b.setCreatedAt(rs.getTimestamp("created_at"));

        if (hasColumn(rs, "customer_name")) b.setCustomerName(rs.getString("customer_name"));
        if (hasColumn(rs, "customer_email")) b.setCustomerEmail(rs.getString("customer_email"));
        if (hasColumn(rs, "customer_phone")) b.setCustomerPhone(rs.getString("customer_phone"));
        if (hasColumn(rs, "business_name")) b.setProviderBusinessName(rs.getString("business_name"));
        if (hasColumn(rs, "provider_phone")) b.setProviderPhone(rs.getString("provider_phone"));
        if (hasColumn(rs, "address_details")) b.setAddressDetails(rs.getString("address_details"));
        if (hasColumn(rs, "payment_status")) b.setPaymentStatus(rs.getString("payment_status"));
        if (hasColumn(rs, "payment_method")) b.setPaymentMethod(rs.getString("payment_method"));
        if (hasColumn(rs, "transaction_reference")) b.setTransactionReference(rs.getString("transaction_reference"));
        if (hasColumn(rs, "rating")) {
            int r = rs.getInt("rating");
            if (!rs.wasNull()) b.setRating(r);
        }
        if (hasColumn(rs, "review_comment")) b.setReviewComment(rs.getString("review_comment"));

        return b;
    }

    public static BookingItem mapBookingItem(ResultSet rs) throws SQLException {
        BookingItem item = new BookingItem();
        item.setBookingItemId(rs.getInt("booking_item_id"));
        item.setBookingId(rs.getInt("booking_id"));
        item.setServiceId(rs.getInt("service_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getBigDecimal("unit_price"));
        if (hasColumn(rs, "service_name")) {
            item.setServiceName(rs.getString("service_name"));
        }
        return item;
    }

    public static Payment mapPayment(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setPaymentId(rs.getInt("payment_id"));
        p.setBookingId(rs.getInt("booking_id"));
        p.setTransactionReference(rs.getString("transaction_reference"));
        p.setAmount(rs.getBigDecimal("amount"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setPaymentStatus(rs.getString("payment_status"));
        p.setPaidAt(rs.getTimestamp("paid_at"));
        return p;
    }

    public static Review mapReview(ResultSet rs) throws SQLException {
        Review r = new Review();
        r.setReviewId(rs.getInt("review_id"));
        r.setBookingId(rs.getInt("booking_id"));
        r.setCustomerId(rs.getInt("customer_id"));
        r.setProviderId(rs.getInt("provider_id"));
        r.setRating(rs.getInt("rating"));
        r.setComment(rs.getString("comment"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        if (hasColumn(rs, "customer_name")) r.setCustomerName(rs.getString("customer_name"));
        if (hasColumn(rs, "business_name")) r.setProviderBusinessName(rs.getString("business_name"));
        return r;
    }

    public static SupportTicket mapSupportTicket(ResultSet rs) throws SQLException {
        SupportTicket t = new SupportTicket();
        t.setTicketId(rs.getInt("ticket_id"));
        t.setUserId(rs.getInt("user_id"));
        int bId = rs.getInt("booking_id");
        if (!rs.wasNull()) t.setBookingId(bId);
        t.setSubject(rs.getString("subject"));
        t.setDescription(rs.getString("description"));
        t.setStatus(rs.getString("status"));
        t.setAdminResponse(rs.getString("admin_response"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        if (hasColumn(rs, "user_name")) t.setUserName(rs.getString("user_name"));
        if (hasColumn(rs, "user_email")) t.setUserEmail(rs.getString("user_email"));
        if (hasColumn(rs, "user_role")) t.setUserRole(rs.getString("user_role"));
        return t;
    }

    public static Notification mapNotification(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setNotificationId(rs.getInt("notification_id"));
        n.setUserId(rs.getInt("user_id"));
        n.setMessage(rs.getString("message"));
        n.setRead(rs.getBoolean("is_read"));
        n.setCreatedAt(rs.getTimestamp("created_at"));
        return n;
    }
}
