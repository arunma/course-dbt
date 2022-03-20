{{ config (
      materialized='table',
      unique_key='product_id'
    ) 
}}

WITH products AS
(
	SELECT  product_id
	       ,name
	       ,price
	       ,inventory
	FROM {{ ref('stg_products') }}
)

SELECT * FROM products
