-- =========================
-- CREATE TABLES
-- =========================

CREATE TABLE drivers (
    driver_id INT PRIMARY KEY,
    driver_name TEXT,
    join_date DATE,
    rating NUMERIC(2,1)
);

CREATE TABLE riders (
    rider_id INT PRIMARY KEY,
    rider_name TEXT,
    city TEXT,
    signup_date DATE
);

CREATE TABLE locations (
    location_id INT PRIMARY KEY,
    area_name TEXT,
    city TEXT
);

CREATE TABLE trips (
    trip_id INT PRIMARY KEY,
    driver_id INT,
    rider_id INT,
    pickup_location INT,
    drop_location INT,
    trip_time TIMESTAMP,
    trip_duration INT, -- in minutes or seconds (define in your data)
    fare_amount NUMERIC(10,2),
    cost_amount NUMERIC(10,2),
    trip_status TEXT,

    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
    FOREIGN KEY (rider_id) REFERENCES riders(rider_id),
    FOREIGN KEY (pickup_location) REFERENCES locations(location_id),
    FOREIGN KEY (drop_location) REFERENCES locations(location_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    trip_id INT,
    payment_method TEXT,

    FOREIGN KEY (trip_id) REFERENCES trips(trip_id)
);


