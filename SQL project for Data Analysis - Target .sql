# Import the dataset and perform usual exploratory data analysis steps like checking the structure & characteristics of dataset:
#1.Data type of all columns in the 'customers' table
#2.Get the time range between which orders were placed .

select * 
from `SQL_Target.customers`
LIMIT 5;

SELECT *
FROM `SQL_Target.geolocation`
LIMIT 5;

SELECT *
FROM `SQL_Target.order_items`
LIMIT 5;

SELECT *
FROM `SQL_Target.order_reviews`
LIMIT 5;

SELECT *
FROM `SQL_Target.orders_1`
LIMIT 5;

SELECT *
FROM `SQL_Target.payments`
LIMIT 5;

SELECT *
FROM `SQL_Target.products`
LIMIT 5;

SELECT *
FROM `SQL_Target.sellers`
LIMIT 5;

#Get the time range between which orders were placed .
SELECT 
min(order_purchase_timestamp)as start_time,
max(order_purchase_timestamp)as end_time
FROM `SQL_Target.orders_1`;


#3.Display the details -cities and states of customers who ordered during the given period.

SELECT 
c.customer_city, c.customer_state
FROM `SQL_Target.orders_1`as o
JOIN `SQL_Target.customers`as c
ON O.customer_id=C.customer_id
WHERE EXTRACT (YEAR from O.order_purchase_timestamp)= 2018
AND EXTRACT(MONTH FROM order_purchase_timestamp)BETWEEN 1 AND 3;

# Is there any growing trend in the no.of orders placed over the past years?

SELECT 
EXTRACT(month from order_purchase_timestamp)as month,
count(order_id) as Num_order
from `SQL_Target.orders_1`
GROUP BY EXTRACT(month from order_purchase_timestamp)
ORDER BY Num_order desc;

#During which of the day customers mostly place their orders?(Dawn,Morning,Afternoon or Night)
#0-6 hrs : dawn
#7-12 hrs : Morning
#13-18 hrs : Afternoon 
#19-23 hrs : Night

SELECT 
EXTRACT(hour from order_purchase_timestamp)as time,
count(order_id) as Num_order
from `SQL_Target.orders_1`
GROUP BY EXTRACT(hour from order_purchase_timestamp)
ORDER BY Num_order desc;

##Evolution of E-commerce orders in the brazil region :
#1.Get the month on month no.of orders placed.

SELECT
EXTRACT(month from order_purchase_timestamp)as month,
EXTRACT(year from order_purchase_timestamp)as year,
count(*)as num_orders
from `SQL_Target.orders_1`
GROUP BY year,month
ORDER BY year,month;

#2. Distribution of customers across the states of brazil.

SELECT customer_city,
customer_state ,count(distinct customer_id) as customer_count
FROM `SQL_Target.customers`
GROUP BY customer_city,customer_state
ORDER BY customer_count DESC;

# Get the % increase in the cost of orders from year 2017 - 2018 (include month between jan - aug only )
# we can use the 'payment_value' column in th epayments table to get the cost of orders.

#Step 1: calculate total payments per year .
WITH yearly_totals as(
SELECT 
EXTRACT(year from o.order_purchase_timestamp)as year,
SUM (p.payment_value) as total_payment
from `SQL_Target.payments`AS p
join `SQL_Target.orders_1`as o
ON p.order_id=o.order_id
WHERE EXTRACT(year from o.order_purchase_timestamp) IN(2017,2018)
AND EXTRACT(month from o.order_purchase_timestamp) BETWEEN 1 AND 8
GROUP BY EXTRACT(year from o.order_purchase_timestamp)
),

#Step 2:Use LEAD window function to compare each years's payments with the previous year 
yearly_comparisons AS (
SELECT 
year,
total_payment,LEAD(total_payment)over (order by year desc) as prev_year_payment
FROM yearly_totals)

#Step 3:Calculate % increase
SELECT round((total_payment - prev_year_payment)/prev_year_payment)*100
FROM yearly_comparisons;

# Mean & sum of price & freight value by customer state 

SELECT 
customer_state,
AVG (price) as AVG_price,
sum(price) AS sum_price,
AVG(freight_value)AS AVG_freight,
SUM(freight_value) AS sum_freight
FROM `SQL_Target.orders_1`AS o
JOIN `SQL_Target.order_items`as oi
ON o.order_id=oi.order_id
JOIN `SQL_Target.customers`as c
ON o.customer_id=c.customer_id
GROUP BY c.customer_state;

# Calculate days between purchasing , delivering & estimated delivery.

SELECT order_id,
DATE_DIFF(DATE(order_delivered_customer_date),DATE(order_purchase_timestamp),DAY)AS days_to_delivery,
DATE_DIFF(DATE(order_delivered_customer_date),DATE(order_estimated_delivery_date),DAY)AS diff_estimated_delivery
FROM `SQL_Target.orders_1`;

# Find out the top 5 states with highest and lowest average freight value.

SELECT 
c.customer_state,
AVG(freight_value) as avg_freight,
FROM `SQL_Target.orders_1`as o 
JOIN SQL_Target.order_items as oi
ON o.order_id = oi.order_id
JOIN `SQL_Target.customers` as c
ON o.customer_id=c.customer_id
GROUP BY customer_state
ORDER BY avg_freight DESC
LIMIT 5 ;

# Find out the top 5 states with highest and lowest average delivery time .
#HIGHEST

SELECT 
c.customer_state,
AVG(EXTRACT(DATE from o.order_delivered_customer_date)- extract (DATE from o.order_purchase_timestamp))as Avg_time_delivery
FROM `SQL_Target.orders_1`as o 
JOIN SQL_Target.order_items as oi
ON o.order_id = oi.order_id
JOIN `SQL_Target.customers` as c
ON o.customer_id=c.customer_id
GROUP BY customer_state
ORDER BY Avg_time_delivery DESC
LIMIT 5 ;

#LOWEST
SELECT 
c.customer_state,
AVG(EXTRACT(DATE from o.order_delivered_customer_date)- extract (DATE from o.order_purchase_timestamp))as Avg_time_delivery
FROM `SQL_Target.orders_1`as o 
JOIN SQL_Target.order_items as oi
ON o.order_id = oi.order_id
JOIN `SQL_Target.customers` as c
ON o.customer_id=c.customer_id
GROUP BY customer_state
ORDER BY Avg_time_delivery ASC
LIMIT 5 ;

# Find the month on month no.of orders placed using diffrent payment types .
SELECT 
payment_type,
EXTRACT(YEAR from order_purchase_timestamp)as YEAR ,
EXTRACT(MONTH from order_purchase_timestamp)as MONTH ,
COUNT(DISTINCT o.order_id) as order_count
FROM `SQL_Target.orders_1`as o 
INNER JOIN `SQL_Target.payments`as p
ON o.order_id=p.order_id
GROUP BY payment_type,YEAR ,MONTH
ORDER BY payment_type,YEAR ,MONTH;

#Count of orders based on the number of payment installments.

SELECT 
payment_installments,
COUNT(DISTINCT order_id)as NUM_orders
FROM `SQL_Target.payments`
GROUP BY payment_installments;

