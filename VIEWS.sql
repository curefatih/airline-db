-- havalimanı ekranlarındakine benzer bilgileri içerecek bir view.
-- kalkacak/inecek uçuşlar 
CREATE VIEW SAW_MONITOR(
    Flight,
    Leg,
    Departs_from,
    Depart_time,
    Arrival_to,
    Arrival_time
) AS
SELECT flight_number,
    leg_number,
    Departure_airport_code,
    scheduled_departure_time,
    arrival_airport_code,
    scheduled_arrival_time
FROM FLIGHT_LEG AS FL
WHERE Departure_airport_code = 'SAW'
    OR Arrival_airport_code = 'SAW'
ORDER BY departure_airport_code ASC;
-- check in görevlileri için check in yapılacakların listesi
CREATE VIEW CHECKIN_TABLE(Customer_name, PN, Is_checked_in) AS
SELECT C.Name,
    C.Passport_number,
    SR.Checked_in
FROM SEAT_RESERVATION AS SR,
    CUSTOMER AS C
WHERE SR.Flight_number = 23
    AND C.Passport_number = SR.Customer_PN
    AND SR.Leg_number = 1
    AND SR.Date = '2017-03-14';
-- business flex ile uçan ayrıcalıklı müşterilerin listesi. Havalimanı özelinde
---- örnek: select * from business_lounge where flightnum = 23 and date = '2017-03-14';
CREATE VIEW BUSINESS_LOUNGE_ADB(Customer_name, PN, FlightNum, Date, Code) AS
SELECT C.Name,
    C.Passport_number,
    SR.Flight_number,
    LI.Date,
    LI.Departure_airport_code
FROM SEAT_RESERVATION AS SR,
    CUSTOMER AS C,
    LEG_INSTANCE AS LI
WHERE SR.Fare_code = 'BUSINESS_FLEX'
    AND C.Passport_number = SR.Customer_PN
    AND SR.Leg_number = LI.Leg_number
    AND LI.Departure_airport_code = 'ADB';
-- kule için gerekli bilgilerin sağlandığı view
CREATE VIEW TOWER_SAW(
    Date,
    LegNum,
    FlightNum,
    Airplane,
    Scheduled_departure,
    Scheduled_arrival,
    Actual_departure_time,
    Actual_arrival_time
) AS
SELECT LI.Date,
    FL.Leg_number,
    FL.Flight_number,
    A.Airplane_type,
    FL.Scheduled_departure_time,
    FL.Scheduled_arrival_time,
    LI.Departure_time,
    LI.Arrival_time
FROM LEG_INSTANCE AS LI
    LEFT JOIN FLIGHT_LEG FL ON LI.Flight_number = FL.Flight_number
    LEFT JOIN AIRPLANE A ON LI.Airplane_id = A.Airplane_id
WHERE FL.Departure_airport_code = 'SAW'
    OR FL.Arrival_airport_code = 'SAW';
-- iş analistleri için rezervasyon bilgileri
CREATE VIEW BUSINESS_ANALYSIS(
    FlightNum,
    Legnum,
    FlightDate,
    Departure,
    Arrival,
    Fare,
    Amount
) AS
SELECT FL.Flight_number,
    FL.Leg_number,
    SR.Date,
    FL.Departure_airport_code,
    FL.Arrival_airport_code,
    SR.Fare_code,
    F.Amount
FROM SEAT_RESERVATION AS SR,
    FARE AS F,
    FLIGHT_LEG AS FL
WHERE SR.Flight_number = F.Flight_number
    AND SR.Fare_code = F.Fare_code
    AND FL.Leg_number = SR.Leg_number
    AND FL.Flight_number = SR.Flight_number;