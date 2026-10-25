-- QuickServe Database Schema & Seed Data
-- MySQL 8.0+

CREATE DATABASE IF NOT EXISTS quickserve_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE quickserve_db;

-- Drop in reverse foreign key order if re-running
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS support_tickets;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS booking_items;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS provider_availability;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS provider_profiles;
DROP TABLE IF EXISTS users;

-- 1. users
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    role ENUM('CUSTOMER', 'PROVIDER', 'ADMIN') DEFAULT 'CUSTOMER',
    status ENUM('ACTIVE', 'BLOCKED', 'PENDING') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. provider_profiles (1-to-1 with users)
CREATE TABLE provider_profiles (
    provider_id INT PRIMARY KEY,
    business_name VARCHAR(150) NOT NULL,
    experience_years INT DEFAULT 0,
    description TEXT,
    verification_status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    rating DECIMAL(3,2) DEFAULT 0.00,
    FOREIGN KEY (provider_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 3. categories
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) UNIQUE NOT NULL,
    description VARCHAR(255),
    icon_class VARCHAR(50) DEFAULT 'bi-gear'
) ENGINE=InnoDB;

-- 4. services
CREATE TABLE services (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    provider_id INT NOT NULL,
    category_id INT NOT NULL,
    service_name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    duration_minutes INT NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    image_url VARCHAR(255) DEFAULT NULL,
    FOREIGN KEY (provider_id) REFERENCES provider_profiles(provider_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. addresses (1 customer to many addresses)
CREATE TABLE addresses (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    address_line VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    pincode VARCHAR(10),
    is_default BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 6. provider_availability
CREATE TABLE provider_availability (
    availability_id INT PRIMARY KEY AUTO_INCREMENT,
    provider_id INT NOT NULL,
    available_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status ENUM('AVAILABLE', 'BOOKED', 'BLOCKED') DEFAULT 'AVAILABLE',
    FOREIGN KEY (provider_id) REFERENCES provider_profiles(provider_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 7. bookings
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    provider_id INT NOT NULL,
    address_id INT NOT NULL,
    booking_date DATE NOT NULL,
    booking_time TIME NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    notes VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(user_id),
    FOREIGN KEY (provider_id) REFERENCES provider_profiles(provider_id),
    FOREIGN KEY (address_id) REFERENCES addresses(address_id)
) ENGINE=InnoDB;

-- 8. booking_items (1 booking to many services)
CREATE TABLE booking_items (
    booking_item_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(service_id)
) ENGINE=InnoDB;

-- 9. payments (1-to-1 with booking)
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL UNIQUE,
    transaction_reference VARCHAR(100) UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('UPI', 'CARD', 'CASH') DEFAULT 'UPI',
    payment_status ENUM('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED') DEFAULT 'PENDING',
    paid_at TIMESTAMP NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 10. reviews (1-to-1 with booking)
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    provider_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES users(user_id),
    FOREIGN KEY (provider_id) REFERENCES provider_profiles(provider_id)
) ENGINE=InnoDB;

-- 11. support_tickets
CREATE TABLE support_tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    booking_id INT NULL,
    subject VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    status ENUM('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED') DEFAULT 'OPEN',
    admin_response TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 12. notifications
CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    message VARCHAR(500) NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Indexes for performance & query optimization
CREATE INDEX idx_booking_customer ON bookings(customer_id);
CREATE INDEX idx_booking_provider ON bookings(provider_id);
CREATE INDEX idx_booking_date ON bookings(booking_date);
CREATE INDEX idx_booking_status ON bookings(status);
CREATE INDEX idx_service_category ON services(category_id);
CREATE INDEX idx_service_provider ON services(provider_id);
CREATE INDEX idx_payment_status ON payments(payment_status);
CREATE INDEX idx_availability_lookup ON provider_availability(provider_id, available_date, status);
CREATE INDEX idx_notification_user ON notifications(user_id, is_read);

-- ==========================================
-- SEED DATA
-- Default Passwords:
-- Admin: Admin@123 -> $2a$10$Iz.BxYA8cTAYbcpQFqXTPuY52zL6sswUn24uVGLf2XGVNQwb5sQzW
-- Others: Password@123 -> $2a$10$zKgE/Bxn.kVbhHbIYobQbOtSjiJcqSgKMaqxX/56p4F86N4YdkPvO
-- ==========================================

-- 1. Insert Users
INSERT INTO users (user_id, full_name, email, password_hash, phone, role, status) VALUES
(1, 'QuickServe Admin', 'admin@quickserve.com', '$2a$10$Iz.BxYA8cTAYbcpQFqXTPuY52zL6sswUn24uVGLf2XGVNQwb5sQzW', '9890011223', 'ADMIN', 'ACTIVE'),
(2, 'Rahul Sharma', 'rahul.electric@quickserve.com', '$2a$10$zKgE/Bxn.kVbhHbIYobQbOtSjiJcqSgKMaqxX/56p4F86N4YdkPvO', '9876543210', 'PROVIDER', 'ACTIVE'),
(3, 'Priya Mukherjee', 'priya.clean@quickserve.com', '$2a$10$zKgE/Bxn.kVbhHbIYobQbOtSjiJcqSgKMaqxX/56p4F86N4YdkPvO', '9876543211', 'PROVIDER', 'ACTIVE'),
(4, 'Amit Patel', 'amit.plumbing@quickserve.com', '$2a$10$zKgE/Bxn.kVbhHbIYobQbOtSjiJcqSgKMaqxX/56p4F86N4YdkPvO', '9876543212', 'PROVIDER', 'ACTIVE'),
(5, 'Vikram Singh', 'vikram.ac@quickserve.com', '$2a$10$zKgE/Bxn.kVbhHbIYobQbOtSjiJcqSgKMaqxX/56p4F86N4YdkPvO', '9876543213', 'PROVIDER', 'ACTIVE'),
(6, 'Suresh Yadav', 'suresh.carpentry@quickserve.com', '$2a$10$zKgE/Bxn.kVbhHbIYobQbOtSjiJcqSgKMaqxX/56p4F86N4YdkPvO', '9876543214', 'PROVIDER', 'ACTIVE'),
(7, 'Harshvardhan Patil', 'harsh@quickserve.com', '$2a$10$zKgE/Bxn.kVbhHbIYobQbOtSjiJcqSgKMaqxX/56p4F86N4YdkPvO', '9123456780', 'CUSTOMER', 'ACTIVE'),
(8, 'Sneha Kulkarni', 'sneha@quickserve.com', '$2a$10$zKgE/Bxn.kVbhHbIYobQbOtSjiJcqSgKMaqxX/56p4F86N4YdkPvO', '9123456781', 'CUSTOMER', 'ACTIVE'),
(9, 'Rohit Deshmukh', 'rohit@quickserve.com', '$2a$10$zKgE/Bxn.kVbhHbIYobQbOtSjiJcqSgKMaqxX/56p4F86N4YdkPvO', '9123456782', 'CUSTOMER', 'ACTIVE');

-- 2. Insert Provider Profiles
INSERT INTO provider_profiles (provider_id, business_name, experience_years, description, verification_status, rating) VALUES
(2, 'Sparkline Electricals', 7, 'Certified master electrician specialized in residential safety wiring, inverter backups, fault diagnosis, and modern lighting systems.', 'APPROVED', 4.85),
(3, 'Priya Deep Clean Solutions', 5, 'Mechanized home deep cleaning, non-toxic chemical sanitization, high-pressure kitchen degreasing, and sofa shampooing.', 'APPROVED', 4.90),
(4, 'FlowMaster Plumbing Services', 8, 'Expert in residential plumbing repairs, leak detection, pipeline re-routing, pressure pumps, and sanitary ware installation.', 'APPROVED', 4.70),
(5, 'CoolAir & Appliance Care', 6, 'HVAC certified technicians offering power jet AC servicing, precision refrigerant top-up, compressor repairs, and refrigerator tune-ups.', 'APPROVED', 4.80),
(6, 'CraftWood Carpentry', 10, 'Custom furniture repairs, modular kitchen latch fittings, wood polishing, and lock replacements with high precision.', 'APPROVED', 4.65);

-- 3. Insert Categories
INSERT INTO categories (category_id, category_name, description, icon_class) VALUES
(1, 'Cleaning', 'Deep home cleaning, kitchen sanitization, bathroom scrubbing, and sofa care.', 'bi-stars'),
(2, 'Electrical', 'Wiring, fan installation, switchboard repair, MCB replacement, and lighting.', 'bi-lightning-charge'),
(3, 'Plumbing', 'Leak repairs, tap fittings, blockages, drain unblocking, and water tank setup.', 'bi-droplet'),
(4, 'AC & Appliances', 'AC servicing, gas charging, refrigerator, washing machine, and microwave repairs.', 'bi-snow'),
(5, 'Carpentry', 'Door locks, furniture assembly, hinge fixes, wardrobe and cabinet carpentry.', 'bi-hammer'),
(6, 'Painting', 'Interior wall painting, texture finish, waterproof coating, and touch-ups.', 'bi-brush'),
(7, 'Pest Control', 'Eco-friendly cockroach, termite, bed bug, and rodent pest management.', 'bi-shield-check'),
(8, 'Computer & Gadgets', 'PC repair, laptop servicing, OS setup, network configuration, and virus removal.', 'bi-laptop');

-- 4. Insert Services
INSERT INTO services (service_id, provider_id, category_id, service_name, description, price, duration_minutes, status, image_url) VALUES
(1, 2, 2, 'Fan & Light Fixture Installation', 'Professional installation of ceiling fans, chandeliers, and decorative LED fixtures with safe earthing verification.', 399.00, 45, 'ACTIVE', 'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?auto=format&fit=crop&w=600&q=80'),
(2, 2, 2, 'Main MCB & Short Circuit Diagnostic', 'Complete circuit diagnosis, tripping issue resolution, and replacement of burnt MCBs or fuses.', 699.00, 60, 'ACTIVE', 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=600&q=80'),
(3, 2, 2, 'Complete House Electrical Safety Audit', 'Thorough earthing test, circuit load check, voltage surge inspection, and advisory report.', 1199.00, 90, 'ACTIVE', 'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?auto=format&fit=crop&w=600&q=80'),

(4, 3, 1, '2BHK Mechanized Full Home Deep Cleaning', 'Complete dust extraction, floor scrubbing, glass polishing, balcony wash, and cobweb removal.', 2499.00, 180, 'ACTIVE', 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?auto=format&fit=crop&w=600&q=80'),
(5, 3, 1, 'Intense Kitchen Degreasing & Sanitization', 'High-heat steam cleaning of kitchen tiles, oil stains removal from exhaust/cabinets, and sink disinfection.', 1299.00, 90, 'ACTIVE', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=600&q=80'),
(6, 3, 1, 'Deluxe Bathroom Anti-Scale Scrubbing', 'Tile scaling removal, tap descaling, floor and commode deep sanitization for sparkling finish.', 799.00, 60, 'ACTIVE', 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=600&q=80'),

(7, 4, 3, 'Basin & Sink Drain Pipe Leak Repair', 'Fixing leaking bottle traps, water pipe replacements, and sink sealant waterproofing.', 349.00, 40, 'ACTIVE', 'https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&w=600&q=80'),
(8, 4, 3, 'High Pressure Drain & Sewer Line Clearing', 'Clearing severe blockages in main drainage pipes using mechanical snake augers.', 649.00, 50, 'ACTIVE', 'https://images.unsplash.com/photo-1585704032915-c3400ca199e7?auto=format&fit=crop&w=600&q=80'),
(9, 4, 3, 'Overhead Water Tank Sanitization & Inspection', 'Draining, mechanical scrubbing, UV disinfection, and float valve inspection of tanks up to 1000L.', 1299.00, 120, 'ACTIVE', 'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?auto=format&fit=crop&w=600&q=80'),

(10, 5, 4, 'Split AC Power Jet Foam Wash', 'Intensive indoor coil foam jet cleaning, outdoor unit water pressure wash, filter hygiene, and cooling check.', 649.00, 60, 'ACTIVE', 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=600&q=80'),
(11, 5, 4, 'AC Gas Refill & Leak Testing', 'Precision nitrogen leak test, vacuuming, and complete R32/R410A eco-refrigerant recharge.', 1899.00, 90, 'ACTIVE', 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=600&q=80'),
(12, 5, 4, 'Frost-Free Refrigerator Diagnostic & Repair', 'Checking thermostat, PCB defrost timer, relay, compressor health, and door gasket sealing.', 849.00, 60, 'ACTIVE', 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5?auto=format&fit=crop&w=600&q=80'),

(13, 6, 5, 'Door Lock & Digital Latch Installation', 'Mortise lock, smart lock, or magnetic latch installation on wooden main doors with precise chiseling.', 499.00, 45, 'ACTIVE', 'https://images.unsplash.com/photo-1558002038-1055907df827?auto=format&fit=crop&w=600&q=80'),
(14, 6, 5, 'Bed & Wardrobe Assembly & Hinge Alignment', 'Flatpack furniture assembly, soft-close hydraulic hinge fixes, and sliding channel lubrication.', 749.00, 75, 'ACTIVE', 'https://images.unsplash.com/photo-1538688525198-9b88f6f53126?auto=format&fit=crop&w=600&q=80');

-- 5. Insert Addresses
INSERT INTO addresses (address_id, user_id, address_line, city, state, pincode, is_default) VALUES
(1, 7, 'Flat 402, Green Meadows, Senapati Bapat Road', 'Pune', 'Maharashtra', '411016', TRUE),
(2, 7, 'Tower 3, Office 602, Cybercity, Magarpatta', 'Pune', 'Maharashtra', '411028', FALSE),
(3, 8, 'B-301, Silver Crest Heights, Baner Road', 'Pune', 'Maharashtra', '411045', TRUE),
(4, 9, 'Flat 104, Sunrise Residency, Paud Road, Kothrud', 'Pune', 'Maharashtra', '411038', TRUE);

-- 6. Insert Provider Availability Slots (Current & Upcoming dates)
INSERT INTO provider_availability (provider_id, available_date, start_time, end_time, status) VALUES
(2, CURDATE(), '09:00:00', '12:00:00', 'BOOKED'),
(2, CURDATE(), '13:00:00', '16:00:00', 'AVAILABLE'),
(2, CURDATE(), '17:00:00', '20:00:00', 'AVAILABLE'),
(2, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00:00', '12:00:00', 'AVAILABLE'),
(2, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '14:00:00', '17:00:00', 'AVAILABLE'),

(3, CURDATE(), '09:00:00', '13:00:00', 'BOOKED'),
(3, CURDATE(), '14:00:00', '18:00:00', 'AVAILABLE'),
(3, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00:00', '13:00:00', 'AVAILABLE'),
(3, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '10:00:00', '14:00:00', 'AVAILABLE'),

(4, CURDATE(), '10:00:00', '13:00:00', 'AVAILABLE'),
(4, CURDATE(), '15:00:00', '18:00:00', 'AVAILABLE'),
(4, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00:00', '12:00:00', 'AVAILABLE'),

(5, CURDATE(), '09:00:00', '12:00:00', 'BOOKED'),
(5, CURDATE(), '14:00:00', '17:00:00', 'AVAILABLE'),
(5, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '10:00:00', '13:00:00', 'AVAILABLE'),

(6, CURDATE(), '10:00:00', '13:00:00', 'AVAILABLE'),
(6, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '11:00:00', '14:00:00', 'AVAILABLE');

-- 7. Insert Bookings
INSERT INTO bookings (booking_id, customer_id, provider_id, address_id, booking_date, booking_time, total_amount, status, notes, created_at) VALUES
(1, 7, 3, 1, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '10:00:00', 2499.00, 'COMPLETED', 'Please bring shoe covers and eco-friendly cleaning liquid.', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(2, 8, 5, 3, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '11:00:00', 649.00, 'COMPLETED', 'Split AC in master bedroom cooling is weak.', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, 9, 2, 4, CURDATE(), '10:00:00', 1098.00, 'CONFIRMED', 'Ceiling fan making clicking sound, plus check living room socket.', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(4, 7, 4, 1, CURDATE(), '15:00:00', 349.00, 'IN_PROGRESS', 'Water dripping under kitchen sink trap.', NOW()),
(5, 8, 3, 3, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '10:00:00', 799.00, 'PENDING', 'Master bathroom anti-scale scrub needed.', NOW());

-- 8. Insert Booking Items
INSERT INTO booking_items (booking_item_id, booking_id, service_id, quantity, unit_price) VALUES
(1, 1, 4, 1, 2499.00),
(2, 2, 10, 1, 649.00),
(3, 3, 1, 1, 399.00),
(4, 3, 2, 1, 699.00),
(5, 4, 7, 1, 349.00),
(6, 5, 6, 1, 799.00);

-- 9. Insert Payments
INSERT INTO payments (payment_id, booking_id, transaction_reference, amount, payment_method, payment_status, paid_at) VALUES
(1, 1, 'TXN_QS_8849201', 2499.00, 'UPI', 'SUCCESS', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(2, 2, 'TXN_QS_8849202', 649.00, 'CARD', 'SUCCESS', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, 3, 'TXN_QS_8849203', 1098.00, 'UPI', 'SUCCESS', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(4, 4, 'TXN_QS_8849204', 349.00, 'CASH', 'PENDING', NULL),
(5, 5, 'TXN_QS_8849205', 799.00, 'UPI', 'PENDING', NULL);

-- 10. Insert Reviews
INSERT INTO reviews (review_id, booking_id, customer_id, provider_id, rating, comment, created_at) VALUES
(1, 1, 7, 3, 5, 'Outstanding deep cleaning! The team arrived right on time with mechanized scrubbing machines. My 2BHK looks brand new.', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(2, 2, 8, 5, 5, 'Vikram was very polite and skilled. The power jet foam wash cleared all clogged dust from the AC coils. Cooling is super fast now!', DATE_SUB(NOW(), INTERVAL 1 DAY));

-- 11. Insert Support Tickets
INSERT INTO support_tickets (ticket_id, user_id, booking_id, subject, description, status, admin_response, created_at) VALUES
(1, 7, 1, 'Request for GST Tax Invoice', 'Hi Support, could you please provide a GST tax invoice copy for Booking #1?', 'RESOLVED', 'Hello Harshvardhan, the GST invoice PDF has been sent to your registered email address. Thank you!', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(2, 8, 5, 'Can I reschedule my appointment by 1 hour?', 'I have a meeting scheduled at 10 AM tomorrow, can we shift to 11 AM?', 'OPEN', NULL, NOW());

-- 12. Insert Notifications
INSERT INTO notifications (notification_id, user_id, message, is_read, created_at) VALUES
(1, 7, 'Welcome to QuickServe! Browse top-rated home services in your neighborhood.', TRUE, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(2, 7, 'Booking #1 has been completed successfully. How was your experience? Leave a review!', TRUE, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(3, 8, 'Booking #2 confirmed by CoolAir & Appliance Care.', TRUE, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(4, 9, 'Booking #3 is confirmed for today at 10:00 AM with Sparkline Electricals.', FALSE, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(5, 2, 'New booking received: #3 from Rohit Deshmukh for Fan & Light Fixture.', FALSE, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(6, 3, 'You have a new booking request #5 from Sneha Kulkarni.', FALSE, NOW());
