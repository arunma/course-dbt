## Question 1: How many users do we have?

```SQL

WITH user_count AS (
  SELECT 
    count(user_id) as ucount
  FROM
    {{ ref ('users') }}
)

SELECT * FROM user_count

```
### Answer: 130 

---

## Question 2: On average, how many orders do we receive per hour?

```SQL

WITH orders_per_hour AS (
  SELECT
    date(created_at) AS order_date,
    date_part('hour', created_at) order_hour,
    count(order_id) order_count
  FROM 
    {{ ref ('orders') }}
  GROUP BY 1,2
),
average_orders_per_hour AS (
  SELECT 
    ROUND(AVG(order_count), 2) AS avg_ord_per_hour
  FROM
    orders_per_hour
) 

SELECT avg_ord_per_hour FROM average_orders_per_hour

```

### Answer: 7.52 

---

## Question 3: On average, how long does an order take from being placed to being delivered?

```SQL
WITH delivery_times AS (
  SELECT
    delivered_at-created_at as dtime
  FROM
    {{ ref ('orders') }}
  WHERE
    status='delivered'
),
average_delivery_time AS (
  SELECT
    AVG (dtime) as average_delivery_time
  FROM
    delivery_times
)

SELECT * FROM average_delivery_time
```
### Answer: 3 days 21 hours 25 minutes (rounded)

---

## Question 4: How many users many 1 purchase? 2 purchases? 3 or more?

```SQL

WITH user_order_counts AS (
  SELECT 
    user_id,
    count(distinct order_id) order_count
  FROM
    {{ ref ('orders') }}
  GROUP BY 1
),
bucketed_users AS (
  SELECT
    SUM(CASE WHEN order_count=1 THEN 1 ELSE 0 END) as "1",
    SUM(CASE WHEN order_count=2 THEN 1 ELSE 0 END) as "2",
    SUM(CASE WHEN order_count>2 THEN 1 ELSE 0 END) as "3+"
  FROM 
    user_order_counts
)

SELECT * FROM bucketed_users

```

### Answer:  
```
 1  | 2  | 3+ 
----+----+----
 25 | 28 | 71
```

---


## Question 5: How many unique sessions do we have per hour

```SQL
WITH session_counts AS (
  SELECT 
    date(created_at) session_date,
    date_part('hour', created_at) AS session_hour,
    count(distinct session_id) AS session_count
  FROM 
    {{ ref ('events') }}
  GROUP BY 1,2
),
average_sessions_per_hour AS (
  SELECT
    ROUND(AVG(session_count),2) AS avg_session_count
  FROM
    session_counts
)

SELECT * FROM average_sessions_per_hour
```
### Answer: 16.33

---
---

# Self Review

---

## Part 2: Were you able to create schema.yml files with model names and descriptions? 

### Answer: Yes

---

## Part 2: Were you able to run your dbt models against the data warehouse? 

### Answer: Yes

---

## Part 3: Could you run the queries to answer key questions from the project instructions? 

### Answer: Yes

---