{{ config (materialized='table') }}

with products as (
  select
    product_id,
    name,
    price,
    inventory
  from {{ source ('src_postgres', 'products') }}
)

select * from products
