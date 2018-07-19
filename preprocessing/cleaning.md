## [Overview](../index.md)

## [Data Exploration](../data_exploration/exploration.md)

# Preprocessing

## [Feature Creation](../feature_creation/features.md)

## [Model Building](../model_building/model.md)

## [Conclusion](../conclusion/conclusion.md)

### Cleaning and Preprocessing Chicago Cab Data

Since the data available on Google BigQuery is from year 2013 to 2015, we will incorporate the 2016 data into Google BigQuery table. We first downloaded the Cab data from City of Chicago website. But the column names and some of the column types were different from what was available on Google BigQuery. So we first format the 2016 and 2017 data similar to BigQuery data so that the new data can be appended to the old one.

#### Loading Libraries
```{r}
library(dplyr)
library(data.table)
```

#### Reading 2016 data-set

```R
df= fread("H:/Competition/Chicago_taxi_trips.csv",
          colClasses = c("Trip ID"="character","Taxi ID"= "character",
          "Trip Start Timestamp"= "Date", "Trip End Timestamp"="Date", 
          "Trip Seconds"= "integer","Trip Miles"= "integer", 
          "Pickup Census Tract"= "character", "Dropoff Census Tract"="character", 
          "Pickup Community Area"= "integer","Pickup O'Hare Community Area"="integer", "Dropoff Community Area"= "integer",
          "Fare"="character","Tips"="character", "Tolls"= "character","Extras"=  "character","Trip Total"= "character",
          "Payment Type"=  "factor","Company"= "factor",
          "Pickup Centroid Latitude"= "integer","Pickup Centroid Longitude"= "integer", 
          "Pickup Centroid Location"= "character","Dropoff Centroid Latitude"= "integer",
          "Dropoff Centroid Longitude"= "integer","Dropoff Centroid  Location" ="character"))
```

#### Renaming all the variables

```R
df= df %>%
  rename(unique_key=`Trip ID`, taxi_id= `Taxi ID`,
         trip_start_timestamp=`Trip Start Timestamp`,
         trip_end_timestamp= `Trip End Timestamp`,
         trip_seconds=`Trip Seconds`, trip_miles=`Trip Miles`,
         pickup_census_tract= `Pickup Census Tract`,
         dropoff_census_tract= `Dropoff Census Tract`,
         pickup_community_area= `Pickup Community Area`,
         dropoff_community_area= `Dropoff Community Area`,
         fare=Fare, tips= Tips, tolls= Tolls, extras= Extras,
         trip_total= `Trip Total`, payment_type= `Payment Type`,
         company= Company, pickup_latitude= `Pickup Centroid Latitude`,
         pickup_longitude= `Pickup Centroid Longitude`,
         pickup_location= `Pickup Centroid Location`,
         dropoff_latitude= `Dropoff Centroid Latitude`,
         dropoff_longitude= `Dropoff Centroid Longitude`,
         dropoff_location= `Dropoff Centroid  Location`)
```
#### Converting 12 hour Timestamp into 24 hour format

```R
df[,3]=  lapply(df[,3],as.POSIXct ,format= '%m/%d/%Y %I:%M:%S %p')
df[,4]=  lapply(df[,4],as.POSIXct ,format= '%m/%d/%Y %I:%M:%S %p')
```
#### Removing $ string from the monetary columns
```R
df= df %>%
  mutate(fare= substring(fare,2, nchar(fare)),
         tips= substring(tips,2,nchar(tips)),
         tolls= substring(tolls,2,nchar(tolls)),
         extras= substring(extras,2,nchar(extras)),
         trip_total= substring(trip_total,2,nchar(trip_total)))

df= df %>%
  mutate(fare= as.numeric(fare),
         tips= as.numeric(tips),
         tolls= as.numeric(tolls),
         extras= as.numeric(extras),
         trip_total= as.numeric(trip_total))
```

This data-set was appended to the Google BigQuery table and then hourly and daily data was aggregated to perform Prediction Modeling at later stages.

#### Subset selection on Google Bigquery

In the following query we calculated the daily total (SUM) taxi fares for each Taxi ID for each day in the data. The whole dataset was grouped by Taxi_ID and day. Apart from trip seconds, trip miles and trip total median values were selected for all other parameters. We also took care of the outliers in the query. We selected the following constraints as mentioned above: -
* The ratio of trip total and trip miles should be greater than two, for instance if trip distance is 2 miles, the charge should be at least $4. Also, to prevent high outliers the same ratio should be less than 10.
* With the city traffic and speed restrictions, speed i.e. ratio of trip miles and trip hour was kept less than 70. This enforces another restriction that trip seconds should have non-zero values. 
* The minimum fare amount for any trip in Chicago is $2.25, hence all the fare values should have non-zero values. 

#### MySQL Queries – Daily Data
#### `TABLE-1`

```sql
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
```

#### `TABLE-2`

```sql
SELECT 
NTH(501, QUANTILES( trip_total , 1001)) AS trip_total, time_identifier_day, time_identifier_month,
time_identifier_year 
FROM [authentic-block-200023:1234.daily_table_updated] 
GROUP BY time_identifier_day, time_identifier_month , time_identifier_year
ORDER BY  time_identifier_year, time_identifier_month, time_identifier_day
```

#### `FINAL DATA (DAILY)`: -

```sql
SELECT * 
FROM [authentic-block-200023:1234.daily_table_updated] AS daily_table
CROSS JOIN [authentic-block-200023:1234.daily_table_median] AS median_table
WHERE daily_table.trip_total = median_table.trip_total 
AND daily_table.time_identifier_day = median_table.time_identifier_day
AND daily_table.time_identifier_year = median_table.time_identifier_year 
AND daily_table.time_identifier_month = median_table.time_identifier_month
ORDER BY daily_table.time_identifier_year,daily_table.time_identifier_month,daily_table.time_identifier_day
```
This dataset was used for daily predictive analysis.

Similar strategy was used to obtain data for hourly analysis with an additional group by day and grouped by hour.

#### MySQL Queries – Hourly Data

#### `TABLE-1`

```sql
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
```

#### `TABLE-2`

```sql
SELECT 
NTH(501, QUANTILES( trip_total , 1001)) AS trip_total, time_identifier_hour, time_identifier_day, time_identifier_month, time_identifier_year 
FROM [authentic-block-200023:1234.hourly_table_updated] 
GROUP BY time_identifier_hour ,time_identifier_day, time_identifier_month , time_identifier_year
ORDER BY  time_identifier_hour ,time_identifier_year, time_identifier_month, time_identifier_day
```

#### `FINAL DATA (HOURLY)`: -

```sql
SELECT * 
FROM [authentic-block-200023:1234. hourly_table_updated] AS hourly_table
CROSS JOIN [authentic-block-200023:1234. hourly_table_median] AS median_table
WHERE hourly_table.trip_total = median_table.trip_total 
AND hourly_table.time_identifier_hour = median_table.time_identifier_hour
AND hourly_table.time_identifier_day = median_table.time_identifier_day
AND hourly_table.time_identifier_year = median_table.time_identifier_year 
AND hourly_table.time_identifier_month = median_table.time_identifier_month
ORDER BY daily_table.time_identifier_year,daily_table.time_identifier_month,daily_table.time_identifier_day, time_identifier_hour
```

This dataset was used for hourly predictive analysis
