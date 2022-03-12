{{ config (
      materialized='table',
      unique_key='user_id'
    ) 
}}

WITH users AS (
  SELECT
    user_id,
    first_name,
    last_name,
    email,
    phone_number,
    created_at,
    updated_at,
    address_id
  FROM {{ source ('src_postgres', 'users') }}
)

SELECT * FROM users
