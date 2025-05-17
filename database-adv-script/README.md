# Complex Queries with Joins
#### Master SQL joins by writing complex queries using different types of joins.


### INNER JOIN
    * Tables:
        * bookings: Contains booking details (e.g., booking_id, check_in_date, check_out_date, total_price, user_id).
        * users: Contains user details (e.g., user_id, first_name, last_name, email).
* INNER JOIN: Matches rows where bookings.user_id equals users.user_id, returning only bookings with associated users.
* Selected Columns: Retrieves key booking and user information for clarity.
* Alias: Uses b and u for concise table references.

# LEFT JOIN
    * Tables:
        * properties: Contains property details (e.g., property_id, title, location).
        * reviews: Contains review details (e.g., review_id, rating, comment, review_date, property_id).
* LEFT JOIN: Returns all rows from properties and matching rows from reviews. If a property has no reviews, reviews columns will be NULL.
* Selected Columns: Includes key property and review information for clarity.
* Alias: Uses p and r for concise table references.

# FULL OUTER JOIN
    * Tables:
        * users: Contains user details (e.g., user_id, first_name, last_name, email).
        * bookings: Contains booking details (e.g., booking_id, check_in_date, check_out_date, total_price, user_id).
* FULL OUTER JOIN: Returns all rows from both users and bookings. If there’s no match, NULL values appear for the non-matching side (e.g., users without bookings will have NULL for booking columns, and bookings without users will have NULL for user columns).
* Selected Columns: Includes key user and booking information for clarity.
* Alias: Uses u and b for concise table references.

# Subqueries
#### Objective: Write both correlated and non-correlated subqueries.
1. Write a query to find all properties where the average rating is greater than 4.0 using a subquery.
    * Tables:
        * properties: Contains property details (e.g., property_id, title, location).
        * reviews: Contains review details (e.g., review_id, rating, property_id).
    * Subquery:
        * The subquery (SELECT r.property_id FROM reviews r GROUP BY r.property_id HAVING AVG(r.rating) > 4.0) calculates the average rating for each property by grouping reviews by property_id and filters for those with an average rating greater than 4.0.
        * It returns a list of property_id values that meet this condition.
    * Main Query:
        * Selects properties from the properties table where the property_id is in the list returned by the subquery.
        * Retrieves key property details (property_id, title, location).
        * Alias: Uses p and r for concise table references.
    

2. Write a correlated subquery to find users who have made more than 3 bookings.
    * Tables:
        * users: Contains user details (e.g., user_id, first_name, last_name, email).
        * bookings: Contains booking details (e.g., booking_id, user_id).
    * Correlated Subquery:
        * The subquery (SELECT COUNT(*) FROM bookings b WHERE b.user_id = u.user_id) counts the number of bookings for each user by matching bookings.user_id to the current users.user_id from the outer query.
        * It runs for each row in the users table, making it "correlated" with the outer query.
    * Main Query:
        * Selects users where the subquery returns a count greater than 3.
        * Retrieves key user details (user_id, first_name, last_name, email).
    * Alias: Uses u and b for concise table references.


# Apply Aggregations and Window Functions
#### Objective: Use SQL aggregation and window functions to analyze data.
1. Write a query to find the total number of bookings made by each user, using the COUNT function and GROUP BY clause.
    * Tables:
        * users: Contains user details (e.g., user_id, first_name, last_name).
        * bookings: Contains booking details (e.g., booking_id, user_id).
    * LEFT JOIN: Ensures all users are included, even those with no bookings (where booking_id will be NULL, resulting in a count of 0).
    * COUNT(b.booking_id): Counts the number of bookings per user. Using b.booking_id (instead of COUNT(*)) ensures NULL rows from the join (users with no bookings) are not counted.
    * GROUP BY: Groups results by user_id, first_name, and last_name to aggregate bookings per user.
    * Alias: Uses u and b for tables and total_bookings for the count column.
    * The LEFT JOIN ensures users with zero bookings appear in the results (with total_bookings = 0). If you only want users with at least one booking, replace LEFT JOIN with INNER JOIN.

2. Use a window function (ROW_NUMBER, RANK) to rank properties based on the total number of bookings they have received.
    * Tables:
        * properties: Contains property details (e.g., property_id, title, location).
        * bookings: Contains booking details (e.g., booking_id, property_id).
    * LEFT JOIN: Ensures all properties are included, even those with no bookings (where booking_id will be NULL, resulting in a count of 0).
    * COUNT(b.booking_id): Counts the number of bookings per property. Using b.booking_id ensures NULL rows from the join (properties with no bookings) are not counted.
    * GROUP BY: Aggregates bookings by property_id, title, and location.
    * Window Function:
        * RANK() OVER (ORDER BY COUNT(b.booking_id) DESC): Assigns a rank to each property based on the total number of bookings, with the highest booking count receiving rank 1. Ties receive the same rank, with gaps in subsequent ranks (e.g., 1, 1, 3).
    * ORDER BY booking_rank: Sorts results by rank for clarity.
    * Alias: Uses p and b for tables, total_bookings for the count, and booking_rank for the rank.
Notes:
* RANK vs. ROW_NUMBER:
    * RANK() assigns the same rank to ties (e.g., two properties with 10 bookings both get rank 1, and the next gets rank 3).
    * If you prefer unique ranks (e.g., 1, 2, 3 even for ties), replace RANK() with ROW_NUMBER().
* The LEFT JOIN ensures properties with zero bookings are included (with total_bookings = 0). If you only want properties with bookings, use INNER JOIN.

