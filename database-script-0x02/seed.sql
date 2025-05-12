 -- Insert into User table
INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
VALUES 
    ('John', 'Doe', 'john.doe@example.com', 'hashed_password_1', '1234567890', 'guest' ),
    ( 'Jane', 'Smith', 'jane.smith@example.com', 'hashed_password_2', '0987654321', 'host' ),
    ( 'Admin', 'User', 'admin@example.com', 'hashed_password_3', 'admin');

-- Insert into Property table
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at)
VALUES 
 ('jane.smith@example.com', 'Beach House', 'A beautiful beach house with ocean views.', 'California', 300.00);

-- Insert into Booking table
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at)
VALUES 
     ('john.doe@example.com'), '2025-07-01', '2025-07-10', 3000.00, 'pending', '2025-06-01'),
