{{ config (
      materialized='table',
      unique_key='event_id'
    ) 
}}

WITH events AS
(
	SELECT  event_id
	       ,session_id
	       ,user_id
	       ,page_url
	       ,created_at
	       ,event_type
	       ,order_id
	       ,product_id
	FROM {{ ref ('stg_events') }}
)
SELECT  * FROM events