---
name: add-booking
description: Add one or more bookings to the Smiles of Miles by editing `src/main/resources/import.sql`.
---

## Instructions

1. **Read the current file**: Read `src/main/resources/import.sql` to determine:
   - The highest existing `booking.id`
   - The current `booking_seq RESTART WITH` value
   - The existing `customer.id` values and names

2. **Resolve the customer**: Match the customer name from the user's request to an existing customer. If no matching customer exists, ask the user whether to create a new one. If creating a new customer:
   - Use the next available `customer.id` (one above the current max)
   - Add the `INSERT INTO customer` statement after the existing customer rows
   - Update `ALTER SEQUENCE customer_seq RESTART WITH` to the new customer's id + 1

3. **Add the booking**: Insert a new `INSERT INTO booking` statement with:
   - `id`: next available booking id (one above the current max)
   - `customer_id`: the id of the matched or newly created customer
   - `dateFrom`: start date in `'YYYY-MM-DD'` format
   - `dateTo`: end date in `'YYYY-MM-DD'` format
   - `location`: the rental location as a string

   Place the new booking INSERT grouped with the same customer's other bookings if they exist, otherwise at the end before the `ALTER SEQUENCE booking_seq` line.

4. **Update the booking sequence**: Set `ALTER SEQUENCE booking_seq RESTART WITH` to the new highest booking id + 1.

## Example

User request: "Add a booking for Speedy McWheels in Paris, France from 2026-04-01 to 2026-04-10"

Given that Speedy McWheels is customer id 1 and the current max booking id is 15:

```sql
INSERT INTO booking (id, customer_id, dateFrom, dateTo, location)
VALUES (16, 1, '2026-04-01', '2026-04-10', 'Paris, France');
```

Then update the sequence:
```sql
ALTER SEQUENCE booking_seq RESTART WITH 17;
```

## Schema Reference

- **customer** table: `id`, `firstName`, `lastName`
- **booking** table: `id`, `customer_id`, `dateFrom`, `dateTo`, `location`
- Sequences: `customer_seq`, `booking_seq` (RESTART WITH = max id + 1)
