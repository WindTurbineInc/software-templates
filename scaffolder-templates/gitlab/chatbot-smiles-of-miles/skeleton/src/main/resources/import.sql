INSERT INTO customer (id, firstName, lastName) VALUES (1, 'Speedy', 'McWheels');
INSERT INTO customer (id, firstName, lastName) VALUES (2, 'Zoom', 'Thunderfoot');
INSERT INTO customer (id, firstName, lastName) VALUES (3, 'Kevin', 'Dubois');
INSERT INTO customer (id, firstName, lastName) VALUES (4, 'Turbo', 'Gearshift');
INSERT INTO customer (id, firstName, lastName) VALUES (5, 'Drifty', 'Skiddy');
INSERT INTO customer (id, firstName, lastName) VALUES (6, 'Natale', 'Vinto');
INSERT INTO customer (id, firstName, lastName) VALUES (7, 'Shaaf', 'Syed');


ALTER SEQUENCE customer_seq RESTART WITH 7;

INSERT INTO booking (id, customer_id, dateFrom, dateTo, location)
VALUES (1, 1, '2026-07-13', '2026-07-23', 'Brussels, Belgium');
INSERT INTO booking (id, customer_id, dateFrom, dateTo, location)
VALUES (2, 1, '2026-08-05', '2026-08-20', 'Los Angeles, California');
INSERT INTO booking (id, customer_id, dateFrom, dateTo, location)
VALUES (3, 1, '2026-10-01', '2026-10-07', 'Geneva, Switzerland');

INSERT INTO booking (id, customer_id, dateFrom, dateTo, location)
VALUES (4, 2, '2026-07-20', '2026-07-25', 'Tokyo, Japan');
INSERT INTO booking (id, customer_id, dateFrom, dateTo, location)
VALUES (5, 2, '2026-11-10', '2026-11-15', 'Brisbane, Australia');

INSERT INTO booking (id, customer_id, dateFrom, dateTo, location)
VALUES (7, 3, '2026-01-16', '2026-01-20', 'Stockholm, Sweden');
INSERT INTO booking (id, customer_id, dateFrom, dateTo, location)
VALUES (8, 3, '2026-10-12', '2026-10-18', 'Singapore');
INSERT INTO booking (id, customer_id, dateFrom, dateTo, location)
VALUES (9, 3, '2026-12-03', '2026-12-09', 'Capetown, South Africa');

INSERT INTO booking (id, customer_id, dateFrom, dateTo, location)
VALUES (10, 4, '2026-07-01', '2026-07-06', 'Nuuk, Greenland');
INSERT INTO booking (id, customer_id, dateFrom, dateTo, location)
VALUES (11, 4, '2026-07-25', '2026-07-30', 'Santiago de Chile');
INSERT INTO booking (id, customer_id, dateFrom, dateTo, location)
VALUES (12, 4, '2026-10-15', '2026-10-22', 'Dubai');
INSERT INTO booking (id, customer_id, dateFrom, dateTo, location)
VALUES (13, 6, '2026-09-30', '2026-10-01', 'Riyadh');
INSERT INTO booking (id, customer_id, dateFrom, dateTo, location)
VALUES (14, 7, '2026-10-01', '2026-10-02', 'Jeddah');

ALTER SEQUENCE booking_seq RESTART WITH 14;
