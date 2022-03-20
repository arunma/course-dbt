{{ config (
			materialized='table',
      unique_key='promo_id'
    ) 
}}

WITH promos AS
(
	SELECT  promo_id
	       ,discount
	       ,status
	FROM {{ ref('stg_promos') }}
)
SELECT * FROM promos
