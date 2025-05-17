--QUery 1
EXPLAIN ANALYZE
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
    SELECT DISTINCT ON (booking_id) booking_id, payment_id, payment_status
    FROM payments
    WHERE payment_status = 'completed'
    ORDER BY booking_id, payment_date DESC
) pay 
    ON b.booking_id = pay.booking_id
WHERE 
    b.check_in_date >= '2025-01-01' 
    AND b.check_in_date < '2026-01-01'
ORDER BY 
    b.booking_id ASC
LIMIT 100 OFFSET 0;


--SHOW PROFILE
SET profiling = 1;
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
    SELECT DISTINCT ON (booking_id) booking_id, payment_id, payment_status
    FROM payments
    WHERE payment_status = 'completed'
    ORDER BY booking_id, payment_date DESC
) pay 
    ON b.booking_id = pay.booking_id
WHERE 
    b.check_in_date >= '2025-01-01' 
    AND b.check_in_date < '2026-01-01'
ORDER BY 
    b.booking_id ASC
LIMIT 100 OFFSET 0;
SHOW PROFILE;
SET profiling = 0;

---Query 2
EXPLAIN ANALYZE
SELECT 
    p.property_id,
    p.title,
    p.location,
    COUNT(b.booking_id) AS booking_count
FROM 
    properties p
LEFT JOIN 
    bookings b 
    ON p.property_id = b.property_id
WHERE 
    b.check_in_date >= '2025-01-01' 
    AND b.check_in_date < '2026-01-01'
    OR b.check_in_date IS NULL
GROUP BY 
    p.property_id, p.title, p.location
ORDER BY 
    booking_count DESC
LIMIT 10;
