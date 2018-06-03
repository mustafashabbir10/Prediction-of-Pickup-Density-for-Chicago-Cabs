# Chicago-Cab-Data


## Project Objective

The objective of this project is to build visualization models which help in the interpretation of how Chicagoan uses their public taxi on an hourly, daily and weekly basis. Exploration and visualization aids in feature extraction for developing predictive models using different statistical learning algorithm. Our Predictive models aim to forecast the trip total amount and number of rides from a particular location on a given hour of the day.

## Target Audience

Predictive and visualization models like these are interesting for many stakeholders: -
1.	Taxi firms: Companies can allocate their resources effectively by diverting the cabs to a specific location during specific times. 
2.	Traffic planning: I all have experienced a traffic delay on any special occasion, be it the end of a movie or on a Sunday when you are at the church, this project will help in traffic management. 
3.	Data scientists: As budding data scientists I always try to learn from other models and think about ways on how to improve the existing model, this helps in eliminating the need of reinventing the wheel.

## Challenges & Counter Measures

This project was challenging in terms of the volume of data it contains, hence this created a need to conduct the predictive analysis on a subset of the data. In the competition there are number of ways one could create a subset, I opted for two ways for aggregating 105 million rows: -
1)	Calculated the weekly total taxi fares for each Taxi ID for each week in the data and took the median of total taxi fares for each Taxi ID.
2)	Calculated the daily total taxi fares for each Taxi ID for each week in the data and took the median of total taxi fares for each Taxi ID.
3)	Calculated the hourly total taxi fares for each Taxi ID for each week in the data and took the median of total taxi fares for each Taxi ID.
Extraction of the desired data from a 40 gigabyte CSV was a still a difficult task. To query the data, I used Google Cloud Platform and Google Bigquery. (Code-2 Subset selection on Google Bigquery)
Data Visualization models were built by using the entire data on Tableau, Tableau enabled us to extract the data using Google Bigquery and hence all the plots were developed easily.

## Conclusion
This project entails how weather, holidays, mode of payment and time of the day plays an important role on tips and taxi fares. Trip distance remained the most influential parameter which helped in determining the trip total cost for each trip. Different models were tried including Linear Regression, Random Forest and Gradient Boosting Method. Accuracy of 95% was obatined by using Random Forest Classifier for predicting pickup density.
