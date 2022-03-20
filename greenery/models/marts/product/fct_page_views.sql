{{ config (
    materialized='table'
  )
}}
WITH page_views AS
(
	SELECT  u.user_id
	       ,u.full_name
	       ,u.email
	       ,u.phone_number
	       ,e.session_id
	       ,e.page_url
	       ,e.created_at
	       ,e.event_type
	       ,e.order_id
	       ,e.product_id
	FROM {{ ref ('fct_events') }} AS e
	JOIN {{ ref ('dim_users_addresses') }} AS u
	ON u.user_id=e.user_id
	WHERE e.event_type='page_view' 
)
SELECT  * FROM page_views