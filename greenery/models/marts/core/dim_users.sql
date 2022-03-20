{{ config (
      materialized='table',
      unique_key='user_id'
    ) 
}}

WITH users AS
(
	SELECT  user_id
	       ,first_name
	       ,last_name
         ,CONCAT (first_name, ' ', last_name) as full_name 
	       ,email
	       ,phone_number
	       ,created_at
	       ,updated_at
	       ,address_id
	FROM {{ ref('stg_users') }}
)

SELECT  * FROM users