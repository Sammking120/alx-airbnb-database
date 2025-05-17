# Test the performance of queries on the partitioned table (e.g., fetching bookings by date range).
## Report
Partitioning the bookings table by check_in_date (yearly ranges) reduces query execution time from ~1510 ms to ~5.5 ms for the provided query, leveraging partition pruning to scan only the relevant partition (bookings_2025). Indexes on each partition ensure efficient joins and filtering. MySQL partitioning is viable but less flexible due to primary key and foreign key limitations.
