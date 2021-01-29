-- CREATE SCHEMA IF NOT EXISTS AIRLINE;
-- SET search_path = AIRLINE;
-- TODO::FKs need columns before defined.
CREATE TABLE COMPANY(
    Company_ID SERIAL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Number_of_employee INT DEFAULT 0 NOT NULL,
    Address VARCHAR(100)
);
CREATE TABLE AIRLINE_COMPANY(
    Number_of_airplane INT DEFAULT 0 NOT NULL,
    Company_ID INT,
    IATA VARCHAR(2),
    Callsign VARCHAR(20),
    FOREIGN KEY (Company_ID) REFERENCES COMPANY(Company_ID),
    PRIMARY KEY (Company_ID)
);
CREATE TABLE AIRPLANE_COMPANY(
    Company_ID INT UNIQUE,
    Number_of_types INT,
    FOREIGN KEY(Company_ID) REFERENCES COMPANY(Company_ID),
    PRIMARY KEY (Company_ID)
);
CREATE TABLE FLIGHT(
    Flight_number INT PRIMARY KEY NOT NULL,
    Company_ID INT,
    FOREIGN KEY(Company_ID) REFERENCES AIRLINE_COMPANY(Company_ID)
);
CREATE TABLE FLIGHT_DAY(
    Day INT,
    Flight_number INT,
    FOREIGN KEY(Flight_number) REFERENCES FLIGHT(Flight_number),
    PRIMARY KEY(Flight_number, Day),
    CHECK (
        Day > 0
        AND Day < 8
    )
);
CREATE TABLE FARE_CODE (
    Code VARCHAR(20),
    Description VARCHAR(100),
    Reward_ratio DOUBLE PRECISION DEFAULT 0.0::double precision NOT NULL,
    PRIMARY KEY (Code)
);
CREATE TABLE FARE (
    Flight_number INT,
    Fare_code VARCHAR(20),
    Amount DOUBLE PRECISION NOT NULL,
    Luggage_limit INT DEFAULT 0 NOT NULL,
    Treat BOOLEAN DEFAULT 'F' NOT NULL,
    CHECK (
        Luggage_limit >= 0
        AND Luggage_limit < 26
    ),
    FOREIGN KEY(Flight_number) REFERENCES FLIGHT(Flight_number),
    FOREIGN KEY(Fare_code) REFERENCES FARE_CODE(Code),
    PRIMARY KEY(
        Flight_number,
        Fare_code
    )
);
CREATE TABLE AIRPLANE_TYPE(
    Airplane_type_name VARCHAR(30) PRIMARY KEY,
    Max_seats INT DEFAULT 0 NOT NULL,
    Company_ID INT,
    FOREIGN KEY(Company_ID) REFERENCES AIRPLANE_COMPANY(Company_ID)
);
CREATE TABLE AIRPORT(
    Airport_code VARCHAR(50) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) DEFAULT 'N/A' NOT NULL,
    CHECK (char_length(airport_code) = 3)
);
CREATE TABLE CAN_LAND(
    Airplane_type_name VARCHAR(30) NOT NULL,
    Airport_code VARCHAR(50) NOT NULL,
    FOREIGN KEY(Airplane_type_name) REFERENCES AIRPLANE_TYPE(Airplane_type_name),
    FOREIGN KEY(Airport_code) REFERENCES Airport(Airport_code),
    PRIMARY KEY(
        Airplane_type_name,
        Airport_code
    )
);
CREATE TABLE AIRPLANE(
    Airplane_id SERIAL PRIMARY KEY,
    Total_number_of_seats INT DEFAULT 0 NOT NULL,
    Airplane_type VARCHAR(30) NOT NULL,
    Company_ID INT,
    FOREIGN KEY(Company_ID) REFERENCES AIRLINE_COMPANY(Company_ID),
    FOREIGN KEY(Airplane_type) REFERENCES AIRPLANE_TYPE(Airplane_type_name)
);
CREATE TABLE FLIGHT_LEG(
    Flight_number INT,
    FOREIGN KEY(Flight_number) REFERENCES FLIGHT(Flight_number),
    Leg_number SERIAL,
    PRIMARY KEY(
        Flight_number,
        Leg_number
    ),
    Departure_airport_code VARCHAR(50) NOT NULL,
    Arrival_airport_code VARCHAR(50) NOT NULL,
    FOREIGN KEY(Departure_airport_code) REFERENCES Airport(Airport_code),
    FOREIGN KEY(Arrival_airport_code) REFERENCES Airport(Airport_code),
    Flight_mile INT DEFAULT 0 NOT NULL,
    Scheduled_departure_time DATE NOT NULL,
    Scheduled_arrival_time DATE NOT NULL,
    CHECK (
        scheduled_arrival_time > scheduled_departure_time
    )
);
CREATE TABLE LEG_INSTANCE(
    Flight_number INT,
    Leg_number INT,
    FOREIGN KEY(Flight_number, Leg_number) REFERENCES FLIGHT_LEG(Flight_number, Leg_number),
    Date DATE,
    PRIMARY KEY(
        Flight_number,
        Leg_number,
        Date
    ),
    Number_of_avaliable_seats INT DEFAULT 0 NOT NULL,
    Airplane_id INT NOT NULL,
    Departure_airport_code VARCHAR(50) NOT NULL,
    Arrival_airport_code VARCHAR(50) NOT NULL,
    FOREIGN KEY(Airplane_id) REFERENCES AIRPLANE(Airplane_id),
    FOREIGN KEY(Departure_airport_code) REFERENCES Airport(Airport_code),
    FOREIGN KEY(Arrival_airport_code) REFERENCES Airport(Airport_code),
    Departure_time DATE,
    Arrival_time DATE,
    CHECK (Arrival_time >= Departure_time)
);
CREATE TABLE CUSTOMER(
    Name VARCHAR(100) NOT NULL,
    Passport_number VARCHAR(14) PRIMARY KEY,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Address VARCHAR(200) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    CHECK (
        char_length(Passport_number) >= 7
        AND char_length(Passport_number) < 15
    ),
    CHECK(
        char_length(Country) = 2
        AND Country ~ '[A-Z]+'
    )
);
CREATE TABLE SEAT_RESERVATION(
    Flight_number INT,
    Leg_number INT,
    Date DATE,
    Customer_PN VARCHAR(14),
    Fare_code VARCHAR(20),
    FOREIGN KEY(Flight_number, Leg_number, Date) REFERENCES LEG_INSTANCE(Flight_number, Leg_number, Date),
    FOREIGN KEY(Customer_PN) REFERENCES CUSTOMER(Passport_number),
    FOREIGN KEY(Flight_number, Fare_code) REFERENCES FARE(Flight_number, Fare_code),
    Seat_number INT,
    PRIMARY KEY(
        Flight_number,
        Leg_number,
        Date,
        Customer_PN,
        Seat_number,
        Fare_code
    ),
    Checked_in BOOLEAN DEFAULT 'f' NOT NULL
);
CREATE TABLE FFC(
    Customer_PN VARCHAR(14),
    Point INT DEFAULT 0 NOT NULL,
    FOREIGN KEY(Customer_PN) REFERENCES CUSTOMER(Passport_number) ON DELETE CASCADE,
    PRIMARY KEY(Customer_PN)
);
CREATE TABLE FFC_ACTIVITY(
    Customer_PN VARCHAR(14),
    Flight_number INT,
    Leg_number INT,
    Date DATE,
    Reservation_number INT,
    Fare_code VARCHAR(20),
    FOREIGN KEY(
        Customer_PN,
        Flight_number,
        Leg_number,
        Date,
        Seat_number,
        Fare_code
    ) REFERENCES SEAT_RESERVATION(
        Customer_PN,
        Flight_number,
        Leg_number,
        Date,
        Seat_number,
        Fare_code
    ),
    PRIMARY KEY(
        Customer_PN,
        Flight_number,
        Leg_number,
        Date,
        Reservation_number,
    )
);