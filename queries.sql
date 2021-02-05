---- EXISTS
-- FFC olan müşteriler.
SELECT *
FROM CUSTOMER
WHERE EXISTS (
        SELECT *
        FROM FFC
        WHERE FFC.Customer_PN = CUSTOMER.Passport_number
    );
---- NOT EXISTS
-- Müşteri olup henüz uçuş yapmamış olanlar.
SELECT *
FROM CUSTOMER
WHERE NOT EXISTS (
        SELECT *
        FROM SEAT_RESERVATION
        WHERE SEAT_RESERVATION.Customer_PN = CUSTOMER.Passport_number
    );
---- 2 Tables
-- Bir uçuşun yapıldığı ayaklar ve günler.
SELECT F.Flight_number,
    L.Leg_number,
    L.Date
FROM FLIGHT AS F,
    LEG_INSTANCE AS L
WHERE F.Flight_number = L.Flight_number
GROUP BY (F.Flight_number, L.Leg_number),
    L.Date;
-- Bir airporttan kalkması planlanmış uçuşlar
SELECT A.Airport_code,
    A.Name,
    FL.Flight_number,
    FL.Leg_number
FROM AIRPORT AS A,
    FLIGHT_LEG AS FL
WHERE FL.Departure_airport_code = A.Airport_code;
-- Belirli bir tarih aralığında belirli bir havalimanından kalkan/varan uçuşlar.
SELECT A.Airport_code,
    A.Name,
    LI.Departure_time,
    LI.Arrival_time,
    LI.Airplane_id,
    LI.Flight_number
FROM AIRPORT AS A,
    LEG_INSTANCE AS LI
WHERE '2017-02-10' < LI.Departure_time
    AND A.Airport_code = 'SAW'
    AND (
        LI.Departure_airport_code = 'SAW'
        OR LI.Arrival_airport_code = 'SAW'
    );
--
---- 3 Tables
-- Bir airplane_company'nin ürettiği uçak tipleri
SELECT AC.Company_ID,
    C.Name,
    ATY.Airplane_type_name
FROM AIRPLANE_COMPANY AS AC,
    COMPANY as C,
    AIRPLANE_TYPE AS ATY
WHERE AC.Company_ID = ATY.Company_ID
    AND C.Company_ID = AC.Company_ID;
-- Bir airline_company'nin sahip olduğu uçuşlar
SELECT AC.Company_ID,
    C.Name,
    F.Flight_number
FROM AIRLINE_COMPANY AS AC,
    COMPANY as C,
    FLIGHT AS F
WHERE AC.Company_ID = C.Company_ID
    AND F.Company_ID = AC.Company_ID;
-- Bir tarife pakitinin bir şirket tarafından uçuşlarda kaç kere izin verildiği.
SELECT FARE.Fare_code,
    C.Name,
    Count(FARE.Fare_code)
FROM FLIGHT AS F,
    FARE,
    COMPANY AS C,
    AIRLINE_COMPANY AS AC
WHERE C.Company_ID = AC.Company_ID
    AND AC.Company_ID = F.Company_ID
    AND FARE.Flight_number = F.Flight_number
GROUP BY FARE_CODE,
    C.name;
---- 4 Tables    
-- Bir paketin kaç kere kullanıldığı, şirket bazlı
SELECT FARE.Fare_code,
    C.Name,
    Count(*)
FROM SEAT_RESERVATION AS SR,
    AIRLINE_COMPANY AS AC,
    COMPANY AS C,
    FARE,
    FLIGHT AS F
WHERE AC.Company_ID = C.Company_ID
    AND AC.Company_ID = F.Company_ID
    AND F.Flight_number = SR.Flight_number
    AND SR.Fare_code = FARE.Fare_code
    AND F.Flight_number = FARE.Flight_number
GROUP BY FARE.Fare_code,
    C.name;
-- Bir uçak tipi bir havalimanına kaç kere kalkış/iniş yapmış
SELECT A.name,
    ATY.Airplane_type_name,
    Count(*)
FROM AIRPLANE_TYPE AS ATY,
    AIRPORT AS A,
    AIRPLANE AS AI,
    LEG_INSTANCE AS LI
WHERE (
        A.Airport_code = LI.Departure_airport_code
        OR A.Airport_code = LI.Arrival_airport_code
    )
    AND LI.Airplane_id = AI.Airplane_id
    AND AI.Airplane_type = ATY.Airplane_type_name
GROUP BY A.name,
    ATY.Airplane_type_name;
-- Bir airplane company'nin ürettiği uçakları hangi şirketler kullanıyor.
-- ? 
SELECT C.name AS URETEN,
    CX.name AS KULLANAN,
    COUNT(*) AS MIKTAR
FROM COMPANY AS C,
    COMPANY AS CX,
    AIRPLANE_COMPANY AS AC,
    AIRPLANE_TYPE AS ATY,
    AIRPLANE AS A,
    LEG_INSTANCE AS LI,
    AIRLINE_COMPANY AS AIC
WHERE AC.Company_ID = C.Company_ID
    AND AIC.Company_ID = CX.Company_ID
    AND AC.Company_ID = ATY.Company_ID
    AND ATY.Airplane_type_name = A.Airplane_type
    AND A.Airplane_id = LI.Airplane_id
    AND AIC.Company_ID = A.Company_ID
GROUP BY C.name,
    CX.name;
-- bir uçak tipi bir havayolu tarafından kaç defa kullanıldı.
-- Belirli bir uçuşta bagaj hakkı olan yolcular.
SELECT SR.Customer_PN,
    C.Name,
    R.*
FROM SEAT_RESERVATION AS SR,
    FARE AS R,
    CUSTOMER AS C
WHERE SR.Fare_code = R.Fare_code
    AND R.flight_number = SR.Flight_number
    AND SR.Flight_number = 24
    AND SR.Leg_number = 1
    AND R.Luggage_limit > 0
    AND SR.Customer_PN = C.Passport_number;
-- Bir uçuş için ne kadar yemek servisi yapılacak.
SELECT SR.Flight_number,
    SR.Leg_number,
    Count(*) as SERVICE_COUNT
FROM SEAT_RESERVATION AS SR,
    FARE AS R
WHERE SR.Flight_number = R.Flight_number
    AND SR.Fare_code = R.Fare_code
    AND R.treat = 'T'
GROUP BY SR.Flight_number,
    SR.Leg_number;
------ NESTED QUERIES
-- ffc olup rezervasyon yapanlara 10 puan ver.
UPDATE FFC
SET Point = Point + 10
FROM SEAT_RESERVATION
WHERE EXISTS(
        SELECT *
        FROM SEAT_RESERVATION
        WHERE FFC.Customer_pn = SEAT_RESERVATION.Customer_pn
    );
-- bir uçuşun belirli bir fiyat altında olan tarifleri ve uçuşlar.
SELECT *
FROM FLIGHT,
    (
        SELECT *
        FROM FARE
        WHERE FARE.Amount < 150
    ) AS F_LT_150
WHERE F_LT_150.Flight_number = FLIGHT.Flight_number;
---- belirli tipli ucakta yolculuk yapmis yolcularin listesi
SELECT DISTINCT c.name,
    s.customer_pn --verilerimiz tekrar ettigi icin 
FROM customer as c,
    seat_reservation as s
WHERE (s.leg_number, s.flight_number) IN (
        SELECT LI.leg_number,
            LI.flight_number
        FROM leg_instance as LI,
            Airplane as A
        WHERE LI.airplane_id = A.airplane_id
            and A.airplane_type = '754S'
    )
    AND S.Customer_PN = C.passport_number;
----Sabiha Gökçen havalimanına iniş yapmış yabancı vatandaşların listesi
SELECT DISTINCT c.name,
    s.customer_pn
FROM customer as c,
    seat_reservation as s
WHERE c.country != 'TR'
    AND S.Customer_PN = C.passport_number
    AND (s.leg_number, s.flight_number) IN (
        SELECT LI.leg_number,
            LI.flight_number
        FROM Leg_instance as LI
        WHERE LI.Arrival_airport_code = 'SAW'
    );
---SAW'dan ADB'ye olan ve bagaj secenegi olan uçuslar
SELECT DISTINCT f.flight_number
FROM flight_leg as f
WHERE f.Departure_airport_code = 'ADA'
    AND f.Arrival_airport_code = 'ESB'
    AND f.flight_number IN (
        SELECT flight_number
        FROM fare
        WHERE fare.luggage_limit > 0
            AND f.flight_number = fare.flight_number
    );
---- JOIN
-- LEFT JOIN:: havayolu şirketlerinin uçuşları.
SELECT ac.Company_ID,
    c.name,
    FL.Flight_number
FROM FLIGHT AS FL 
    LEFT JOIN AIRLINE_COMPANY AC ON AC.Company_ID = FL.Company_ID
    LEFT JOIN COMPANY C ON C.Company_ID = AC.Company_ID
GROUP BY ac.Company_ID,
    name,
    Flight_number;
-- RIGHT JOIN:: Uçak üretici firmaların bilgileri.
SELECT *
FROM COMPANY AS C
    RIGHT JOIN AIRPLANE_COMPANY AC ON C.Company_ID = AC.Company_ID;
-- FULL OUTER JOIN
SELECT DISTINCT C.*
FROM SEAT_RESERVATION AS SR
    FULL OUTER JOIN CUSTOMER C ON C.Passport_number = SR.Customer_PN;