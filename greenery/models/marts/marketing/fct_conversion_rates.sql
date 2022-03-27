WITH product_page_view AS
(
  {{ get_product_event_type_counts('page_view') }}
), 

order_count AS
(
	SELECT  product_id
	       ,COUNT(order_id) ocount
	FROM {{ ref ('fct_order_items') }}
	GROUP BY  1
), 

product_info AS
(
	SELECT  *
	FROM {{ ref ('dim_products') }}
)

SELECT  i.name
       ,ROUND(o.ocount::numeric/p.page_view,2)*100 AS conversion_rate
       ,o.product_id
       ,o.ocount as order_count
       ,p.page_view
FROM order_count o
JOIN product_page_view p
ON o.product_id=p.product_id
JOIN product_info i
ON i.product_id=o.product_id