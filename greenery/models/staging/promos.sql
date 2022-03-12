{{ config (materialized='table') }}

with promos as (
  select
    promo_id,
    discount,
    status
  from {{ source ('src_postgres', 'promos') }}
)

select * from promos
