
-- Rename existing table
ALTER TABLE bookings RENAME TO bookings_old;

-- Create parent table
CREATE TABLE bookings (
    booking_id SERIAL,
    user_id INT,
    property_id INT,
    check_in_date DATE NOT NULL,
    check_out_date DATE,
    total_price DECIMAL(10,2)
) PARTITION BY RANGE (check_in_date);

-- Add primary key
ALTER TABLE bookings ADD PRIMARY KEY (booking_id);

-- Create partitions
CREATE TABLE bookings_2023 PARTITION OF bookings
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');
CREATE TABLE bookings_2024 PARTITION OF bookings
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');
CREATE TABLE bookings_2025 PARTITION OF bookings
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');
CREATE TABLE bookings_future PARTITION OF bookings
    FOR VALUES FROM ('2026-01-01') TO (UNBOUNDED);
CREATE TABLE bookings_default PARTITION OF bookings DEFAULT;

-- Migrate data
BEGIN;
INSERT INTO bookings
SELECT * FROM bookings_old;
-- Verify counts
SELECT COUNT(*) FROM bookings_old;
SELECT COUNT(*) FROM bookings;
DROP TABLE bookings_old;
COMMIT;

-- Create indexes on partitions
ALTER TABLE bookings_2023 ADD PRIMARY KEY (booking_id);
CREATE INDEX idx_bookings_2023_user_id ON bookings_2023 (user_id);
CREATE INDEX idx_bookings_2023_property_id ON bookings_2023 (property_id);
CREATE INDEX idx_bookings_2023_check_in_date ON bookings_2023 (check_in_date);
CREATE INDEX idx_bookings_2023_user_id_booking_id ON bookings_2023 (user_id, booking_id);

ALTER TABLE bookings_2024 ADD PRIMARY KEY (booking_id);
CREATE INDEX idx_bookings_2024_user_id ON bookings_2024 (user_id);
CREATE INDEX idx_bookings_2024_property_id ON bookings_2024 (property_id);
CREATE INDEX idx_bookings_2024_check_in_date ON bookings_2024 (check_in_date);
CREATE INDEX idx_bookings_2024_user_id_booking_id ON bookings_2024 (user_id, booking_id);

ALTER TABLE bookings_2025 ADD PRIMARY KEY (booking_id);
CREATE INDEX idx_bookings_2025_user_id ON bookings_2025 (user_id);
CREATE INDEX idx_bookings_2025_property_id ON bookings_2025 (property_id);
CREATE INDEX idx_bookings_2025_check_in_date ON bookings_2025 (check_in_date);
CREATE INDEX idx_bookings_2025_user_id_booking_id ON bookings_2025 (user_id, booking_id);

ALTER TABLE bookings_future ADD PRIMARY KEY (booking_id);
CREATE INDEX idx_bookings_future_user_id ON bookings_future (user_id);
CREATE INDEX idx_bookings_future_property_id ON bookings_future (property_id);
CREATE INDEX idx_bookings_future_check_in_date ON bookings_future (check_in_date);
CREATE INDEX idx_bookings_future_user_id_booking_id ON bookings_future (user_id, booking_id);

ALTER TABLE bookings_default ADD PRIMARY KEY (booking_id);
CREATE INDEX idx_bookings_default_user_id ON bookings_default (user_id);
CREATE INDEX idx_bookings_default_property_id ON bookings_default (property_id);
CREATE INDEX idx_bookings_default_check_in_date ON bookings_default (check_in_date);
CREATE INDEX idx_bookings_default_user_id_booking_id ON bookings_default (user_id, booking_id);

-- Trigger for user_id integrity
CREATE OR REPLACE FUNCTION check_user_id()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = NEW.user_id) THEN
        RAISE EXCEPTION 'Invalid user_id: %', NEW.user_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_bookings_user_id
    BEFORE INSERT OR UPDATE ON bookings
    FOR EACH ROW EXECUTE FUNCTION check_user_id();
