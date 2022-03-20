{{ config (
      unique_key='product_id'
    ) 
}}

WITH products AS
(
	SELECT  product_id
	       ,name
	       ,price
	       ,inventory
	FROM {{ source('src_postgres', 'products') }}
)

SELECT * FROM products
