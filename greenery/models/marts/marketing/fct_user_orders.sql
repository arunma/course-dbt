{{ config (
    materialized='table'
  )
}}

WITH users_addresses AS
(
	SELECT user_id
				,first_name
				,last_name
				,full_name
				,email
				,phone_number
				,user_created_at
				,user_updated_at
				,address_id
				,address
				,zipcode
				,state
				,country
	FROM {{ ref	('dim_users_addresses') }}
), 

orders AS
(
	SELECT  order_id
	       ,user_id
	       ,promo_id
	       ,address_id
	       ,created_at
	       ,order_cost
	       ,shipping_cost
	       ,order_total
	       ,tracking_id
	       ,shipping_service
	       ,estimated_delivery_at
	       ,delivered_at
	       ,status
	FROM {{ ref	('fct_orders') }}
), 

user_address_orders AS
(
	SELECT  u.user_id
	       ,u.full_name
	       ,u.email
	       ,u.phone_number
				 ,user_created_at
				 ,user_updated_at
	       ,u.address_id
	       ,u.address
	       ,u.zipcode
	       ,u.state
	       ,u.country
	       ,o.order_id
	       ,o.promo_id
	       ,o.created_at
	       ,o.order_cost
	       ,o.shipping_cost
	       ,o.order_total
	       ,o.tracking_id
	       ,o.shipping_service
	       ,o.estimated_delivery_at
	       ,o.delivered_at
	       ,o.status
	FROM users_addresses AS u
	JOIN orders AS o
	ON o.user_id=u.user_id
)

SELECT  * FROM user_address_orders