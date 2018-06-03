# Chicago-Cab-Data

/*In the following query I calculated the weekly total (SUM) taxi fares for each Taxi ID for each week in the data. The whole dataset was grouped by Taxi_ID and week of the date. Apart from trip seconds, trip miles and trip total median values were selected for all other parameters. I also took care of the outliers in the query. I selected the following constraints as mentioned above: -
•	The ratio of trip total and trip miles should be greater than two, for instance if trip distance is 2 miles, the charge should be at least $4. Also, to prevent high outliers the same ratio should be less than 10.
•	With the city traffic and speed restrictions, speed i.e. ratio of trip miles and trip hour was kept less than 70. This enforces another restriction that trip seconds should have non-zero values. */
•	The minimum fare amount for any trip in Chicago is $2.25, hence all the fare values should have non-zero values. 

/*TABLE-1*/
SELECT
   WEEK(trip_start_timestamp) AS time_identifier_week,
   YEAR(trip_start_timestamp) AS time_identifier_year,
   taxi_id,
   COUNT( unique_key ) AS Number_rides,
   NTH(501, QUANTILES( trip_start_timestamp , 1001)) AS trip_start_timestamp ,
   NTH(501, QUANTILES( trip_end_timestamp , 1001)) AS trip_end_timestamp ,
   SUM(trip_seconds) AS trip_seconds,
   NTH(501, QUANTILES( payment_type , 1001)) AS payment_type ,
   NTH(501, QUANTILES( company , 1001)) AS company ,
   SUM(trip_miles) AS trip_miles,
   SUM(trip_total) AS trip_total ,
   NTH(501, QUANTILES( payment_type , 1001)) AS payment_types ,
   NTH(501, QUANTILES( company , 1001)) AS companies ,
   NTH(501, QUANTILES( pickup_latitude , 1001)) AS pickup_latitude ,
   NTH(501, QUANTILES( pickup_longitude , 1001)) AS pickup_longitude ,
   NTH(501, QUANTILES( pickup_location , 1001)) AS pickup_location ,
   NTH(501, QUANTILES( dropoff_latitude , 1001)) AS dropoff_latitude ,
   NTH(501, QUANTILES( dropoff_longitude , 1001)) AS dropoff_longitude ,
   NTH(501, QUANTILES( dropoff_location , 1001)) AS dropoff_location  
   
   FROM [authentic-block-200023:Taxis.Final_merged_data_2013_to_2016] 
   WHERE ((trip_total)/(trip_miles))<10 AND ((trip_total)/(trip_miles))>2 
   AND trip_total>0 AND trip_miles>0 
   AND trip_seconds>0 AND (( trip_miles*3600 )/( trip_seconds ))<70
   GROUP BY  taxi_id,time_identifier_week, time_identifier_year
   ORDER BY time_identifier_year, time_identifier_week  

/* This query yielded out 602327 rows. I wanted those rows which contained median of the total taxi fares for each Taxi ID. To do that I created a TABLE-2 which contained only median values for the trip_total field. */
/*TABLE-2*/
SELECT 
NTH(501, QUANTILES( trip_total , 1001)) AS trip_total, time_identifier_week, time_identifier_year 
FROM [authentic-block-200023:1234.week_table_updated]
GROUP BY time_identifier_week, time_identifier_year
ORDER BY  time_identifier_year,time_identifier_week

/*After creation of these two tables I used a CROSS JOIN to extract those rows from TABLE-1 which contained median of the total taxi fares for each Taxi ID. I CROSS JOINED the two tables on week, year and taxi_id. */

/* FINAL DATA (WEEKLY): - */

SELECT * FROM [authentic-block-200023:1234.week_table_updated] AS week_table
CROSS JOIN [authentic-block-200023:1234.week_table_median] AS median_table
WHERE week_table.trip_total = median_table.trip_total AND 
week_table.time_identifier_week = median_table.time_identifier_week
AND week_table.time_identifier_year = median_table.time_identifier_year
ORDER BY week_table.time_identifier_week, week_table.time_identifier_year

/*This dataset was used for weekly predictive analysis*/

/*MySQL Queries – Daily Data*/

/*Similar strategy was used to obtain data for daily analysis with an additional group by day.*/

/*TABLE-1*/
SELECT
   DAY(trip_start_timestamp) AS time_identifier_day,
   YEAR(trip_start_timestamp) AS time_identifier_year,
   MONTH(trip_start_timestamp) AS time_identifier_month,
   taxi_id,
   COUNT( unique_key ) AS Number_rides,
   NTH(501, QUANTILES( trip_start_timestamp , 1001)) AS trip_start_timestamp ,
   NTH(501, QUANTILES( trip_end_timestamp , 1001)) AS trip_end_timestamp ,
   SUM(trip_seconds) AS trip_seconds,
   NTH(501, QUANTILES( payment_type , 1001)) AS payment_type ,
   NTH(501, QUANTILES( company , 1001)) AS company ,
   SUM(trip_miles) AS trip_miles,
   SUM(trip_total) AS trip_total ,
   NTH(501, QUANTILES( payment_type , 1001)) AS payment_types ,
   NTH(501, QUANTILES( company , 1001)) AS companies ,
   NTH(501, QUANTILES( pickup_latitude , 1001)) AS pickup_latitude ,
   NTH(501, QUANTILES( pickup_longitude , 1001)) AS pickup_longitude ,
   NTH(501, QUANTILES( pickup_location , 1001)) AS pickup_location ,
   NTH(501, QUANTILES( dropoff_latitude , 1001)) AS dropoff_latitude ,
   NTH(501, QUANTILES( dropoff_longitude , 1001)) AS dropoff_longitude ,
   NTH(501, QUANTILES( dropoff_location , 1001)) AS dropoff_location  
   
   FROM [authentic-block-200023:Taxis.Final_merged_data_2013_to_2016] 
   WHERE ((trip_total)/(trip_miles))<10 AND ((trip_total)/(trip_miles))>2 AND trip_total>0 AND trip_miles>0 
   AND trip_seconds>0 AND (( trip_miles*3600 )/( trip_seconds ))<70 AND
   GROUP BY  taxi_id,time_identifier_day, time_identifier_month,time_identifier_year
   ORDER BY time_identifier_year,time_identifier_month, time_identifier_day

/*TABLE-2*/
SELECT 
NTH(501, QUANTILES( trip_total , 1001)) AS trip_total, time_identifier_day, time_identifier_month,
time_identifier_year 
FROM [authentic-block-200023:1234.daily_table_updated] 
GROUP BY time_identifier_day, time_identifier_month , time_identifier_year
ORDER BY  time_identifier_year, time_identifier_month, time_identifier_day

/*FINAL DATA (DAILY): -*/

SELECT * 
FROM [authentic-block-200023:1234.daily_table_updated] AS daily_table
CROSS JOIN [authentic-block-200023:1234.daily_table_median] AS median_table
WHERE daily_table.trip_total = median_table.trip_total 
AND daily_table.time_identifier_day = median_table.time_identifier_day
AND daily_table.time_identifier_year = median_table.time_identifier_year 
AND daily_table.time_identifier_month = median_table.time_identifier_month
ORDER BY daily_table.time_identifier_year,daily_table.time_identifier_month,daily_table.time_identifier_day

/*This dataset was used for daily predictive analysis.*/

/*MySQL Queries – Hourly Data*/

/*Similar strategy was used to obtain data for daily analysis with an additional group by day and grouped by hour.*/

/*TABLE-1*/
SELECT
   HOUR(trip_start_timestamp) AS time_identifier_hour,
   DAY(trip_start_timestamp) AS time_identifier_day,
   YEAR(trip_start_timestamp) AS time_identifier_year,
   MONTH(trip_start_timestamp) AS time_identifier_month,
   taxi_id,
   COUNT( unique_key ) AS Number_rides,
   NTH(501, QUANTILES( trip_start_timestamp , 1001)) AS trip_start_timestamp ,
   NTH(501, QUANTILES( trip_end_timestamp , 1001)) AS trip_end_timestamp ,
   SUM(trip_seconds) AS trip_seconds,
   NTH(501, QUANTILES( payment_type , 1001)) AS payment_type ,
   NTH(501, QUANTILES( company , 1001)) AS company ,
   SUM(trip_miles) AS trip_miles,
   SUM(trip_total) AS trip_total ,
   NTH(501, QUANTILES( payment_type , 1001)) AS payment_types ,
   NTH(501, QUANTILES( company , 1001)) AS companies ,
   NTH(501, QUANTILES( pickup_latitude , 1001)) AS pickup_latitude ,
   NTH(501, QUANTILES( pickup_longitude , 1001)) AS pickup_longitude ,
   NTH(501, QUANTILES( pickup_location , 1001)) AS pickup_location ,
   NTH(501, QUANTILES( dropoff_latitude , 1001)) AS dropoff_latitude ,
   NTH(501, QUANTILES( dropoff_longitude , 1001)) AS dropoff_longitude ,
   NTH(501, QUANTILES( dropoff_location , 1001)) AS dropoff_location  
   
   FROM [authentic-block-200023:Taxis.Final_merged_data_2013_to_2016] 
   WHERE ((trip_total)/(trip_miles))<10 AND ((trip_total)/(trip_miles))>2 AND trip_total>0 AND trip_miles>0 
   AND trip_seconds>0 AND (( trip_miles*3600 )/( trip_seconds ))<70
   GROUP BY  taxi_id,time_identifier_hour, time_identifier_day, time_identifier_month,time_identifier_year
   ORDER BY time_identifier_year,time_identifier_month, time_identifier_day

/*TABLE-2*/
SELECT 
NTH(501, QUANTILES( trip_total , 1001)) AS trip_total, time_identifier_hour, time_identifier_day, time_identifier_month, time_identifier_year 
FROM [authentic-block-200023:1234.hourly_table_updated] 
GROUP BY time_identifier_hour ,time_identifier_day, time_identifier_month , time_identifier_year
ORDER BY  time_identifier_hour ,time_identifier_year, time_identifier_month, time_identifier_day

/*FINAL DATA (HOURLY): -*/

SELECT * 
FROM [authentic-block-200023:1234. hourly_table_updated] AS hourly_table
CROSS JOIN [authentic-block-200023:1234. hourly_table_median] AS median_table
WHERE hourly_table.trip_total = median_table.trip_total 
AND hourly_table.time_identifier_hour = median_table.time_identifier_hour
AND hourly_table.time_identifier_day = median_table.time_identifier_day
AND hourly_table.time_identifier_year = median_table.time_identifier_year 
AND hourly_table.time_identifier_month = median_table.time_identifier_month
ORDER BY daily_table.time_identifier_year,daily_table.time_identifier_month,daily_table.time_identifier_day, time_identifier_hour

/*This dataset was used for hourly predictive analysis*/
