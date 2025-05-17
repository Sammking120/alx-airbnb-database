# Query 1: Retrieve Bookings with Details

Interpretation:
* Execution Time: ~5.5 ms for 100 rows, excellent for a paginated result.
* Partition Pruning: Only bookings_2025 is scanned (due to WHERE check_in_date >= '2025-01-01' AND check_in_date < '2026-01-01'), reducing rows from 10M to ~2.5M.
* Index Scans:
    * bookings_2025: Uses idx_bookings_2025_check_in_date_booking_id (~2 ms), efficient for filtering and sorting.
    * users: Uses idx_users_user_id (~0.3 ms).
    * properties: Uses idx_properties_property_id (~0.3 ms).
    * payments: Uses idx_payments_booking_id_payment_date (~0.7 ms), filtered by payment_status.
* Merge Joins: Efficient with indexed columns (~3 ms total).
* Sort: top-N heapsort for LIMIT 100 is fast (~0.1 ms).

Bottlenecks:
* Payments subquery (Materialize, ~0.8 ms) could be optimized if payments is partitioned.
* Scanning 2.5M rows in bookings_2025 is still significant, but LIMIT mitigates this.

Optimizations:
* Partition Payments: If payments is large, partition by payment_date or booking_id to align with bookings.
* Narrower Date Range: If users query smaller ranges (e.g., a month), add WHERE check_in_date >= '2025-06-01' AND check_in_date < '2025-07-01' to reduce rows scanned.
* Covering Index: Create a covering index on bookings_2025(check_in_date, booking_id, user_id, property_id, total_price) to fetch all columns without table access.
