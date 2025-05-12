# Airbnb Database Design.

## Requirements for Airbnb-like Database System
This document outlines the functional and non-functional requirements for the database system of an Airbnb-like platform. The system is designed to manage users, properties, bookings, payments, reviews, and messages efficiently.

## Functional Requirements
  1. User Management
   * The system must store user information, including:
       * user_id: Unique identifier for each user (UUID).
       * first_name and last_name: User's name (non-null).
       * email: Unique and non-null for each user.
       * password_hash: Encrypted password for authentication.
       * phone_number: Optional contact number.
       * role: Defines the user's role (guest, host, or admin).
       * created_at: Timestamp of user creation.
  2. Property Management
   * The system must allow hosts to list properties with the following details:
       * property_id: Unique identifier for each property (UUID).
       * host_id: Foreign key referencing the user_id of the host.
       * name: Name of the property (non-null).
       * description: Detailed description of the property (non-null).
       * location: Address or location of the property (non-null).
       * pricepernight: Cost per night for booking (non-null).
       * created_at: Timestamp of property creation.
       * updated_at: Timestamp of the last update.
  3. Booking Management
    * The system must allow users to book properties with the following details:
        * booking_id: Unique identifier for each booking (UUID).
        * property_id: Foreign key referencing the property being booked.
        * user_id: Foreign key referencing the user making the booking.
        * start_date and end_date: Dates for the booking period (non-null).
        * total_price: Total cost of the booking (non-null).
        * status: Booking status (pending, confirmed, or canceled).
        * created_at: Timestamp of booking creation.
  4. Payment Management
    * The system must handle payments for bookings with the following details:
        * payment_id: Unique identifier for each payment (UUID).
        * booking_id: Foreign key referencing the associated booking.
        * amount: Payment amount (non-null).
        * payment_date: Timestamp of the payment.
        * payment_method: Payment method (credit_card, paypal, or stripe).
   5. Review Management
      * The system must allow users to leave reviews for properties with the following details:
          * review_id: Unique identifier for each review (UUID).
          * property_id: Foreign key referencing the reviewed property.
          * user_id: Foreign key referencing the user leaving the review.
          * rating: Integer rating between 1 and 5 (inclusive).
          * comment: Textual feedback (non-null).
          * created_at: Timestamp of review creation.
    6. Messaging System
      * The system must allow users to send messages with the following details:
          * message_id: Unique identifier for each message (UUID).
          * sender_id: Foreign key referencing the user sending the message.
          * recipient_id: Foreign key referencing the user receiving the message.
          * message_body: Content of the message (non-null).
          * sent_at: Timestamp of when the message was sent.
# Non-Functional Requirements
  1. Data Integrity
      * Enforce foreign key constraints to maintain relationships between tables.
      * Use unique constraints for attributes like email to prevent duplicates.
2. Scalability
      * Use indexing on primary keys and frequently queried columns (e.g., email, property_id,      booking_id) to optimize performance.
      * Design the schema to handle a large number of users, properties, bookings, and transactions.
3. Security
      * Store passwords securely using hashing algorithms.
      * Restrict access to sensitive data (e.g., password_hash) to authorized users only.
4. Reliability
      * Ensure data consistency through normalization (up to 3NF or BCNF).
      * Use timestamps (created_at, updated_at) to track changes and maintain audit trails.
5. Usability
      * Provide clear relationships between entities to simplify querying and reporting.
      * Use ENUM types for attributes like role, status, and payment_method to enforce valid values.
## Entity Relationships
 1. Users
    * Can host properties.
    * Can book properties.
    * Can send and receive messages.
    * Can leave reviews for properties.
 2. Properties
    * Belong to a host (user).
    * Can be booked by users.
    * Can receive reviews from users.
  3. Bookings
    * Link users and properties.
    * Can have associated payments.
  4. Payments
    * Link to bookings.
    * Store payment details.
  5. Reviews
    * Link users and properties.
    * Contain feedback and ratings.
  6. Messages
    * Link users (sender and recipient).
    * Store communication details.
## Conclusion
This database schema is designed to meet the functional and non-functional requirements of an Airbnb-like platform. It ensures data integrity, scalability, and usability while maintaining clear relationships between entities.

