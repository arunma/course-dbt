{% test not_null_for_delivered (model, column_name) %}

with validation as (

    select
          {{ column_name }} as check_field
        , status

    from {{ model }}

),

validation_errors as (

    select
        check_field
    from validation
    where check_field is null and status='delivered'

)

select * from validation_errors

{% endtest %}