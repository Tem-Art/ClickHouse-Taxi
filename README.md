# Цель

Исследовать географию спроса, динамику выручки, поведение пассажиров; 

оценить чаевые;

выявить пиковые часы;

рассчитать производственные метрики.

# Описание БД

**Название БД:** nyc_taxi

**Основная таблица:** trips_small

**Тип хранилища:** MergeTree (оптимизирована для аналитических запросов по временным диапазонам)

**Ключ сортировки:** (pickup_datetime, dropoff_datetime)


| Столбец | Тип данных | Описание |
| --- | --- | --- |
| `trip_id` | `UInt32` | Уникальный ID поездки |
| `pickup_datetime` | `DateTime` | Время посадки пассажира |
| `dropoff_datetime` | `DateTime` | Время высадки пассажира |
| `pickup_longitude` | `Nullable(Float64)` | Долгота точки посадки |
| `pickup_latitude` | `Nullable(Float64)` | Широта точки посадки |
| `dropoff_longitude` | `Nullable(Float64)` | Долгота точки высадки |
| `dropoff_latitude` | `Nullable(Float64)` | Широта точки высадки |
| `passenger_count` | `UInt8` | Количество пассажиров |
| `trip_distance` | `Float32` | Расстояние поездки (в милях) |
| `fare_amount` | `Float32` | Стоимость поездки без доп. сборов |
| `extra` | `Float32` | Дополнительные сборы (например, надбавки) |
| `tip_amount` | `Float32` | Сумма чаевых |
| `tolls_amount` | `Float32` | Сумма плат за проезд |
| `total_amount` | `Float32` | Общая сумма поездки |
| `payment_type` | `Enum` | Тип оплаты: CSH (нал), CRE (карта), NOC, DIS, UNK |
| `pickup_ntaname` | `LowCardinality(String)` | Район посадки (NTA — Neighborhood Tabulation Area) |
| `dropoff_ntaname` | `LowCardinality(String)` | Район высадки |
