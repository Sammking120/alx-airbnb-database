SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.title,
    p.location,
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_status
FROM 
    bookings b
INNER JOIN 
    users u 
    ON b.user_id = u.user_id
INNER JOIN 
    properties p 
    ON b.property_id = p.property_id
INNER JOIN 
    payments pay 
    ON b.booking_id = pay.booking_id
ORDER BY 
    b.booking_id ASC;

LEFT JOIN payments pay ON b.booking_id = pay.booking_id

CREATE INDEX idx_payments_booking_id ON payments (booking_id);

---To analyze the query plan, run:
EXPLAIN
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.title,
    p.location,
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_status
FROM 
    bookings b
INNER JOIN 
    users u 
    ON b.user_id = u.user_id
INNER JOIN 
    properties p 
    ON b.property_id = p.property_id
INNER JOIN 
    payments pay 
    ON b.booking_id = pay.booking_id
ORDER BY 
    b.booking_id ASC;


EXPLAIN ANALYZE
SELECT
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.title,
    p.location,
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_status
FROM 
    bookings b
INNER JOIN 
    users u 
    ON b.user_id = u.user_id
INNER JOIN 
    properties p 
    ON b.property_id = p.property_id
INNER JOIN 
    payments pay 
    ON b.booking_id = pay.booking_id
ORDER BY 
    b.booking_id ASC;

-- Drop index to simulate
DROP INDEX IF EXISTS idx_payments_booking_id;

EXPLAIN
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.title,
    p.location,
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_status
FROM 
    bookings b
INNER JOIN 
    users u 
    ON b.user_id = u.user_id
INNER JOIN 
    properties p 
    ON b.property_id = p.property_id
INNER JOIN 
    payments pay 
    ON b.booking_id = pay.booking_id
ORDER BY 
    b.booking_id ASC;

CREATE INDEX idx_bookings_user_id_booking_id ON bookings (user_id, booking_id)
ORDER BY b.booking_id ASC LIMIT 100 OFFSET 0;

INNER JOIN (
    SELECT booking_id, MAX(payment_id) AS payment_id
    FROM payments
    GROUP BY booking_id
) latest_pay ON b.booking_id = latest_pay.booking_id
INNER JOIN payments pay ON latest_pay.payment_id = pay.payment_id


CREATE INDEX idx_bookings_user_id ON bookings (user_id);
CREATE INDEX idx_bookings_property_id ON bookings (property_id);
CREATE INDEX idx_payments_booking_id ON payments (booking_id);

SELECT * FROM pg_indexes WHERE tablename IN ('bookings', 'payments', 'users', 'properties');

SET enable_mergejoin = OFF;
EXPLAIN ANALYZE SELECT
b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.title,
    p.location,
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_status
FROM 
    bookings b
INNER JOIN 
    users u 
    ON b.user_id = u.user_id
INNER JOIN 
    properties p 
    ON b.property_id = p.property_id
INNER JOIN 
    payments pay 
    ON b.booking_id = pay.booking_id
ORDER BY 
    b.booking_id ASC;

-- To refactor the query retrieving all bookings along with user details, property details, and payment details in an Airbnb-like system, we aim to reduce execution time by addressing inefficiencies identified in the previous EXPLAIN analysis. The original query is:
SELECT 
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.total_price,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.title,
    p.location,
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_status
FROM 
    bookings b
INNER JOIN 
    users u 
    ON b.user_id = u.user_id
INNER JOIN 
    properties p 
    ON b.property_id = p.property_id
INNER JOIN 
    payments pay 
    ON b.booking_id = pay.booking_id
ORDER BY 
    b.booking_id ASC;

-- Refactored Query
-- Here’s the refactored query, incorporating pagination, selective columns, and handling for multiple payments:
SELECT 
    b.booking_id,
    b.check_in_date,
    b.total_price,
    u.first_name,
    u.last_name,
    p.title,
    p.location,
    pay.payment_id,
    pay.payment_status
FROM 
    bookings b
INNER JOIN 
    users u 
    ON b.user_id = u.user_id
INNER JOIN 
    properties p 
    ON b.property_id = p.property_id
INNER JOIN (
    SELECT 
        booking_id, 
        payment_id,
        payment_status
    FROM 
        payments
    WHERE 
        payment_id = (
            SELECT payment_id 
            FROM payments p2 
            WHERE p2.booking_id = payments.booking_id 
            ORDER BY payment_date DESC 
            LIMIT 1
        )
) pay 
    ON b.booking_id = pay.booking_id
ORDER BY 
    b.booking_id ASC
LIMIT 100 OFFSET 0;

-- Handle Multiple Payments:
-- Replaced direct payments join with a subquery to select the latest payment per booking:
INNER JOIN (
    SELECT booking_id, payment_id, payment_status
    FROM payments
    WHERE payment_id = (
        SELECT payment_id 
        FROM payments p2 
        WHERE p2.booking_id = payments.booking_id 
        ORDER BY payment_date DESC 
        LIMIT 1
    )
) pay ON b.booking_id = pay.booking_id


--Indexing:
--Ensure existing indexes:
CREATE INDEX idx_bookings_user_id ON bookings (user_id);
CREATE INDEX idx_bookings_property_id ON bookings (property_id);
CREATE INDEX idx_payments_booking_id ON payments (booking_id);

--Add composite index to reduce sorting:
CREATE INDEX idx_bookings_user_id_booking_id ON bookings (user_id, booking_id);

--Add index for payment subquery:
CREATE INDEX idx_payments_booking_id_payment_date ON payments (booking_id, payment_date DESC);


--EXPLAIN Analysis of Refactored Query
--Run EXPLAIN ANALYZE to verify improvements:
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.check,, b.check_in_date,
    b.total_price,
    u.first_name,
    u.last_name,
    p.title,
    p.location,
    pay.payment_id,
    pay.payment_status
FROM 
    bookings b
INNER JOIN 
    users u 
    ON b.user_id = u.user_id
INNER JOIN 
    properties p 
    ON b.property_id = p.property_id
INNER JOIN (
    SELECT 
        booking_id, 
        payment_id,
        payment_status
    FROM 
        payments
    WHERE 
        payment_id = (
            SELECT payment_id 
            FROM payments p2 
            WHERE p2.booking_id = payments.booking_id 
            ORDER BY payment_date DESC 
            LIMIT 1
        )
) pay 
    ON b.booking_id = pay.booking_id
ORDER BY 
    b.booking_id ASC
LIMIT 100 OFFSET 0;

--Fix: Rewrite subquery to use a correlated subquery or window function for better index usage:
INNER JOIN (
    SELECT DISTINCT ON (booking_id) booking_id, payment_id, payment_status
    FROM payments
    ORDER BY booking_id, payment_date DESC
) pay ON b.booking_id = pay.booking_id


-- Alternative Query (PostgreSQL-Specific, Using DISTINCT ON)
SELECT 
    b.booking_id,
    b.check_in_date,
    b.total_price,
    u.first_name,
    u.last_name,
    p.title,
    p.location,
    pay.payment_id,
    pay.payment_status
FROM 
    bookings b
INNER JOIN 
    users u 
    ON b.user_id = u.user_id
INNER JOIN 
    properties p 
    ON b.property_id = p.property_id
INNER JOIN (
    SELECT DISTINCT ON (booking_id) booking_id, payment_id, payment_status
    FROM payments
    ORDER BY booking_id, payment_date DESC
) pay 
    ON b.booking_id = pay.booking_id
ORDER BY 
    b.booking_id ASC
LIMIT 100 OFFSET 0;

--MySQL Alternative (Using ROW_NUMBER)
---MySQL lacks DISTINCT ON. Use a window function:
SELECT 
    b.booking_id,
    b.check_in_date,
    b.total_price,
    u.first_name,
    u.last_name,
    p.title,
    p.location,
    pay.payment_id,
    pay.payment_status
FROM 
    bookings b
INNER JOIN 
    users u 
    ON b.user_id = u.user_id
INNER JOIN 
    properties p 
    ON b.property_id = p.property_id
LEFT JOIN (
    SELECT booking_id, payment_id, payment_status
    FROM (
        SELECT 
            booking_id,
            payment_id,
            payment_status,
            ROW_NUMBER() OVER (PARTITION BY booking_id ORDER BY payment_date DESC) AS rn
        FROM payments
        WHERE payment_status = 'completed'  -- Filter in subquery
    ) ranked
    WHERE rn = 1
) pay 
    ON b.booking_id = pay.booking_id
WHERE 
    b.check_in_date >= '2025-01-01' 
    AND b.check_in_date < '2026-01-01'
ORDER BY 
    b.booking_id ASC
LIMIT 100 OFFSET 0;
-- Ensure these indexes exist:
CREATE INDEX idx_bookings_user_id_booking_id ON bookings (user_id, booking_id);
CREATE INDEX idx_bookings_property_id ON bookings (property_id);
CREATE INDEX idx_payments_booking_id_payment_date ON payments (booking_id, payment_date DESC);
-- Existing primary key indexes assumed: users.user_id, properties.property_id, bookings.booking_id, payments.payment_id
