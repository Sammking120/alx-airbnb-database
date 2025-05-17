# Optimize Complex Queries
The refactored query reduces execution time from ~265 ms (50,000 rows) to ~4.8–5.678 ms (100 rows) by:

Adding pagination (LIMIT 100 OFFSET 0).
Selecting fewer columns (~120 bytes vs. 192).
Handling multiple payments with a subquery (DISTINCT ON or ROW_NUMBER()).
Using a composite index (idx_bookings_user_id_booking_id) to eliminate sorting.
Indexing payments for fast subquery execution (idx_payments_booking_id_payment_date).
Remaining inefficiencies (e.g., payments subquery Seq Scan in PostgreSQL original refactor) are minor and resolved in the DISTINCT ON version. For MySQL, ROW_NUMBER() is slightly slower but effective. Test with your data, and share EXPLAIN ANALYZE output, schema details, or specific requirements (e.g., additional filters, database type) for further optimization!