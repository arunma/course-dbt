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