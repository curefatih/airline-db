UPDATE SEAT_RESERVATION
SET checked_in = 't'
WHERE Flight_number = 23
    AND Leg_number = 24
    AND Date = '2020-12-05 23:39:00+03'
    AND Customer_PN = '12-062-4319'
    AND Fare_code = 'BUSINESS_FLEX'
    AND Seat_number = 93;