-- ============================================================
-- DATA LOADING (UPDATE PATHS BEFORE RUNNING)
-- ============================================================

-- Example:
-- Windows: 'C:/Users/yourname/project/data/drivers.csv'
-- Mac/Linux: '/Users/yourname/project/data/drivers.csv'

COPY drivers(driver_id, driver_name, join_date, rating)
FROM '/path/to/data/drivers.csv'
DELIMITER ',' CSV HEADER;

COPY locations(location_id, area_name, city)
FROM '/path/to/data/locations.csv'
DELIMITER ',' CSV HEADER;

COPY riders(rider_id, rider_name, city, signup_date)
FROM '/path/to/data/riders.csv'
DELIMITER ',' CSV HEADER;

COPY trips(
    trip_id, driver_id, rider_id, pickup_location, drop_location,
    trip_time, trip_duration, fare_amount, cost_amount, trip_status
)
FROM '/path/to/data/trips.csv'
DELIMITER ',' CSV HEADER;

COPY payments(payment_id, trip_id, payment_method)
FROM '/path/to/data/payments.csv'
DELIMITER ',' CSV HEADER;