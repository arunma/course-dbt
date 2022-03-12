
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