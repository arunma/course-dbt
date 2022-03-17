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