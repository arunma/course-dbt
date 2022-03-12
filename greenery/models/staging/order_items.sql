{{ config (materialized='table') }}

with order_items as (
  select
    order_id,
    product_id,
    quantity
  from {{ source ('src_postgres', 'order_items') }}
)

select * from order_items
