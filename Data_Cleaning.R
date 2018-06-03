#Loading libraries
library(dplyr)
library(data.table)

#Reading dataset and defining metadata
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

#Renaming all the variables
df= df %>%
  rename(unique_key=`Trip ID`, taxi_id= `Taxi ID`,
         trip_start_timestamp=`Trip Start Timestamp`,
         trip_end_timestamp= `Trip End Timestamp`,
         trip_seconds=`Trip Seconds`, trip_miles=`Trip Miles`,
         pickup_census_tract= `Pickup Census Tract`,
         dropoff_census_tract= `D Census Tract`,
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


#Removing AM/PM string from the timestamp values
df[,3]=  lapply(df[,3],as.POSIXct ,format='%m/%d/%Y %I:%M:%S %p')
df[,4]=  lapply(df[,4],as.POSIXct ,format='%m/%d/%Y %I:%M:%S %p')

#Removing $ string from the monetary columns
df=df %>%
  mutate(fare= substring(fare,2, nchar(fare)),
         tips= substring(tips,2,nchar(tips)),
         tolls= substring(tolls,2,nchar(tolls)),
         extras= substring(extras,2,nchar(extras)),
         trip_total= substring(trip_total,2,nchar(trip_total)))

df=df %>%
  mutate(fare= as.numeric(fare),
         tips= as.numeric(tips),
         tolls= as.numeric(tolls),
         extras= as.numeric(extras),
         trip_total=as.numeric(trip_total))

df= df %>%
  rename(unique_key=`Trip ID`, taxi_id= `Taxi ID`,
         trip_start_timestamp=`Trip Start Timestamp`,
         trip_end_timestamp= `Trip End Timestamp`,
         trip_seconds=`Trip Seconds`, trip_miles=`Trip Miles`,
         pickup_census_tract= `Pickup Census Tract`,
         dropoff_census_tract= `D Census Tract`,
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
