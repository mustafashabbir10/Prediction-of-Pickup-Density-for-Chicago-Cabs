## [Overview](../index.md)

# Data Exploration

## [Preprocessing](../preprocessing/cleaning.md)

## [Feature Creation](../feature_creation/features.md)

## [Model Building](../model_building/model.md)

## [Conclusion](../conclusion/conclusion.md)

### Exploring Chicago Cab Data

The first step in this study is Exploratory data analysis of the cab data. Our aim is to analyze how different features in the data-set relates to the other variables. We want to identify the variables that have a predictive potency while predicting the daily and hourly revenues of the taxis. The visualization part was done in Tableau given the size of the dataset.

We begin by examining how Chicago cab business has changed over time, especially after the advent of the savvy competitors like Uber and Lyft. In Chicago, Uber and Lyft entered the cab business in 2011 and 2013 respectively.
We plot the Total Yearly pickups and Total Yearly Fare graphs. From the first graph, it can be noticed that there is a sharp decline in the number of pickups with an annual rate of 35% after 2014. Total revenues per year follows the same trend with the total cab business at $18 million in 2016 as opposed to $35 million in 2013. This suggests Uber and Lyft has a grasp on the customer base with their competitive prices. 

Image 1                    |  Image 2
:-------------------------:|:-------------------------:
![alt-text-1](images/chicago_1.png)  |  ![alt-text-2](images/chicago_2.png)

This has caused huge economic burden on the cabbies as they aren’t generating enough fares to keep up with their loan payments and meet their expenses. More than 350 foreclosure notices or foreclosure lawsuits have been initiated against medallion owners in the year 2017, compared to 266 in 2016 and 59 in 2015. Since October, lenders have filed lawsuits against at least 107 medallion owners who have fallen behind on loan payments, according to the union’s count. The major reason behind this financial distress is that since the emergence of Uber & Lyft, Cabbies face an uneven playing field with the ride-share companies, who typically don’t face the same permitting and fee rules. [1]

Let's plot the total number of rides against the week number over the course of 4 years. After looking at the graph, its difficult to explain the variation in the number of rides every week of the year. But, we can notice a spike in week 10 and week 24. A similar downward spike can be noticed in the week 48 and 52. Week 10 contains the most important holiday celebrated widely in Chicago City i.e. St. Patrick’s Day. Week 48 and week 52 contains Thanksgiving and Christmas holiday.

Image 3                    |  Image 4
:-------------------------:|:-------------------------:
![alt-text-1](images/chicago_3.png)  |  ![alt-text-2](images/chicago_4.png) 

Holidays have always been special to the Chicago City. From raucous pub crawls to lively parades, there is nothing quite like St. Patrick's Day in Chicago. In March, Irish taverns are packed with revelers, jovial crowds jam the city streets and the Chicago River sparkles brilliant shades of emerald green. With so much going on, be it the downtown parade or dyeing of the Chicago river, Chicagoans travels a lot and they generally prefer public taxis.

It turns out that St. Patrick’s Day parade which is held in march of every year accounts for maximum number of taxi trips on a particular day.

One of the important national holiday is Labor Day, created to celebrate the contributions of the American worker. It falls on the first Monday of September, resulting in a dearly coveted three-day weekend. Labor Day is essentially a day off for cabbies and this results in less number of ride on that day.

Memorial Day, Thanksgiving and Christmas of every year has the least number of taxi trips respectively. This is again due to the fact that there are few Taxi’s in service on these holidays. This explicit visualization motivated us to incorporate important holidays as parameters in our predictive model. 
 

Now we analyze the number of pickups by the hour of the day. Morning and evening rush hours are clearly visible, especially at 9 AM when people want to reach their offices and colleges, and at around 6-7 PM when they want to go back to their houses. A sharp decline in the pickups can be seen at 5th and 6th hours of the day. To understand this better, we plotted the average fare vs hour of the day graph. Average fare per ride has peaked during the 5th-6th hour of the day. We analyzed this further to capture the reason for the increased prices during these hours by plotting the trip miles vs hour of the day. 

Image 5                    |  Image 6
:-------------------------:|:-------------------------:
![alt-text-1](images/chicago_5.png)  |  ![alt-text-2](images/chicago_6.png)

We deduced why trip miles were skyrocketing during that interval. It turns out that number of drop offs at O’Hare International Airport (Second busiest airport worldwide) were maximum during the 6th hour of the day i.e. many Chicagoans uses taxi to board their early morning flights. Since O’Hare is located on the far Northwest Side of Chicago, Illinois, 14 miles northwest of Chicago's Loop business district (community responsible for highest number of pick-ups), trip miles and total fare are usually higher [2]. Although the number of drops is greater in the evening as well, but the average remains low due to large number of rides. 

Image 7                    |  Image 8
:-------------------------:|:-------------------------:
![alt-text-1](images/chicago_7.png)  |  ![alt-text-2](images/chicago_8.png)

Weekly and hourly analysis made us curious and we wanted to see the combine effect of day of the week and hour of the day on number of rides. It would provide the exact the day and hour at which Chicago Transport Authority (CTA) should have maximum number of active taxis. This heatmap (Image 9) gives a clear picture about dependence of both the parameters on number of rides. From 0-6 on Monday through Friday there are less number of rides, hence less number of taxis required to balance the demand. Chicagoans generally like to relax on Friday and Saturday, traveling a lot within the city, drinking which gives rise to more number of rides. Also, talking about allocation of resources CTA should have large number of taxis from 0th hour to 6th hour on Saturday and Sunday. Heatmap for Total trip is similar to the number of rides.

![png](images/chicago_9.png)

As mentioned previously, heatmap is entirely different for average fare. If some of the cabbies are looking to make more money per ride, following heatmap is very useful for them. It paints a profitable picture where there is high return on investment, if a cabby is willing to serve from 4AM-7AM. The traffic density at this time is less which aides higher fuel efficiency.

![png](images/chicago_10.png)

Also keeping in mind that since these rides are lengthier time and distance wise, from our own experiences, we have always tipped more in such situations. Hence, we plotted the similar heatmap for average tips, our intuition was right as many people appreciated the work done by cabbies and that too at 5AM or 6AM. Average tips were fairly high in the night time as well.

![png](images/chicago_11.png)

So far, we understood the importance of time features. Next, we wanted to understand the importance of pick up and drop off location.

Chicago’s taxi pickup declines are not evenly distributed among the city’s 77 community areas. For example, the Loop, Chicago’s central business district, shows a 23% annual decline, while Logan Square on the northwest side shows a 50% annual decline. In general, the areas located closest to the central business district show smaller declines in taxi activity.

We defined 5 particular community areas—the Loop, Near North Side, Near West Side, Near South Side, and O’Hare Airport—as the “core”, then compared pickups inside and outside of the core. (Figure 12) As of November 2016, pickups inside the core shows a 27% annual decline compared to a 42% annual decline outside of the core. On a cumulative basis, core pickups have declined 39% since June 2014, while non-core pickups have declined a whopping 65%.

![png](images/chicago_12.png)
![png](images/chicago_13.png)

The above figure depicts the distribution of number of rides for six different areas. It again emphasizes the importance of those ‘Core’ areas we talked about earlier.




One of the parameter that is most important for any taxi company to know is what are some of the most influential pick up areas in a particular city. Generally, these are the areas which have a great revenue potential and by focusing on these areas one can increase a taxi’s overall profit. As mentioned earlier there are some of the core areas, the reason we called them as a core area was because of their extreme affluence, typified by the Magnificent Mile, Gold Coast, Navy Pier, and its world-famous skyscrapers. Magnificent mile and Gold Coast are among the top ten richest neighborhoods in America. Navy Pier is the number one tourist destination in Chicago City, drawing nearly nine million visitors annually.

![png](images/chicago_14.png)

Because of such affluence, business and tourism these areas account for a major portion of revenue for the Chicago Taxis. O’Hare, as mentioned before, is the second-busiest airport in the world by the number of takeoffs and landings and also contributes majorly towards the revenue.
