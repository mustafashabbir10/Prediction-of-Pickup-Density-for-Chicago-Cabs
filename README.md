# Chicago-Cab-Data

### Motivation

In this project, we have conducted analysis and prediction on the publicly available Chicago Taxi Data from the year 2013-2017(July). This project addresses the challenges faced by the transportation industry on how to maximize their revenue i.e. which community area has the greatest pick up density, what are some of the important parameters that determine the total trip rate for a particular ride.

Taxi business in Chicago city has always been dynamic and with the advent of tech savvy competitors like Uber and Lyft, it has become highly important for Chicago Transit Authority to strategically allocate their resources. Number of public taxis in the city has been on the decline and total revenue shows the same trend.  

One of the major difference between Uber and a typical Chicago taxi is that latter does not provide predicted total amount for a particular trip. This is a major problem for both drivers and customers, customers cannot handle uncertainty attached with the ride. This analysis aims to make transportation more efficient for the Chicago Transit Authority. 

### Objectives

The objective of this project is to build visualization models which help in the interpretation of how Chicagoan uses their public taxi on an hourly and daily basis. Exploration and visualization aids in feature extraction for developing predictive models using different statistical learning algorithm. Our Predictive models aim to forecast the trip total amount and number of rides from a particular location on a given hour of the day.

### Target Audience

Predictive and visualization models like these are interesting for many stakeholders: -
1.	**Taxi firms**: Companies can allocate their resources effectively by diverting the cabs to a specific location during specific times. 
2.	**Traffic planning**: We all have experienced a traffic delay on any special occasion, be it the end of a movie or on a Sunday when you are at the church, this project will help in traffic management. 
3.	**Data scientists**: As budding data scientists we always try to learn from other models and think about ways on how to improve the existing model, this helps in eliminating the need of reinventing the wheel.

### Data Acquisition

The primary data source comes from the publicly available Chicago Cab data on Google BigQuery. As this data was incomplete(2013-2015 only), data of 2016 and 2017 was downloaded from City of Chicago webpage and incorporated into the existing dataset on Google BigQuery to perform the further visualization and prediction part.

* [Chicago Cab Data Year 2013-15](https://bigquery.cloud.google.com/table/bigquery-public-data:chicago_taxi_trips.taxi_trips?pli=1)
* [Chicago Cab Data Year 2016-17](https://data.cityofchicago.org/Transportation/Taxi-Trips/wrvz-psew)

In addition, weather data from NOAA was incorporated into the Cab data for prediction modeling.

* [Weather Data](https://www.ncdc.noaa.gov/cdo-web/search?datasetid=GHCND)

### Challenges & Counter Measures

This project was challenging in terms of the volume of data it contains, hence this created a need to conduct the predictive analysis on a subset of the data. In the competition there are number of ways one could create a subset, we opted for two ways for aggregating 105 million rows: -
1)	Calculated the daily total taxi fares for each Taxi ID for each week in the data and took the median of total taxi fares for each Taxi ID.
2)	Calculated the hourly total taxi fares for each Taxi ID for each week in the data and took the median of total taxi fares for each Taxi ID.
Extraction of the desired data from a 40 gigabyte CSV was a still a difficult task. To query the data, we used Google Cloud Platform and Google Bigquery.
Data Visualization models were built by using the entire data on Tableau, Tableau enabled us to extract the data using Google Bigquery and hence all the plots were developed easily.

### References

* USA TODAY, "Chicago cabbies say industry is teetering toward collapse," 5 June 2017. [Online](https://www.usatoday.com/story/news/2017/06/05/chicago-cabbies-say-industry-teetering-toward-collapse/102524634/)

* T. W. Schneider, "Chicago’s Public Taxi Data," 17 January 2017. [Online](http://toddwschneider.com/posts/chicago-taxi-data)

* I. London, "Encoding cyclical continuous features - 24-hour time," 31 July 2016. [Online](https://ianlondon.github.io/blog/encoding-cyclical-features-24hour-time)

* C. v. o. WGN9, "Chicago best city to celebrate St. Patrick’s Day in America, website says," 9 March 2018. [Online](http://wgntv.com/2018/03/09/chicago-best-place-to-celebrate-st-patricks-day-in-america-website-says/)

#### Libraries Used

`Python`
* [Python Standard Library](https://docs.python.org/2/library/): Built in python modules.
* [Numpy](http://www.numpy.org/): Scientific computing with python.
* [Matplotlib](http://matplotlib.org/): Python plotting.
* [Seaborn](http://seaborn.pydata.org/): Data visualization built on Matplotlib.
* [Pandas](http://pandas.pydata.org/): Data analysis tools.
* [Scikit-learn](http://scikit-learn.org/stable/): Machine learning toolkit.
* [NLTK](http://www.nltk.org/): Human language data processing.
* [LightGBM](http://lightgbm.readthedocs.io/en/latest/Python-Intro.html): Gradient Boosting

`R`
* [dplyr](https://cran.r-project.org/web/packages/dplyr/dplyr.pdf): A Grammar of Data Manipulation
* [data.table](https://cran.r-project.org/web/packages/data.table/data.table.pdf): Fast aggregation of large data
* [anytime](https://cran.r-project.org/web/packages/anytime/anytime.pdf): Anything to 'POSIXct' or 'Date' Converter
* [lubridate](https://cran.r-project.org/web/packages/lubridate/lubridate.pdf): Functions to work with date-times and time-spans
