{% macro get_product_event_type_counts (event_type) %}

	SELECT  product_id
	       ,SUM(case WHEN event_type='{{ event_type }}' THEN 1 else 0 end)   AS {{ event_type }}
	FROM {{ ref ('fct_events') }}
	WHERE product_id is not null
	GROUP BY  1

{% endmacro %}