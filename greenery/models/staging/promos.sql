{{ config (
      materialized='table',
      unique_key='promo_id'
    ) 
}}

WITH promos AS (
  SELECT
    promo_id,
    discount,
    status
  FROM {{ source ('src_postgres', 'promos') }}
)

SELECT * FROM promos
