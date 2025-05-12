# Database Normalization for Airbnb-like System
Normalization is the process of organizing data in a database to reduce redundancy and improve data integrity. This document explains how the database schema for the Airbnb-like system has been normalized to achieve a high level of efficiency and maintainability.

## Normalization Levels
 **1. First Normal Form (1NF)**
  To satisfy 1NF:
  * Each table has a primary key to uniquely identify each record.
  * All columns contain atomic values (no repeating groups or arrays).
  * Each column contains values of a single type.
  
    **Implementation in the Schema:** 
  * Each table (e.g., User, Property, Booking, Payment, Review, Message) has a primary key (user_id, property_id, booking_id, etc.).
  * All attributes are atomic, such as first_name, last_name, email, and role in the User table.
 
 **2. Second Normal Form (2NF)**
  To satisfy 2NF:
  * The database must first meet 1NF.
  * All non-key attributes must depend on the entire primary key, not just part of it.

    **Implementation in the Schema:**
  * Composite keys are avoided by using UUIDs as primary keys for all tables.
  * For example, in the Booking table, attributes like start_date, end_date, and total_price depend entirely on the booking_id (primary key).

**3. Third Normal Form (3NF)**
 To satisfy 3NF:
  * The database must first meet 2NF.
  * All attributes must depend only on the primary key, and there should be no transitive dependencies.

    **Implementation in the Schema:**
  * In the **User** table, attributes like **email** and **role** depend only on **user_id**.
  * In the **Property** table, attributes like **name**, **description**, and **location** depend only on **property_id**.
  * Foreign keys are used to establish relationships between tables, ensuring no redundant data.
  
**4. Boyce-Codd Normal Form (BCNF)**
  To satisfy BCNF:
  * The database must first meet 3NF.
  * Every determinant must be a candidate key.
 
    **Implementation in the Schema:**
  * All tables are designed such that every determinant is a candidate key. For example, in the User table, email is unique and acts as a determinant for identifying users.
## Table Relationships
1. **User** Table
  * **Normalization**: Contains only user-specific data (e.g., first_name, last_name, email).
  * **Relationships**:
      * User is linked to Property (host_id).
      * User is linked to Booking (user_id).
      * User is linked to Message (sender_id and recipient_id).
      * User is linked to Review (user_id).
2. Property Table
  * **Normalization**: Contains only property-specific data (e.g., name, description, location).
  * **Relationships**:
      * Property is linked to User (host_id).
      * Property is linked to Booking (property_id).
      * Property is linked to Review (property_id).
3. Booking Table
  * **Normalization**: Contains only booking-specific data (e.g., start_date, end_date, total_price).
  * **Relationships**:
      * Booking is linked to Property (property_id).
      * Booking is linked to User (user_id).
      * Booking is linked to Payment (booking_id).
4. Payment Table
  * **Normalization**:
      * Contains only payment-specific data (e.g., amount, payment_date, payment_method).
  * **Relationships**:
      * Payment is linked to Booking (booking_id).
5. Review Table
  * **Normalization**: Contains only review-specific data (e.g., rating, comment).
  * **Relationships:
      * Review is linked to Property (property_id).
      * Review is linked to User (user_id).
6. Message Table
    * **Normalization**: Contains only message-specific data (e.g., message_body, sent_at).
    * **Relationships**:
      * Message is linked to User (sender_id and recipient_id).
## Benefits of Normalization
  1. Data Integrity: Ensures that data is consistent and accurate across the database.
  2. Reduced Redundancy: Eliminates duplicate data, reducing storage requirements.
  3. Improved Query Performance: Smaller, well-structured tables improve query efficiency.
  4. Ease of Maintenance: Changes to the database schema are easier to implement without affecting other parts of the system.
## Conclusion
The database schema for the Airbnb-like system has been normalized to at least 3NF (and in some cases BCNF) to ensure data integrity, reduce redundancy, and improve maintainability. The use of foreign keys and indexing further enhances the performance and reliability of the database.
