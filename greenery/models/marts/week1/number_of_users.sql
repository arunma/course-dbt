WITH user_count AS (
  SELECT 
    count(user_id) as ucount
  FROM
    {{ ref ('users') }}
)

SELECT * FROM user_count
