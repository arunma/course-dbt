{{ config (
			materialized='table',
      unique_key='address_id'
    ) 
}}

WITH addresses AS
(
	SELECT  address_id
	       ,address
	       ,zipcode
	       ,state
	       ,country
	FROM {{ ref('stg_addresses') }}
)

SELECT * FROM addresses