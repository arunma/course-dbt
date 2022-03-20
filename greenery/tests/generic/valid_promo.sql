{% test valid_promo (model, column_name) %}

  select {{ column_name }}
  from {{ ref ('dim_promos') }}
  where promo_id='{{ column_name }}' and status='active'

{% endtest %}