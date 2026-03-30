--- Check missing value----

SELECT  COUNT(CASE WHEN transaction_date = 'ERROR' THEN 1 END) + COUNT(CASE WHEN transaction_date = 'UNKNOWN' THEN 1 END) + COUNT(CASE WHEN transaction_date = '' THEN 1 END) AS missing_transaction_date,
		COUNT(CASE WHEN payment_menthod = 'ERROR' THEN 1 END) + COUNT(CASE WHEN payment_menthod = 'UNKNOWN' THEN 1 END) + COUNT(CASE WHEN payment_menthod = '' THEN 1 END) AS missing_payment_menthod,
		COUNT(CASE WHEN location = 'ERROR' THEN 1 END) + COUNT(CASE WHEN location = 'UNKNOWN' THEN 1 END) + COUNT(CASE WHEN location = '' THEN 1 END) AS missing_location,
		COUNT(CASE WHEN item = 'ERROR' THEN 1 END) + COUNT(CASE WHEN item = 'UNKNOWN' THEN 1 END) + COUNT(CASE WHEN item = '' THEN 1 END) AS missing_item,
        COUNT(CASE WHEN price_per_unit = 'ERROR' THEN 1 END) + COUNT(CASE WHEN price_per_unit = 'UNKNOWN' THEN 1 END) + COUNT(CASE WHEN price_per_unit = '' THEN 1 END) AS missing_price_per_unit,
        COUNT(CASE WHEN quantity = 'ERROR' THEN 1 END) + COUNT(CASE WHEN quantity = 'UNKNOWN' THEN 1 END) + COUNT(CASE WHEN quantity = '' THEN 1 END) AS missing_quantity,
        COUNT(CASE WHEN total_spent = 'ERROR' THEN 1 END) + COUNT(CASE WHEN total_spent = 'UNKNOWN' THEN 1 END) + COUNT(CASE WHEN total_spent = '' THEN 1 END) AS missing_total_spent
FROM dirty_cafe_sales dcs 


SELECT* FROM dirty_cafe_sales dcs 

/*RESULT: number of blank + UNKNOWN + ERROR value for each field
 Date | Payment_menthod | Location | Item | Unit_price | Quantity | Total | 
  460 |      3178       |    3961  |  969 |    533     |    479   |  502  | */

----- Create the fields and fill missing value: UNKNOWN, ERROR, blank = 0, date or Unknown (following value type)

ALTER TABLE dirty_cafe_sales
ADD COLUMN date_clean varchar(50),
ADD COLUMN unit_price varchar,
ADD COLUMN item_clean varchar,
ADD COLUMN payment_menthod_clean varchar,
ADD COLUMN location_clean varchar,
ADD COLUMN quantity_clean varchar,
ADD COLUMN total_spent_clean varchar

UPDATE dirty_cafe_sales
SET date_clean = CASE 
	WHEN transaction_date = '' THEN '1900-01-01'
		 WHEN transaction_date = 'UNKNOWN' THEN '1900-01-01'
		 WHEN transaction_date = 'ERROR' THEN '1900-01-01'
		 ELSE transaction_date
		 END,
	unit_price = CASE 
			WHEN price_per_unit = '' THEN '0'
			WHEN price_per_unit = 'UNKNOWN' THEN '0'
			WHEN price_per_unit = 'ERROR' THEN '0'
			ELSE price_per_unit
			END,
	item_clean = CASE
 			WHEN item = '' THEN 'Unknown'
			WHEN item = 'UNKNOWN' THEN 'Unknown'
			WHEN item = 'ERROR' THEN 'Unknown'
			ELSE item
			END,
	payment_menthod_clean = CASE
 			WHEN payment_menthod = '' THEN 'Unknown'
			WHEN payment_menthod = 'UNKNOWN' THEN 'Unknown'
			WHEN payment_menthod = 'ERROR' THEN 'Unknown'
			ELSE payment_menthod
			END,
	location_clean = CASE
 			WHEN location = '' THEN 'Unknown'
			WHEN location = 'UNKNOWN' THEN 'Unknown'
			WHEN location = 'ERROR' THEN 'Unknown'
			ELSE location
			END,
	quantity_clean = CASE 
			WHEN quantity = '' THEN '0'
			WHEN quantity = 'UNKNOWN' THEN '0'
			WHEN quantity = 'ERROR' THEN '0'
			ELSE quantity
			END,
	total_spent_clean = CASE 
			WHEN total_spent = '' THEN '0'
			WHEN total_spent = 'UNKNOWN' THEN '0'
			WHEN total_spent = 'ERROR' THEN '0'
			ELSE total_spent
			END;
	
	-------Change data type----

ALTER TABLE dirty_cafe_sales 
ALTER COLUMN date_clean TYPE date
	USING date_clean :: date,
ALTER COLUMN unit_price TYPE float
	USING unit_price ::float,	
ALTER COLUMN total_spent_clean TYPE float
	USING total_spent_clean ::float,
ALTER COLUMN quantity_clean TYPE float
	USING quantity_clean ::float
	
/* Create fields and find the value of item name, unit price - using provided menu list:
	
	Item	Price($)
	Coffee		2
	Tea			1.5
	Sandwich	4
	Salad		5
	Cake		3
	Cookie		1
	Smoothie	4
	Juice		3 	*/
	
ALTER TABLE dirty_cafe_sales 
ADD COLUMN item_clean_1 varchar,
ADD COLUMN unit_price_1 float,
ADD COLUMN item_clean_2 varchar,
ADD COLUMN unit_price_2 float

UPDATE dirty_cafe_sales
SET item_clean_1 = CASE 
			WHEN item_clean = 'Unknown' AND unit_price = 2 THEN 'Coffee'
			WHEN item_clean = 'Unknown' AND unit_price = 1.5 THEN 'Tea'
			WHEN item_clean = 'Unknown' AND unit_price = 4 THEN 'Sanwich'
			WHEN item_clean = 'Unknown' AND unit_price = 5 THEN 'Salad'
			WHEN item_clean = 'Unknown' AND unit_price = 3 THEN 'Cake'
			WHEN item_clean = 'Unknown' AND unit_price = 1 THEN 'Cookie'
			WHEN item_clean = 'Unknown' AND unit_price = 3 THEN 'Juice'
			ELSE item_clean 
			END,
	unit_price_1 = CASE 
			WHEN item_clean_1 = 'Unknown' AND unit_price = 0 AND quantity_clean <> 0 AND total_spent_clean <> 0 THEN total_spent_clean/quantity_clean
			ELSE unit_price
			END
			
	UPDATE dirty_cafe_sales		
	SET item_clean_2 = CASE 
			WHEN item_clean_1 = 'Unknown' AND unit_price_1 = 2 THEN 'Coffee'
			WHEN item_clean_1 = 'Unknown' AND unit_price_1 = 1.5 THEN 'Tea'
			WHEN item_clean_1 = 'Unknown' AND unit_price_1 = 4 THEN 'Sanwich'
			WHEN item_clean_1 = 'Unknown' AND unit_price_1 = 5 THEN 'Salad'
			WHEN item_clean_1 = 'Unknown' AND unit_price_1 = 3 THEN 'Cake'
			WHEN item_clean_1 = 'Unknown' AND unit_price_1 = 1 THEN 'Cookie'
			WHEN item_clean_1 = 'Unknown' AND unit_price_1 = 3 THEN 'Juice'
			ELSE item_clean_1 
			END,
	unit_price_2 = CASE 
			WHEN unit_price_1 = 0 AND item_clean_2 = 'Coffee' THEN 2
			WHEN unit_price_1 = 0 AND item_clean_2 = 'Tea' THEN 1.5
			WHEN unit_price_1 = 0 AND item_clean_2 = 'Sandwich' THEN 4
			WHEN unit_price_1 = 0 AND item_clean_2 = 'Salad' THEN 5
			WHEN unit_price_1 = 0 AND item_clean_2 = 'Cake' THEN 3
			WHEN unit_price_1 = 0 AND item_clean_2 = 'Cookie' THEN 1
			WHEN unit_price_1 = 0 AND item_clean_2 = 'Juice' THEN 3
			WHEN unit_price_1 = 0 AND item_clean_2 = 'Smoothie' THEN 4
			ELSE unit_price_1
			END
			
----- Create fields and find the quantity value, total_spent value by calculating from the data
			
ALTER TABLE dirty_cafe_sales
ADD COLUMN quantity_clean_1 float,
ADD COLUMN total_clean_1 float

UPDATE dirty_cafe_sales
SET quantity_clean_1 = CASE 
		WHEN quantity_clean = 0 AND total_spent_clean <> 0 AND unit_price_2 <> 0 THEN total_spent_clean/unit_price_2
		ELSE quantity_clean
		END,
	total_clean_1 = CASE 
		WHEN total_spent_clean = 0 AND quantity_clean_1 <> 0 AND unit_price_2 <> 0 THEN unit_price_2 * quantity_clean_1
		ELSE total_spent_clean
		END	

---- Check missing value after Cleanding Data----
SELECT 
	COUNT(CASE WHEN date_clean = '1900-01-01' THEN 1 END) AS missing_date,
	COUNT(CASE WHEN payment_menthod_clean = 'Unknown' THEN 1 END) AS missing_payment_menthod,
	COUNT(CASE WHEN location_clean = 'Unknown' THEN 1 END) AS missing_location,
	COUNT(CASE WHEN item_clean_2 = 'Unknown' THEN 1 END) AS missing_item,
	COUNT(CASE WHEN unit_price_2 = 0 THEN 1 END) AS missing_unit_price,
	COUNT(CASE WHEN quantity_clean_1 = 0 THEN 1 END) AS missing_quantity,
	COUNT(CASE WHEN total_clean_1 = 0 THEN 1 END) AS missing_total
FROM dirty_cafe_sales;

/*RESULT: number of blank + UNKNOWN + ERROR value for each field
 Date | Payment_menthod | Location | Item | Unit_price | Quantity | Total | 
  460 |       3178      |    3961  |   6  |     6      |     23   |   23  | */


