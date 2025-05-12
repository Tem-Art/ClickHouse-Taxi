-- ТОП-10 районов по количеству посадок.

SELECT pickup_ntaname, COUNT(*) AS trip_count
FROM nyc_taxi.trips_small
GROUP BY pickup_ntaname
ORDER BY trip_count DESC
LIMIT 10;

-------------------------------------------------------------------------------------------------------

-- Средняя продолжительность поездки по каждому часу суток.

SELECT toHour(pickup_datetime) AS hour, 
       AVG(toUnixTimestamp(dropoff_datetime) - toUnixTimestamp(pickup_datetime)) AS avg_duration_sec
FROM nyc_taxi.trips_small
GROUP BY hour
ORDER BY hour;

-------------------------------------------------------------------------------------------------------

-- Средний размер чаевых по типу оплаты.

SELECT payment_type, AVG(tip_amount) AS avg_tip
FROM nyc_taxi.trips_small
GROUP BY payment_type;

-------------------------------------------------------------------------------------------------------
	
-- Доля поездок, оплаченных наличными, по каждому району посадки.

SELECT 
    pickup_ntaname,
    COUNTIf(payment_type = 'CSH') AS cash_trips,
    COUNT(*) AS total_trips,
    round(100.0 * COUNTIf(payment_type = 'CSH') / COUNT(*), 2) AS percent_cash
FROM nyc_taxi.trips_small
GROUP BY pickup_ntaname
HAVING total_trips > 1000
ORDER BY percent_cash DESC;

-------------------------------------------------------------------------------------------------------	

-- Доля поездок с нулевыми чаевыми.

SELECT 
    COUNTIf(tip_amount = 0) * 100.0 / COUNT(*) AS zero_tip_percentage
FROM nyc_taxi.trips_small;

-------------------------------------------------------------------------------------------------------

-- Поездки, где чаевые больше 30% от стоимости поездки.

SELECT trip_id, pickup_datetime, fare_amount, tip_amount,
       round(100.0 * tip_amount / fare_amount, 2) AS tip_percent
FROM nyc_taxi.trips_small
WHERE fare_amount > 0 AND tip_amount / fare_amount > 0.3
ORDER BY tip_percent DESC
LIMIT 20;

-------------------------------------------------------------------------------------------------------

-- Средний чек поездки в будние и выходные.

SELECT 
    IF(toDayOfWeek(pickup_datetime) IN (6, 7), 'weekend', 'weekday') AS day_type,
    AVG(total_amount) AS avg_fare
FROM nyc_taxi.trips_small
GROUP BY day_type;

-------------------------------------------------------------------------------------------------------

-- Гистограмма распределения расстояний поездок.

SELECT intDiv(trip_distance, 1) AS distance_bin, COUNT(*) AS trips
FROM nyc_taxi.trips_small
GROUP BY distance_bin
ORDER BY distance_bin;

-------------------------------------------------------------------------------------------------------

-- Час с наибольшей выручкой по каждому дню.

WITH hourly_revenue AS (
    SELECT
        toDate(pickup_datetime) AS trip_date,
        toHour(pickup_datetime) AS trip_hour,
        SUM(total_amount) AS hourly_total,
        row_number() OVER (PARTITION BY toDate(pickup_datetime) ORDER BY SUM(total_amount) DESC) AS rn
    FROM nyc_taxi.trips_small
    GROUP BY trip_date, trip_hour
)
SELECT trip_date, trip_hour, hourly_total
FROM hourly_revenue
WHERE rn = 1
ORDER BY trip_date;

-------------------------------------------------------------------------------------------------------

-- Час с наибольшей выручкой по каждому дню.

SELECT 
    toDayOfWeek(pickup_datetime) AS weekday,
    round(AVG(toUnixTimestamp(dropoff_datetime) - toUnixTimestamp(pickup_datetime)) / 60, 2) AS avg_duration_min
FROM nyc_taxi.trips_small
GROUP BY weekday
ORDER BY weekday;

-------------------------------------------------------------------------------------------------------

-- Средняя продолжительность поездки по дням недели.

SELECT 
    toDayOfWeek(pickup_datetime) AS weekday,
    round(AVG(toUnixTimestamp(dropoff_datetime) - toUnixTimestamp(pickup_datetime)) / 60, 2) AS avg_duration_min
FROM nyc_taxi.trips_small
GROUP BY weekday
ORDER BY weekday;















