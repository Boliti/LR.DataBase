/*Напишите функцию, которая будет рассчитывать увеличение/уменьшение стоимость аренды объекта 
на последующие месяцы  для изменения ( увеличения или уменьшения) срока окупаемость на заданную долю 
(в процентах) на основании расчета окупаемости за уже оплаченные периоды. Сохраните расчет в виде csv 
или sql файла (например, используя временные таблицы).*/
USE cd;
DELIMITER //
DROP FUNCTION IF EXISTS CalculateRentChange // 
CREATE FUNCTION CalculateRentChange(in_percentage_change DECIMAL(5,2))
RETURNS TEXT
DETERMINISTIC
BEGIN
    /*создаю временную таблицу*/
    CREATE TEMPORARY TABLE IF NOT EXISTS RentChange AS
    SELECT 
        bookings.facid,
        SUM(CASE 
                WHEN bookings.memid = 0 THEN facilities.guestcost * bookings.slots
                ELSE facilities.membercost * bookings.slots
            END) AS rent,
        SUM(payments.payment) - facilities.monthlymaintenance AS profit
    FROM bookings
    LEFT JOIN facilities ON bookings.facid = facilities.facid
    LEFT JOIN payments ON bookings.bookid = payments.bookid
    GROUP BY bookings.facid;
    /*расчитываю измен стоимости*/
    UPDATE RentChange 
    SET rent = 
        CASE 
            WHEN (profit <= 0 OR rent <= 0) THEN 0
            ELSE rent * (1 + in_percentage_change / 100)
        END;
    RETURN 'Изменение аренды расчитано и сохранено';
END//
DELIMITER ;
SELECT CalculateRentChange(10.54);
SELECT * FROM RentChange;