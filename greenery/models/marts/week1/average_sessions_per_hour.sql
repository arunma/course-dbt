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