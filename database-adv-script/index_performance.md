# Implement Indexes for Optimization
### Objective: Identify and create indexes to improve query performance.
* Identify high-usage columns in your User, Booking, and Property tables (e.g., columns used in WHERE, JOIN, ORDER BY clauses).
  Analysis of High-Usage Columns
1. users Table
* Primary Key:
    * user_id: Used in every JOIN with bookings (e.g., b.user_id = u.user_id) and in WHERE clauses for correlated subqueries (e.g., b.user_id = u.user_id). Also used in GROUP BY for counting bookings per user.
        * Usage: JOIN, WHERE, GROUP BY.
        * High-Usage Reason: Core identifier for linking users to bookings and filtering user-specific data.
* Other Columns:
    * first_name, last_name: Used in SELECT and GROUP BY clauses to display user details (e.g., in the query counting bookings per user). Not typically used in WHERE or ORDER BY but included in output for user identification.
        * Usage: SELECT, GROUP BY.
        * High-Usage Reason: Frequently selected for display but less critical for filtering or sorting.
* email: Selected in output but not used in WHERE, JOIN, or ORDER BY in provided queries. In practice, it might be used in WHERE for user lookups (e.g., WHERE email = 'user@example.com').
    * Usage: SELECT.
    * High-Usage Reason: Potential for WHERE clauses in user authentication or search, though not seen in provided queries.
High-Usage Columns: user_id (primary key, critical for JOINs and filtering), first_name, last_name (frequent in output and GROUP BY).      

2. bookings Table
* Primary Key:
    * booking_id: Used in COUNT functions (e.g., COUNT(b.booking_id)) to count bookings per user or property. Not typically used in WHERE or JOIN but critical for aggregation.
        * Usage: SELECT (COUNT), GROUP BY.
        * High-Usage Reason: Essential for counting bookings, especially to avoid counting NULL rows in LEFT JOINs.
* Foreign Keys:
    * user_id: Used in JOINs with users (e.g., b.user_id = u.user_id) and in WHERE clauses for correlated subqueries (e.g., counting bookings per user).
        * Usage: JOIN, WHERE, GROUP BY.
        * High-Usage Reason: Links bookings to users, critical for user-specific queries.
    * property_id: Used in JOINs with properties (e.g., p.property_id = b.property_id) and in WHERE clauses for subqueries (e.g., filtering properties by booking counts).
        * Usage: JOIN, WHERE, GROUP BY.
        * High-Usage Reason: Links bookings to properties, essential for property-specific queries.
* Other Columns:
    * check_in_date, check_out_date: Selected in output and likely used in WHERE clauses for filtering bookings by date range (e.g., WHERE check_in_date >= '2025-01-01'), though not in provided queries. Common in Airbnb-like systems for availability searches.
        * Usage: SELECT, (likely) WHERE.
        * High-Usage Reason: Critical for temporal filtering, a common operation in booking systems.
    * total_price: Selected in output but not used in WHERE or ORDER BY in provided queries. In practice, it might be used for sorting (e.g., ORDER BY total_price DESC) or filtering (e.g., budget constraints).
* Usage: SELECT.
* High-Usage Reason: Potential for ORDER BY or WHERE in cost-related queries.
High-Usage Columns: booking_id (for counting), user_id, property_id (for JOINs and filtering), check_in_date, check_out_date (for temporal filtering).

3. properties Table
* Primary Key:
    * property_id: Used in every JOIN with bookings or reviews (e.g., p.property_id = b.property_id, p.property_id = r.property_id) and in WHERE clauses for subqueries (e.g., filtering by average rating). Also used in GROUP BY for counting bookings or reviews.
        * Usage: JOIN, WHERE, GROUP BY.
        * High-Usage Reason: Core identifier for linking properties to bookings/reviews and filtering property-specific data.
* Other Columns:
    * title, location: Used in SELECT and GROUP BY clauses to display property details (e.g., in queries ranking properties by bookings). Likely used in WHERE for search queries (e.g., WHERE location = 'Miami'), though not in provided queries.
    * Usage: SELECT, GROUP BY, (likely) WHERE.
    * High-Usage Reason: Frequently selected for display and used in location-based searches, common in Airbnb-like systems.
High-Usage Columns: property_id (primary key, critical for JOINs and filtering), title, location (frequent in output and likely WHERE clauses).

4. reviews Table (Bonus, since used in some queries)
* Primary Key:
    * review_id: Selected in output but not typically used in WHERE or JOIN.
        * Usage: SELECT.
        * High-Usage Reason: Less critical for filtering or joining.
* Foreign Key:
    * property_id: Used in JOINs with properties (e.g., p.property_id = r.property_id) and in GROUP BY for aggregating ratings.
        * Usage: JOIN, WHERE, GROUP BY.
        * High-Usage Reason: Links reviews to properties, essential for review-based queries.
* Other Columns:
    * rating: Used in WHERE clauses for subqueries (e.g., AVG(r.rating) > 4.0) and potentially in ORDER BY for sorting by rating.
        * Usage: WHERE, (likely) ORDER BY.
        * High-Usage Reason: Critical for filtering or sorting by review quality.
* review_date: Selected in output and likely used in WHERE for filtering recent reviews (e.g., WHERE review_date >= '2025-01-01').
    * Usage: SELECT, (likely) WHERE.
    * High-Usage Reason: Useful for temporal filtering of reviews.
High-Usage Columns: property_id (for JOINs and grouping), rating (for filtering and aggregation), review_date (for temporal filtering).

Summary of High-Usage Columns

| Table	| High-Usage Columns	| Common Usage |
| :----- :|:-------------------:|:------------------------------------------------------------------------------------:|
| users	| user_id, first_name, last_name |	JOIN, WHERE, GROUP BY, SELECT |
| bookings	| booking_id, user_id, property_id, check_in_date, check_out_date	| JOIN, WHERE, COUNT, GROUP BY, SELECT |
| properties	| property_id, title, location |	JOIN, WHERE, GROUP BY, SELECT |
| reviews	| property_id, rating, review_date	| JOIN, WHERE, GROUP BY, SELECT |

* Performance:
    * Columns in WHERE and JOIN conditions (e.g., user_id, property_id) are performance-critical, as they affect query execution plans.
    * Ensure proper foreign key constraints to maintain data integrity, especially for user_id and property_id.

Adding the idx_reviews_property_id index significantly improves the query’s performance by replacing a sequential scan with an index scan and enabling a faster merge join. The execution time drops from ~155 ms to ~25 ms in the example, with similar cost reductions. You can verify this by running EXPLAIN ANALYZE before and after creating the index, checking for reduced execution times and optimized scan/join methods.