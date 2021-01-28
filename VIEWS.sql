-- havalimanı ekranlarındakine benzer bilgileri içerecek bir view.
-- kalkacak/inecek uçuşlar 
CREATE VIEW SAW_MONITOR(Flight, Leg, Departs_from, Depart_time, Arrival_to, Arrival_time) AS
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
-- check in görevlileri için check in listesi
CREATE VIEW CHECKIN_TABLE(Customer_name, PN, Is_checked_in) AS
SELECT
    C.Name,
    C.Passport_number,
    SR.Checked_in
FROM SEAT_RESERVATION AS SR,
    CUSTOMER AS C
WHERE SR.Flight_number = 23
    AND C.Passport_number = SR.Customer_PN
    AND SR.Leg_number = 1
    AND SR.Date = '2017-03-14';