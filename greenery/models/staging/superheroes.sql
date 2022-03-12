{{ config (materialized='table') }}

with superheroes as (
  select
    id,
    name,
    gender,
    eye_color,
    race,
    hair_color,
    height,
    publisher,
    skin_color,
    alignment,
    weight,
    created_at,
    updated_at
  from {{ source ('src_postgres', 'superheroes') }}
)

select * from superheroes
