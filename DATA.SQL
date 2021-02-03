---- CREATE AIRLINE COMPANY
INSERT INTO COMPANY(company_id, name, number_of_employee)
VALUES (1, 'CURE CORP', 3);
INSERT INTO AIRLINE_COMPANY(company_id, number_of_airplane)
VALUES(1, 1);
---- CREATE FLIGHT
INSERT INTO FLIGHT(flight_number, company_id)
VALUES (23, 1);
INSERT INTO FLIGHT(flight_number, company_id)
VALUES (24, 1);
INSERT INTO FLIGHT(flight_number, company_id)
VALUES (34, 1);
---- CREATE FARE CODE
INSERT INTO FARE_CODE(Code, Description)
VALUES (
        'SUPER_EKO',
        'EN KÜÇÜK PAKET. YALNIZCA KABİN BAGAJI'
    );
INSERT INTO FARE_CODE(Code, Description)
VALUES (
        'EKO',
        'EKONOMİK STANDART PAKET. 20KG BAGAJ HAKKI'
    );
INSERT INTO FARE_CODE(Code, Description)
VALUES (
        'AVANTAJ',
        'STANDART PAKET + 20KG BAGAJ + SANDVİÇ + UÇAK İÇİ HİZMET.'
    );
INSERT INTO FARE_CODE(Code, Description)
VALUES (
        'BUSINESS_FLEX',
        'AVANTAJ PAKET DAHA FAZLA SAYILARLA.'
    );
---- CREATE FARE
INSERT INTO FARE(flight_number, fare_code, amount)
VALUES (23, 'SUPER_EKO', 80);
INSERT INTO FARE(flight_number, fare_code, amount)
VALUES (24, 'AVANTAJ', 100);
INSERT INTO FARE(flight_number, fare_code, amount)
VALUES (24, 'EKO', 100);
INSERT INTO FARE(flight_number, fare_code, amount)
VALUES (24, 'SUPER_EKO', 100);
----  CREATE AIRPLANE COMPANY
INSERT INTO COMPANY(company_id, name, number_of_employee)
VALUES (2, 'CURE AIRPLANE CORP', 3);
INSERT INTO AIRPLANE_COMPANY(company_id, number_of_types)
VALUES (2, 41);
---- CREATE AIRPLANE_TYPE
INSERT INTO AIRPLANE_TYPE(airplane_type_name, max_seats, company_id)
VALUES ('754S', 112, 2);
---- CREATE AIRPORT
INSERT INTO AIRPORT(airport_code, name, city)
VALUES ('SAW', 'SABİHA GÖKÇEN HAVALİMANI', 'İSTANBUL');
INSERT INTO AIRPORT(airport_code, name, city)
VALUES ('ADB', 'Adnan Menderes Havalimanı', 'İZMİR');
---- CREATE CAN_LAND
INSERT INTO CAN_LAND(airplane_type_name, airport_code)
VALUES ('754S', 'SAW');
---- CREATE AIRPLANE
INSERT INTO AIRPLANE(
        company_id,
        total_number_of_seats,
        airplane_type
    )
VALUES (4952, 500, '787');
---- CREATE FLIGHT_LEG
INSERT INTO FLIGHT_LEG(
        flight_number,
        leg_number,
        departure_airport_code,
        arrival_airport_code,
        flight_mile,
        scheduled_departure_time,
        scheduled_arrival_time
    )
VALUES (
        23,
        1,
        'SAW',
        'SAW',
        120,
        '2017-02-14',
        '2017-03-14'
    );
INSERT INTO FLIGHT_LEG(
        flight_number,
        leg_number,
        departure_airport_code,
        arrival_airport_code,
        flight_mile,
        scheduled_departure_time,
        scheduled_arrival_time
    )
VALUES (
        24,
        1,
        'SAW',
        'SAW',
        120,
        '2017-02-14',
        '2017-03-14'
    );
INSERT INTO FLIGHT_LEG(
        flight_number,
        leg_number,
        departure_airport_code,
        arrival_airport_code,
        flight_mile,
        scheduled_departure_time,
        scheduled_arrival_time
    )
VALUES (
        34,
        1,
        'SAW',
        'SAW',
        120,
        '2017-02-14',
        '2017-03-14'
    );
---- CREATE LEG_INSTANCE
INSERT INTO LEG_INSTANCE(
        flight_number,
        leg_number,
        date,
        number_of_avaliable_seats,
        airplane_id,
        departure_airport_code,
        arrival_airport_code,
        departure_time,
        arrival_time
    )
VALUES (
        24,
        1,
        '2017-03-14',
        112,
        1,
        'SAW',
        'ADB',
        '2017-03-14',
        '2017-03-14'
    );
INSERT INTO LEG_INSTANCE(
        flight_number,
        leg_number,
        date,
        number_of_avaliable_seats,
        airplane_id,
        departure_airport_code,
        arrival_airport_code,
        departure_time,
        arrival_time
    )
VALUES (
        6,
        1,
        '2020-10-06',
        112,
        1,
        'SAW',
        'ADB',
        '2020-10-06 00:25:00+03',
        '2020-10-06 06:25:00+03'
    );
INSERT INTO LEG_INSTANCE(
        flight_number,
        leg_number,
        date,
        number_of_avaliable_seats,
        airplane_id,
        departure_airport_code,
        arrival_airport_code,
        departure_time,
        arrival_time
    )
VALUES (
        34,
        1,
        '2017-05-14',
        112,
        2,
        'ADB',
        'SAW',
        '2017-03-14',
        '2017-03-14'
    );
---- CREATE CUSTOMER
INSERT INTO CUSTOMER(
        name,
        passport_number,
        email,
        address,
        country,
        phone
    )
VALUES (
        'Fatih Cüre',
        '123123122',
        'curefat@gmail.com',
        '123 sk. IZMIR',
        'TR',
        '312123'
    );
INSERT INTO CUSTOMER(
        name,
        passport_number,
        email,
        address,
        country,
        phone
    )
VALUES (
        'Mehmet Enes Kaplan',
        '123123123',
        'meneskaplan@gmail.com',
        '123 sk. IZMIR',
        'TR',
        '312124'
    );
INSERT INTO CUSTOMER(
        name,
        passport_number,
        email,
        address,
        country,
        phone
    )
VALUES (
        'Selami Özkan',
        '123123135',
        'selamo@gmail.com',
        '123 sk. IZMIR',
        'TR',
        '3332123'
    );
---- CREATE SEAT_RESERVATION
INSERT INTO SEAT_RESERVATION(
        flight_number,
        leg_number,
        date,
        customer_pn,
        fare_code,
        seat_number,
        reservation_number
    )
VALUES (
        24,
        1,
        '2017-03-14',
        '123123122',
        'AVANTAJ',
        12,
        1232
    );
INSERT INTO SEAT_RESERVATION(
        flight_number,
        leg_number,
        date,
        customer_pn,
        fare_code,
        seat_number,
        reservation_number
    )
VALUES (
        24,
        1,
        '2017-03-14',
        '123123123',
        'SUPER_EKO',
        12,
        1232
    );
INSERT INTO SEAT_RESERVATION(
        flight_number,
        leg_number,
        date,
        customer_pn,
        fare_code,
        seat_number,
        reservation_number
    )
VALUES (
        23,
        1,
        '2017-04-24',
        '123123123',
        'SUPER_EKO',
        12,
        1232
    );
INSERT INTO SEAT_RESERVATION(
        flight_number,
        leg_number,
        date,
        customer_pn,
        fare_code,
        seat_number,
        reservation_number
    )
VALUES (
        23,
        1,
        '2017-02-24',
        '123123123',
        'SUPER_EKO',
        12,
        1232
    );
INSERT INTO SEAT_RESERVATION(
        flight_number,
        leg_number,
        date,
        customer_pn,
        fare_code,
        seat_number,
        reservation_number
    )
VALUES (
        23,
        1,
        '2017-02-24',
        '123123122',
        'SUPER_EKO',
        12,
        1232
    );
---- CREATE FFC
INSERT INTO FFC(customer_pn)
VALUES ('123123123');
INSERT INTO FFC(customer_pn)
VALUES ('123123135');
---- UPDATE SEAT_RESERVATION
-- FFC 
UPDATE SEAT_RESERVATION
SET Checked_in = 't'
WHERE flight_number = 24
    AND leg_number = 1
    AND date = '2017-03-14'
    AND customer_pn = '123123123'
    AND reservation_number = 1232;
-- NOT FFC
UPDATE SEAT_RESERVATION
SET Checked_in = 'f'
WHERE flight_number = 23
    AND leg_number = 1
    AND date = '2017-03-14'
    AND customer_pn = '123123122'
    AND reservation_number = 1232;
--
UPDATE SEAT_RESERVATION
SET Checked_in = 'f'
WHERE flight_number = 23
    AND leg_number = 1
    AND date = '2017-03-14'
    AND customer_pn = '123123122'
    AND reservation_number = 1232;
-- CREATE FFC_ACTIVITY
INSERT INTO FFC_ACTIVITY(
        customer_pn,
        flight_number,
        leg_number,
        date,
        reservation_number,
        ffc_activity_number
    )
VALUES (
        '123123123',
        23,
        1,
        '2017-03-14',
        1232,
        1
    );
---- CREATE AIRPLANE_TYPE
INSERT INTO AIRPLANE_TYPE(airplane_type_name, max_seats, company_id)
VALUES ('754M', 112, 2);
---- CREATE AIRPLANE
INSERT INTO AIRPLANE(
        airplane_id,
        total_number_of_seats,
        airplane_type
    )
VALUES (3, 113, '754M');
---- CREATE LEG_INSTANCE
INSERT INTO LEG_INSTANCE(
        flight_number,
        leg_number,
        date,
        number_of_avaliable_seats,
        airplane_id,
        departure_airport_code,
        arrival_airport_code,
        departure_time,
        arrival_time
    )
VALUES (
        23,
        1,
        '2017-02-24',
        1,
        2,
        'SAW',
        'SAW',
        '2017-03-14',
        '2017-03-14'
    );
---- CREATE SEAT_RESERVATION
INSERT INTO SEAT_RESERVATION(
        flight_number,
        leg_number,
        date,
        customer_pn,
        fare_code,
        seat_number,
        reservation_number
    )
VALUES (
        23,
        1,
        '2017-03-14',
        '123123122',
        'BUSINESS_FLEX',
        12,
        1232
    );
---- CREATE RESTRICTION
INSERT INTO Fare(
        Fare_code,
        flight_number,
        amount,
        Treat,
        Luggage_limit
    )
VALUES ('BUSINESS_FLEX', 23, 200, 't', 25);
--
INSERT INTO Fare(
        Fare_code,
        flight_number,
        amount,
        Treat,
        Luggage_limit
    )
VALUES ('AVANTAJ', 24, 150, 't', 15);
--
INSERT INTO SEAT_RESERVATION(
        flight_number,
        leg_number,
        date,
        customer_pn,
        fare_code,
        seat_number,
        reservation_number
    )
VALUES (
        23,
        1,
        '2017-03-14',
        '123123123',
        'BUSINESS_FLEX',
        12,
        1232
    );