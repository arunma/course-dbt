{{ config (
      unique_key='order_id'
    ) 
}}

WITH orders AS
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
	FROM {{ source('src_postgres', 'orders') }}
)

SELECT * FROM orders