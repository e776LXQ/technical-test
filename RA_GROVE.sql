/* DUMP SQLITE GROVE CUSTOMER QUERY RESULTS INTO A CSV FILE */

.headers on
.mode csv
.output data_rob.csv

SELECT
customer_id,
order_number,
shipment_date,
CAST(REPLACE(order_value,'$','') as float)  AS "ord_amt",
LAG(CAST(REPLACE(order_value,'$','') as float), 1, 0) OVER (
PARTITION BY customer_id
ORDER BY customer_id,shipment_date
) PreviousWeekTotal,
(CAST(REPLACE(order_value,'$','') as float) - LAG(CAST(REPLACE(order_value,'$','') as float), 1, 0) OVER (
PARTITION BY customer_id
ORDER BY customer_id,shipment_date
)) / LAG(CAST(REPLACE(order_value,'$','') as float), 1, 0) OVER (
PARTITION BY customer_id
ORDER BY customer_id,shipment_date
) * 100 PctChange
FROM orders
GROUP BY customer_id, shipment_date;
.quit
