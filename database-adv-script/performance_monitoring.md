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

# Query 2: Count Bookings per Property
Interpretation:

* Execution Time: ~50.5 ms for 10 rows, reasonable for analytics but slower than Query 1 due to aggregation.
* Partition Pruning: Scans only bookings_2025 (~8 ms), efficient.
* Index Scan: Uses idx_bookings_2025_check_in_date (~8 ms), but scans 2.5M rows.
* Hash Join: Joins properties (~5,000 rows) with bookings (~2.5M rows, ~35 ms).
* HashAggregate: Groups by property_id, title, location (~5 ms).
* Sort: top-N heapsort for LIMIT 10 (~0.1 ms).

* Bottlenecks:
    * Scanning 2.5M rows for aggregation is costly.
    * OR check_in_date IS NULL may prevent full pruning (rows in bookings_default).
Optimizations:

* Remove OR Clause: If check_in_date is always non-NULL (enforced by schema), remove OR check_in_date IS NULL to ensure pruning.
* Index on property_id: Ensure idx_bookings_2025_property_id is used for the join.
* Materialized View: For frequent analytics, create a materialized view:

# Query 3: Bookings by User
Interpretation:

    * Execution Time: ~0.25 ms for 10 rows, very fast.
    * No Partition Pruning: Scans all partitions (bookings_2023, 2024, 2025, future) because WHERE user_id = 101 doesn’t constrain check_in_date.
    * Index Scans: Uses idx_bookings_202X_user_id (~0.03 ms per partition), highly efficient due to selective user_id (~100 rows total).
    * Nested Loop: Joins bookings with properties (~0.001 ms per row).
    * Sort: Fast for 100 rows (~0.1 ms).
    * Bottleneck: Scanning all partitions is unnecessary if the user’s bookings are recent.
Optimizations:

* Add Date Filter: If users typically view recent bookings, add WHERE check_in_date >= '2024-01-01' to prune older partitions:
