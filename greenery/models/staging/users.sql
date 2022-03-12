{{ config (materialized='table') }}

with users as (
  select
    user_id,
    first_name,
    last_name,
    email,
    phone_number,
    created_at,
    updated_at,
    address_id
  from {{ source ('src_postgres', 'users') }}
)

select * from users
