{{ config (
      unique_key="user_id ||'-'||product_id"
    ) 
}}

WITH order_items AS
(
	SELECT  order_id
	       ,product_id
	       ,quantity
	FROM {{ source('src_postgres', 'order_items') }}
)

SELECT * FROM order_items
