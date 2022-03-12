with average_orders as (
  select 
    count(order_id) order_count, 
    extract(hour from created_at) order_hour 
  from 
  {{ source ('src_postgres', 'orders') }}
  group by order_hour
)

select * from average_orders