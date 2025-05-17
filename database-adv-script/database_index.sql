--1 users Table
-- Index for user_id (primary key, likely already indexed)
CREATE INDEX idx_users_user_id ON users (user_id);

--2 bookings Table
-- Index for booking_id (primary key, likely already indexed)
CREATE INDEX idx_bookings_booking_id ON bookings (booking_id);

-- Index for user_id (foreign key, used in JOINs and WHERE)
CREATE INDEX idx_bookings_user_id ON bookings (user_id);

-- Index for property_id (foreign key, used in JOINs and WHERE)
CREATE INDEX idx_bookings_property_id ON bookings (property_id);

-- Index for check_in_date (used in WHERE for date filtering)
CREATE INDEX idx_bookings_check_in_date ON bookings (check_in_date);

-- Index for check_out_date (used in WHERE for date filtering)
CREATE INDEX idx_bookings_check_out_date ON bookings (check_out_date);

-- Composite index for availability queries (property_id + check_in_date)
CREATE INDEX idx_bookings_property_check_in ON bookings (property_id, check_in_date);


-- 3. properties Table
-- Index for property_id (primary key, likely already indexed)
CREATE INDEX idx_properties_property_id ON properties (property_id);

-- Index for location (used in WHERE for geographic searches)
CREATE INDEX idx_properties_location ON properties (location);

--4. reviews Table
-- Index for review_id (primary key, likely already indexed)
CREATE INDEX idx_reviews_review_id ON reviews (review_id);

-- Index for property_id (foreign key, used in JOINs and GROUP BY)
CREATE INDEX idx_reviews_property_id ON reviews (property_id);

-- Index for rating (used in WHERE and potentially ORDER BY)
CREATE INDEX idx_reviews_rating ON reviews (rating);

-- Index for review_date (used in WHERE for temporal filtering)
CREATE INDEX idx_reviews_review_date ON reviews (review_date);