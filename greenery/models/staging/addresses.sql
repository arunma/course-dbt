{{ config (
      materialized='table',
      unique_key='address_id'
    ) 
}}

WITH addresses AS (
  SELECT
    address_id,
    address,
    zipcode,
    state,
    country
  FROM {{ source('src_postgres', 'addresses') }}
)

SELECT * FROM addresses