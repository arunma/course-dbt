{{ config(materialized='table') }}

with addresses as (
  select
    address_id,
    address,
    zipcode,
    state,
    country
  from {{ source('src_postgres', 'addresses') }}
)

select * from addresses