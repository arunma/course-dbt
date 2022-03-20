{{ config (
      unique_key='id'
    ) 
}}

WITH superheroes AS
(
	SELECT  id AS superhero_id
	       ,name
	       ,gender
	       ,eye_color
	       ,race
	       ,hair_color
	       ,height
	       ,publisher
	       ,skin_color
	       ,alignment
	       ,weight
	       ,created_at
	       ,updated_at
	FROM {{ source ('src_postgres', 'superheroes') }}
)
SELECT * FROM superheroes
