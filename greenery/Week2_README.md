## Question 1: What is our user repeat rate?

```SQL


WITH user_order_count AS
(
	SELECT  user_id
	       ,COUNT(order_id) order_count
	FROM {{ ref ('fct_orders') }}
	GROUP BY  user_id
)
SELECT  ROUND(
          COUNT(
            CASE WHEN order_count>1 THEN 1 else null end 
          )::numeric /COUNT(*) *100
        , 2)
FROM user_order_count

```
### Answer: 79.84

---

## Question 2: Good indicators of a user who will likely purchase again

```SQL




WITH order_stats AS
(
	SELECT  user_id
	       ,COUNT(order_id)         AS order_count
	       ,ROUND(SUM(order_total)) AS order_total
	       ,ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP	(ORDER BY order_total)) AS median_order_cost
         ,COUNT(case when (extract (epoch from delivered_at-estimated_delivery_at)/60)>0 then 1 else null end)  as delay_count
         ,COUNT(case when shipping_service='usps' then 1 else null end)  as usps
         ,COUNT(case when shipping_service='fedex' then 1 else null end)  as fedex
         ,COUNT(case when shipping_service='ups' then 1 else null end)  as ups
         ,COUNT(case when shipping_service='dhl' then 1 else null end)  as dhl
         ,avg((shipping_cost/order_total)*100) as shipping_pct
	FROM orders
	GROUP BY  user_id
	order by order_count desc
), page_view_stats AS
(
	SELECT  user_id
	       ,COUNT(user_id) page_count
	FROM dbt_arun_m.fct_page_views
	GROUP BY  user_id
)
SELECT  (case WHEN o.order_count>1 THEN 'REPEAT' else 'ONE-OFF' end) AS repeat_user
       ,SUM(o.order_count)                                          AS tot_order_count
       ,ROUND(AVG(o.order_total))                                    AS avg_order_total
       ,ROUND(AVG(p.page_count))                                     AS avg_page_view_count
       ,ROUND(AVG(o.delay_count))                                    AS delay_count
       ,ROUND(AVG(o.shipping_pct))                                   AS shipping_pct
       ,SUM(usps) as usps
       ,SUM(fedex) as fedex
       ,SUM(ups) as ups
       ,SUM(dhl) as dhl
FROM order_stats o
JOIN page_view_stats p
ON p.user_id=o.user_id
GROUP BY  repeat_user

-- FIRST ORDER STATS

WITH user_count AS
(
	SELECT  user_id
	       ,COUNT(order_id) order_count
	FROM orders
	GROUP BY  user_id
), repeat_user AS
(
	SELECT  user_id
	       ,CASE WHEN order_count>1 THEN 'REPEAT'  ELSE 'ONE-OFF' END AS repeat_user
	FROM user_count
), first_purchase_order AS
(
	SELECT  *
	FROM
	(
		SELECT  user_id
		       ,order_id
		       ,ROW_NUMBER() OVER (partition by user_id ORDER BY created_at) AS order_num
		FROM orders
	) AS first_orders
	WHERE order_num=1 
), first_order_features AS
(
	SELECT  repeat_user
	       ,order_total
	       ,CASE WHEN (extract (epoch	FROM delivered_at-estimated_delivery_at)/60)>0 THEN 1 else null end AS delayed 
         ,CASE WHEN shipping_service='usps' THEN 1 else null end AS usps 
         ,CASE WHEN shipping_service='fedex' THEN 1 else null end AS fedex 
         ,CASE WHEN shipping_service='ups' THEN 1 else null end AS ups 
         ,CASE WHEN shipping_service='dhl' THEN 1 else null end AS dhl 
         ,CASE WHEN promo_id is null THEN null else 1 end AS promo_used
	FROM orders o
	JOIN first_purchase_order f
	ON o.order_id=f.order_id
	JOIN repeat_user r
	ON f.user_id=r.user_id
), consolidated_stats AS
(
	SELECT  AVG(order_total)
	       ,repeat_user
	       ,COUNT(delayed) delayed_count
	       ,COUNT(usps) usps_count
	       ,COUNT(fedex) fedex_count
	       ,COUNT(ups) ups_count
	       ,COUNT(dhl) dhl_count
	       ,COUNT(promo_used) promo_used_count
	FROM first_order_features
	GROUP BY  repeat_user
)
SELECT  *
FROM consolidated_stats

```

### Answer: 

**avg**|**repeat_user**|**delayed_count**|**usps_count**|**fedex_count**|**ups_count**|**dhl_count**|**promo_used_count**
:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:
274.4840005493164|ONE-OFF|15|6|7|11|1|1
232.9149485116053|REPEAT|45|14|28|48|4|13

Some of the indicators that could be used to identify repeat users are: 

1. Number of pages that the user browses in the website
2. Average amount that the user spent
3. Usage of promos in teh first order

Neither shipping costs nor the carrier has any effect on the user conversion.

---

## Question 3: If you had more data, what features would you want to look into to answer this question?

### Answer:

1. Category of products that was bought
2. Age, Gender, Location of the customer
3. Medium of interaction - Web vs Mobile

---

## Question 4: Explain the marts models you added. Why did you organize the models in the way you did?

### Answer:

There are three marts that has been added - core, marketing and product.  

The `core` models are mostly materialized tables of the staging models with the exception of the `dim_user_addresses` model which joins both users and addresses.

The `marketing` mart has a `fct_user_orders` model which materialized the join between users and orders. 

Finally, the `fct_page_views` model of the `product` mart materializes the user and page_views events. 

These derived models are created to enable faster analysis.

---


## Question 5: What assumptions are you making about each model? 

### Answer: 

An user just has one address. This is especially important since `dim_user_addresses` relies on that.

---

## Question 6: Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?

### Answer

1. `estimated_delivery_time` was null in 19 rows for the `delivered` status

```SQL
SELECT  *
FROM orders
WHERE (order_cost is null or shipping_cost is null or tracking_id is null or shipping_service is null or estimated_delivery_at is null or delivered_at is null)
AND status='delivered';
```

2. The promo_id does not have a consistent naming - it has lowercase with dashes and spaces and init case.  Also, the promos are mostly inactive while the orders still use those codes.

3. There are 34 instances of users sharing the same address

```SQL
SELECT  address_id
       ,COUNT(address_id)
FROM dbt_arun_m.dim_users_addresses
GROUP BY  address_id
ORDER BY 2 desc

```

---

## Question 7: Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

### Answer: 

Adding data tests as a task in the Ingestion pipeline after the DBT models are run would fail the pipeline.  Alerts could be configured for pipeline failures.

---
