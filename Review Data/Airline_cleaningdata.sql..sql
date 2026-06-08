ALTER TABLE airlinescrappedreview 
    ALTER COLUMN "review_title" TYPE TEXT,
    ALTER COLUMN "review_content" TYPE TEXT,
    ALTER COLUMN "route" TYPE VARCHAR(255)
    
-- Delete Duplicate    
    
WITH cte AS (SELECT *, row_number() OVER(PARTITION BY review_title, review_content) AS duplicated
FROM airlinescrappedreview) 
SELECT * FROM cte 
WHERE duplicated = 1

SELECT count(*) FROM airline_review 

SELECT DISTINCT route FROM airline_review

-- --Cleaning mixed values among fields (flying_month, route, class and traveller_type)

-- Update flying_month field

UPDATE airline_review
SET flying_month = route
WHERE route LIKE '%January%' 
				OR route LIKE '%February%'
				OR route LIKE '%March%'
				OR route LIKE '%April%'
				OR route LIKE '%May%'
				OR route LIKE '%June%'
				OR route LIKE '%July%'
				OR route LIKE '%August%'
				OR route LIKE '%September%'
				OR route LIKE '%October%'
				OR route LIKE '%November%'
				OR route LIKE '%December%'
				
UPDATE airline_review				
SET flying_month = class 
WHERE aclass LIKE '%January%' 
   OR class LIKE '%February%'
   OR class LIKE '%March%'
   OR class LIKE '%April%'
   OR class LIKE '%May%'
   OR class LIKE '%June%'
   OR class LIKE '%July%'
   OR class LIKE '%August%'
   OR class LIKE '%September%'
   OR class LIKE '%October%'
   OR class LIKE '%November%'
   OR class LIKE '%December%'
   
UPDATE airline_review 
SET flying_month = NULL 
WHERE flying_month NOT LIKE '%January%' 
   AND flying_month NOT LIKE '%February%'
   AND flying_month NOT LIKE '%March%'
   AND flying_month NOT LIKE '%April%'
   AND flying_month NOT LIKE '%May%'
   AND flying_month NOT LIKE '%June%'
   AND flying_month NOT LIKE '%July%'
   AND flying_month NOT LIKE '%August%'
   AND flying_month NOT LIKE '%September%'
   AND flying_month NOT LIKE '%October%'
   AND flying_month NOT LIKE '%November%'
   AND flying_month NOT LIKE '%December%'
   
 -- Update class field

UPDATE airline_review
SET CLASS = flying_month 
WHERE flying_month = 'Business' OR flying_month = 'Business Class' OR flying_month = 'First Class' OR flying_month = 'Premium Economy' OR flying_month = 'Economy Class'

UPDATE airline_review 
SET CLASS = route 
WHERE route = 'Business' OR route = 'Business Class' OR route = 'First Class' OR route = 'Premium Economy' OR route = 'Economy Class'

UPDATE airline_review
SET CLASS = traveller_type 
WHERE traveller_type = 'Business' OR traveller_type = 'Business Class' OR traveller_type = 'First Class' OR traveller_type = 'Premium Economy' OR traveller_type = 'Economy Class'

UPDATE airline_review
SET CLASS = NULL 
WHERE CLASS <> 'Business' AND CLASS <> 'Business Class' AND CLASS <> 'First Class' AND CLASS <> 'Premium Economy' AND CLASS <> 'Economy Class'

-- Update route field

UPDATE airline_review
SET route = flying_month 
WHERE flying_month LIKE '%to%' OR flying_month LIKE '%-%' 

UPDATE airline_review
SET route = traveller_type 
WHERE traveller_type LIKE '%to%' OR traveller_type LIKE '%-%' 

UPDATE airline_review 
SET route = NULL 
WHERE (route NOT LIKE '%to%' AND route NOT LIKE '%-%') OR route LIKE '%October%'

-- Update verified field

UPDATE airline_review
SET verified = 'Trip Verified' 
WHERE review_content LIKE '%Verified%'

UPDATE airline_review 
SET verified = 'Not Verified'
WHERE review_content LIKE '%Unverified%'

-- TRIM Unverified and Verified from review_content field

UPDATE  airline_review 
SET review_content = TRIM('Unverified' FROM review_content)

UPDATE airline_review 
SET review_content = TRIM('Verified Review' FROM review_content)

-- Add departure, arrival and transit

ALTER TABLE airline_review
ADD departure varchar,
ADD arrival varchar,
ADD transit varchar

UPDATE airline_review
SET departure = SPLIT_PART(route, 'to ', 1),
	transit = SPLIT_PART(route, 'via ', 2),
	arrival = SPLIT_PART(SPLIT_PART(route, 'to ', 2), 'via ', 1)
	
SELECT COUNT(*) FROM airline_review

ALTER TABLE airline_review 
DROP traveller_type
DROP duplicated,
DROP route

SELECT passenger_name, departure, arrival, transit, flying_month, rating, verified, CLASS, review_title, review_content
FROM airline_review

ALTER TABLE airline_review_clean 
    ALTER COLUMN "review_title" TYPE TEXT,
    ALTER COLUMN "review_content" TYPE TEXT

-- Split flying_month to Month and Year column

ALTER TABLE airline_review_clean
ADD MONTH varchar,
ADD YEAR varchar 

UPDATE airline_review_clean
SET MONTH = SPLIT_PART(flying_month, ' ', 1)

UPDATE airline_review_clean
SET YEAR = SPLIT_PART(flying_month, ' ', 2)

SELECT MONTH, YEAR, passenger_name, departure, arrival, transit, rating, verified, CLASS, review_title, review_content
FROM airline_review_clean


SELECT * FROM airline_review_clean

SELECT * FROM airline_review

SELECT * FROM airlinescrappedreview a 
