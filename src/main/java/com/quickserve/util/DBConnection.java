package com.quickserve.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/quickserve_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASS = "Harsh@2005";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found in classpath!", e);
        }
    }

    private DBConnection() {}

    public static Connection getConnection() throws SQLException {
        String url = System.getenv("DB_URL");
        if (url == null || url.trim().isEmpty()) {
            url = DEFAULT_URL;
        }

        String user = System.getenv("DB_USERNAME");
        if (user == null || user.trim().isEmpty()) {
            user = DEFAULT_USER;
        }

        String pass = System.getenv("DB_PASSWORD");
        if (pass == null) {
            pass = DEFAULT_PASS;
        }

        return DriverManager.getConnection(url, user, pass);
    }

    public static void closeQuietly(AutoCloseable closeable) {
        if (closeable != null) {
            try {
                closeable.close();
            } catch (Exception ignored) {
            }
        }
    }
}
