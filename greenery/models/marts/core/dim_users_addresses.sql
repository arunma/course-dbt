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
	FROM {{ ref('dim_users') }}
),

addresses AS
(
	SELECT  address_id
	       ,address
	       ,zipcode
	       ,state
	       ,country
	FROM {{ ref('dim_addresses') }}
),

joined AS 
(
	SELECT  u.user_id
				,u.first_name
				,u.last_name
				,u.full_name
				,u.email
				,u.phone_number
				,u.created_at AS user_created_at
				,u.updated_at AS user_updated_at
				,a.address_id
				,a.address
				,a.zipcode
				,a.state
				,a.country
	FROM users AS u
	JOIN addresses AS a
	ON u.address_id=a.address_id 
)

SELECT  * FROM joined