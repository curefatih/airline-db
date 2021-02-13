-- flight date 
CREATE OR REPLACE FUNCTION flight_date_check()
  RETURNS trigger AS
$$
BEGIN

    IF NOT EXISTS (
        SELECT 1 
        FROM FLIGHT_DAY AS FD,
        (SELECT extract(DOW FROM NEW.Scheduled_departure_time) AS Flight_day) AS DATES
        WHERE Flight_number = NEW.Flight_number
        AND DATES.Flight_day = FD.day 
    ) THEN
        RAISE NOTICE 'Flight day is not assigned to this flight number. Please check the flight_day table.';
        RETURN NULL;
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';
CREATE TRIGGER flight_date_check_triggger
  BEFORE INSERT OR UPDATE
  ON flight_leg
  FOR EACH ROW
  EXECUTE PROCEDURE flight_date_check();
--
--
--
/* INSERT QUERY NO: 1 */
INSERT INTO flight_leg(flight_number, departure_airport_code, arrival_airport_code, scheduled_departure_time, scheduled_arrival_time, flight_mile)
VALUES
(
45, 'AAL', 'BLL', '2021-01-11 09:33', '2020-10-09 15:33', 4029
);
--
--
DROP TRIGGER flight_date_check_triggger
ON FLIGHT_LEG;
DROP FUNCTION flight_date_check();

-- 
-- 
CREATE OR REPLACE FUNCTION create_ffc_activity() 
    RETURNS TRIGGER AS
$$
DECLARE
    ffc_pn SEAT_RESERVATION.customer_pn%type;
    fare_reward_ratio Fare_code.Reward_ratio%type;
    fare_amount Fare.Amount%type;
    already_exist FFC_ACTIVITY;
BEGIN 
    SELECT * FROM FFC
    INTO ffc_pn
    WHERE NEW.customer_pn = customer_pn;

    SELECT * FROM FFC_ACTIVITY
    INTO already_exist
    WHERE flight_number = NEW.flight_number
        AND leg_number = NEW.leg_number
        AND date = NEW.date
        AND customer_pn = NEW.customer_pn
        AND seat_number = NEW.seat_number;

    IF NEW.checked_in = 't' AND ffc_pn IS NOT NULL AND already_exist IS NULL
    THEN
        RAISE NOTICE 'FFC checked in. PN: %', ffc_pn;
        INSERT INTO FFC_ACTIVITY(
            customer_pn,
            flight_number,
            leg_number,
            fare_code,
            date,
            seat_number
        ) VALUES
        (
            NEW.customer_pn,
            NEW.flight_number,
            NEW.leg_number,
            NEW.fare_code,
            NEW.date,
            NEW.seat_number
        );

        ---- UPDATE POINT
        -- Find reward ratio
        SELECT Reward_ratio 
        FROM Fare_code
        INTO fare_reward_ratio 
        WHERE Fare_code.code = NEW.fare_code;
        -- find amount
        SELECT Amount 
        FROM Fare
        INTO fare_amount 
        WHERE Fare.fare_code = NEW.fare_code
        AND Fare.Flight_number = NEW.Flight_number;

        -- update ffc point
        UPDATE FFC
        SET Point = fare_amount * fare_reward_ratio
        WHERE FFC.Customer_PN = NEW.customer_pn; 

    END IF;
    RETURN NEW;
END
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER ffc_activity_trigger
    AFTER UPDATE
    ON SEAT_RESERVATION
    FOR EACH ROW
    EXECUTE PROCEDURE create_ffc_activity();
--
--
--
--
--
--
--
DROP TRIGGER ffc_activity_trigger
ON SEAT_RESERVATION;
DROP FUNCTION create_ffc_activity();
------------------------------------
--
--
--
--
--
--
CREATE OR REPLACE FUNCTION check_seat_consistence() 
    RETURNS TRIGGER AS
$$
DECLARE
    MAX_SEAT_COUNT AIRPLANE_TYPE.max_seats%type;
BEGIN 
    SELECT max_seats FROM AIRPLANE_TYPE
    INTO MAX_SEAT_COUNT
    WHERE NEW.airplane_type = AIRPLANE_TYPE.airplane_type_name;
    IF NEW.Total_number_of_seats > MAX_SEAT_COUNT
    THEN
       RAISE EXCEPTION 'Max seat cannot be greater then the airplane max seat count %', MAX_SEAT_COUNT;
    END IF;
    RETURN NEW;
END
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER check_airplane_seat_trigger
    BEFORE INSERT OR UPDATE
    ON AIRPLANE
    FOR EACH ROW
    EXECUTE PROCEDURE check_seat_consistence();
--
--
--
DROP TRIGGER check_airplane_seat_trigger
ON AIRPLANE;
DROP FUNCTION check_seat_consistence();
----------------------------------------
--
--
--
--
--
CREATE OR REPLACE FUNCTION check_avaliable_seat_consistence() 
    RETURNS TRIGGER AS
$$
DECLARE
    MAX_SEAT_COUNT AIRPLANE.total_number_of_seats%type;
BEGIN 
    SELECT total_number_of_seats FROM AIRPLANE
    INTO MAX_SEAT_COUNT
    WHERE AIRPLANE.Airplane_id = NEW.Airplane_id;
    IF  NEW.number_of_avaliable_seats > MAX_SEAT_COUNT 
    THEN
        RAISE EXCEPTION 'Avaliable seat cannot be greater then the airplane max avaliable seat count %', MAX_SEAT_COUNT;    
    END IF;
    RETURN NEW;
END
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER check_avaliable_seat_consistence_trigger
    BEFORE INSERT OR UPDATE
    ON LEG_INSTANCE
    FOR EACH ROW
    EXECUTE PROCEDURE check_avaliable_seat_consistence();
--
--
--
DROP TRIGGER check_avaliable_seat_consistence_trigger
ON LEG_INSTANCE;
DROP FUNCTION check_avaliable_seat_consistence();
-------------------------------------------------
--
--
--
--
--
CREATE OR REPLACE FUNCTION update_num_of_available_seats()
    RETURNS TRIGGER AS 
$$
DECLARE 
    LI LEG_INSTANCE;
BEGIN  


    SELECT * FROM LEG_INSTANCE
    INTO LI
    WHERE NEW.Leg_number = LEG_INSTANCE.Leg_number
    AND NEW.Flight_number = LEG_INSTANCE.Flight_number
    AND NEW.Date = LEG_INSTANCE.Date;

    IF LI.number_of_avaliable_seats < 1
    THEN
        RAISE EXCEPTION 'There is no seat avaliable!';
        RETURN NULL;
    END IF;
    
    IF NEW.Leg_number= LI.leg_number
    THEN 
        UPDATE LEG_INSTANCE 
        SET Number_of_avaliable_seats = Number_of_avaliable_seats-1
        WHERE NEW.Leg_number=LEG_INSTANCE.Leg_number 
        AND NEW.Date = LEG_INSTANCE.Date
        AND LEG_INSTANCE.flight_number = NEW.Flight_number;
        RAISE NOTICE 'New Reservation added !';
        END IF;
    RETURN NEW;
END 
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER update_num_of_available_seats_TRIGGER
    BEFORE INSERT
    ON SEAT_RESERVATION
    FOR EACH ROW
    EXECUTE PROCEDURE update_num_of_available_seats();

DROP TRIGGER update_num_of_available_seats_TRIGGER
ON SEAT_RESERVATION;
DROP FUNCTION update_num_of_available_seats();    

----------------------------------------
--bir havalimanına yalnızca izin verilen tipte uçaklar iniş yapabilir.
--
--
--
--
CREATE OR REPLACE FUNCTION airplane_type_can_land()
    RETURNS TRIGGER AS 
$$
DECLARE 
    NEW_AIRPLANE_TYPE  Airplane.Airplane_type%type;
    CAN_LAND_CHECK  Can_land;
BEGIN 
    SELECT airplane_type 
    FROM AIRPLANE
    INTO NEW_AIRPLANE_TYPE 
    WHERE NEW.airplane_id=AIRPLANE.airplane_id;
    
    SELECT * 
    FROM CAN_LAND 
    INTO CAN_LAND_CHECK 
    WHERE CAN_LAND.airplane_type_name = NEW_AIRPLANE_TYPE 
    AND CAN_LAND.airport_code = NEW.Arrival_airport_code;
   
    IF  CAN_LAND_CHECK IS NULL
    THEN 
        RAISE EXCEPTION 'This % type of plane cannot land % coded airport!', NEW_AIRPLANE_TYPE, NEW.arrival_airport_code;    
    END IF;
    RETURN NEW;
END
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER airplane_type_can_land_trigger
    BEFORE INSERT OR UPDATE
    ON LEG_INSTANCE
    FOR EACH ROW
    EXECUTE PROCEDURE airplane_type_can_land();
--
--
--
DROP TRIGGER airplane_type_can_land_trigger
ON LEG_INSTANCE;
DROP FUNCTION airplane_type_can_land();




-- CREATE OR REPLACE FUNCTION check_fare_seat_consistence() 
--     RETURNS TRIGGER AS
-- $$
-- DECLARE
--     SELECTED_FARE FARE%rowtype;
-- BEGIN 
--     SELECT * FROM FARE
--     INTO SELECTED_FARE
--     WHERE FARE.flight_number = NEW.flight_number
--     AND  FARE.fare_code = NEW.fare_code;

--     IF SELECTED_FARE IS NULL 
--     THEN
--      RAISE EXCEPTION 'Fare is not avaliable for this flight. Given fare code: %', NEW.fare_code;
--     END IF;
--     RETURN NEW;
-- END
-- $$
-- LANGUAGE PLPGSQL;

-- CREATE TRIGGER fare_seat_consistence_trigger
--     BEFORE INSERT OR UPDATE
--     ON SEAT_RESERVATION
--     FOR EACH ROW
--     EXECUTE PROCEDURE check_fare_seat_consistence();
-- --
-- --
-- --
-- DROP TRIGGER fare_seat_consistence_trigger
-- ON SEAT_RESERVATION;
-- DROP FUNCTION check_fare_seat_consistence();


