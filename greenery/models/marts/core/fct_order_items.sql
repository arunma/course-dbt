{{ config (
      materialized='table',
      unique_key="user_id ||'-'||product_id"
    ) 
}}

WITH order_items AS
(
	SELECT  order_id
	       ,product_id
	       ,quantity
	FROM {{ ref('stg_order_items') }}
)

SELECT * FROM order_items
