{% test accepted_values_or_null(model, column_name, values) %}


with validation as (

    select
        {{ column_name }} as check_field

    from {{ model }}

),

validation_errors as (

    select
        check_field
    from validation
    where check_field is not null and check_field not in {{values}}

)

select * from validation_errors

{% endtest %}