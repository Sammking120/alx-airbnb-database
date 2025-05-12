# Airbnb Database Schema
  This file contains the SQL schema for the Airbnb database.

# Tables
  1. users: Stores information about the users (hosts and guests).
  2. properties: Stores information about the properties available for rent.
  3. bookings: Stores information about the bookings made by users for properties.
# Indexes
  Indexes are created on frequently queried columns to improve performance:
      users.email: Indexed for faster lookups of users by email.
      properties.location: Indexed for faster search by location.
      bookings.property_id: Indexed for faster queries related to bookings.
# Instructions
  Run the schema.sql file to create the tables and indexes.
  Ensure that all necessary foreign key relationships are respected when inserting data.
