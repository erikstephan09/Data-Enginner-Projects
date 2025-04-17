CREATE TABLE rider_info (
	id INTEGER,
	biker_id  INTEGER,
	user_type VARCHAR(10),
	birth_year INTEGER,
	gender INTEGER,
	age INTEGER
);

CREATE TABLE date_t(
	id INTEGER,
	date_key INTEGER PRIMARY KEY,
	date DATE,
	year INTEGER,
	month VARCHAR(3),
	day INTEGER
);

CREATE TABLE start_station(
	id INTEGER,
	start_id INTEGER PRIMARY KEY,
	start_station_name VARCHAR(30),
	start_station_latitude REAL,
	start_station_longitude REAL
);

CREATE TABLE end_station(
	id INTEGER,
	end_id INTEGER PRIMARY KEY,
	end_station_name VARCHAR(30),
	end_station_latitude REAL,
	end_station_longitude REAL
);

CREATE TABLE weather(
	id INTEGER PRIMARY KEY,
	date_key INTEGER,
	date DATE,
	awnd REAL,
	prcp REAL,
	snow REAL,
	snwd REAL,
	tavg INTEGER,
	TMAX INTEGER,
	TMIN INTEGER,
	FOREIGN KEY (date_key) REFERENCES date_t(date_key)
);


CREATE TABLE rider(
	id INTEGER PRIMARY KEY,
	biker_id INTEGER,
	date_key INTEGER,
	start_station_id INTEGER,
	end_station_id INTEGER,
	trip_duration_seconds REAL,
	trip_duration_minutes REAL,
	trip_duration_hours REAL,
	rider_info_id INTEGER,
	trip_flag BOOLEAN,
	FOREIGN KEY (rider_info) REFERENCES rider_info(id),
	FOREIGN KEY (start_station) REFERENCES start_station(start_id),
	FOREIGN KEY (end_station) REFERENCES end_station(end_id)
);