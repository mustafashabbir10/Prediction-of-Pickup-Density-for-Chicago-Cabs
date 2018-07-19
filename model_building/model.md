## [Overview](../index.md)

## [Data Exploration](../Data_exploration/exploration.md)

## [Preprocessing](../preprocessing/cleaning.md)

## [Feature Creation](../feature_extraction/features.md)

# Model Building

## [Conclusion](../conclusion/conclusion.md)

#### Model Selection and Tuning

Now that we have cleaned our data and extracted new features, we can examine different Machine learning models and pick the most suitable one. We are going to compare baseline models `Linear Regression` and `Random Forest` with gradient boosting model `LightGBM`.

To measure the model’s accuracy, we decided to use RMSE and R-squared metrics. While calculating RMSE, predicted values far from the true value are penalized more, it seemed apt to use RMSE to check the accuracy of our models. 

To reduce the overfitting in machine learning algorithms, we are going to use cross-validation to optimize the hyper-parameters before predicting on the test dataset.

5-fold Cross validation was performed in case of Random Forest and LightGBM. Then best parameters from cross-validation were used to predict the year 2017 total fare. 

For Random Forest, cross validation is done using n_estimators, the number of trees constructed in the forest, equal to 10, 15 and 20. The max_features (the number of features allowed in each tree) parameter is set to auto, sqrt and log2.

For LightGBM, cross validation is done using num_leaves (number of leaves in full tree) equal to 20,40,60,80 and learning rate being set to 0.01 and 0.1 (the rate at which the model converges).

After optimizing the hyper-parameters, the models were fit on the testing data. We used two different datasets to predict hourly, daily median fare. The hourly data have around 33000 rows and daily around 1600 rows rows.
#### Importing Libraries
```python
import pandas as pd
import numpy as np
import os
import time
import math
from datetime import date
import math
import matplotlib.pyplot as plt
import seaborn as sns
import statsmodels.api as sm
from sklearn import preprocessing
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_validate
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn.metrics import median_absolute_error
from sklearn.metrics import accuracy_score, precision_score, recall_score
from sklearn.grid_search import GridSearchCV
from sklearn.ensemble import RandomForestRegressor
import lightgbm as lgb
from Class_tree import DecisionTree
```

#### Loading Data

```python
df = pd.read_csv("train_hourly.csv")
df_test= pd.read_csv("x_test_daily.csv")
df= df[['trip_seconds', 'trip_miles', 'trip_total', 'companies', 'pickup_latitude', 'pickup_longitude', 'dropoff_latitude', 'dropoff_longitude', 'hourfloat', 'hourfloat_sin', 'hourfloat_cos','payment_types', 'day_num', 'day_sin','day_cos','yearfloat', 'year_cos','year_sin', 'monthfloat',  'month_cos', 'month_sin', 'PRCP', 'SNWD', 'SNOW', 'TMAX', 'AWND', 'day_cat', 'Special_day']]
df_test= df_test[['trip_seconds', 'trip_miles', 'trip_total', 'companies','pickup_latitude', 'pickup_longitude', 'dropoff_latitude', 'payment_types', 'dropoff_longitude', 'hourfloat','hourfloat_sin', 'hourfloat_cos','day_num', 'day_sin','day_cos', 'yearfloat', 'year_cos','year_sin', 'monthfloat', 'month_cos', 'month_sin', 'PRCP', 'SNWD', 'SNOW', 'TMAX', 'AWND', 'day_cat', 'Special_day']]
```
#### One Hot Encoding of nominal variables
```python
df_nominal= df[['companies', 'day_cat', 'Special_day', 'payment_types']]
df_encoded=pd.get_dummies(df_nominal,columns=['companies', 'day_cat', 'Special_day', 'payment_types'],drop_first=False)
df_nominal_test= df_test[['companies','day_cat' , 'Special_day', 'payment_types']]
df_encoded_test=pd.get_dummies(df_nominal_test,columns=['companies', 'day_cat', 'Special_day', 'payment_types'],drop_first=False)
```

#### Inmputing missing values with mean
```python
df_interval=df.drop(['companies', 'day_cat', 'Special_day', 'payment_types'] ,axis=1).copy()
df_interval= df_interval.apply(lambda x: x.fillna(x.mean()),axis=0)
df_interval_test=df_test.drop(['companies', 'day_cat', 'Special_day', 'payment_types'] ,axis=1).copy()
df_interval_test= df_interval_test.apply(lambda x: x.fillna(x.mean()),axis=0)
df_final=pd.concat([df_interval,df_encoded],ignore_index=False,axis=1)
df_final_test=pd.concat([df_interval_test,df_encoded_test],ignore_index=False,axis=1)
```
#### `Linear Regression`

```python
predictor_space=df_final.drop('trip_total',axis=1)
lr=LinearRegression()
X=np.asarray(df_final.drop('trip_total',axis=1))   
y= np.asarray(df_final['trip_total'])
Xt=np.asarray(df_final_test.drop('trip_total',axis=1))   
yt= np.asarray(df_final_test['trip_total'])
lr.fit(X,y)

def display_split_metrics(lr, Xt, yt, Xv, yv):
        predict_t = lr.predict(Xt)
        predict_v = lr.predict(Xv)
        print("\n")
        print("{:.<23s}{:>15s}{:>15s}".format('Model Metrics', \
                                      'Training', 'Validation'))
        print("{:.<23s}{:15d}{:15d}".format('Observations', \
                                          Xt.shape[0], Xv.shape[0]))
        print("{:.<23s}{:15d}{:15d}".format('Coefficients', \
                                          Xt.shape[1]+1, Xv.shape[1]+1))
        print("{:.<23s}{:15d}{:15d}".format('DF Error', \
                      Xt.shape[0]-Xt.shape[1]-1, Xv.shape[0]-Xv.shape[1]-1))
        R2t = r2_score(yt, predict_t)
        R2v = r2_score(yv, predict_v)
        print("{:.<23s}{:15.4f}{:15.4f}".format('R-Squared', R2t, R2v))
        print("{:.<23s}{:15.4f}{:15.4f}".format('RMSE', \
                      math.sqrt(mean_squared_error(yt,predict_t)), \
                      math.sqrt(mean_squared_error(yv,predict_v))))
        
display_split_metrics(lr, X, y, Xt, yt)
```

| Model Metrics | Training | Validation |
|---------------|----------|------------|
| Observations  | 33776    | 4923       |
| Coefficients  | 42       | 42         |
| DF Error      | 33734    | 4881       |
| R-Squared     | 0.5258   | 0.5294     |
| RMSE          | 3.0326   | 3.2577     |


We will use GridSearch to optimize the parameters in Random Forest and LightGBM

#### `Random Forest`

```python
estimator = RandomForestRegressor(n_estimators=20, n_jobs=-1)
# Funtion for cross-validation over a grid of parameters
def cv_optimize(clf, parameters, X, y, n_jobs=1, n_folds=5, score_func=None, \
                verbose=0):
    if score_func:
        gs = GridSearchCV(clf, param_grid=parameters, cv=n_folds, \
                          n_jobs=n_jobs, scoring=score_func, verbose=verbose)
    else:
        gs = GridSearchCV(clf, param_grid=parameters, n_jobs=n_jobs,\
                         cv=n_folds, verbose=verbose)
    gs.fit(X, y)
    print ("BEST", gs.best_params_, gs.best_score_, gs.grid_scores_,\
            gs.scorer_)
    print ("Best score: ", gs.best_score_)
    best = gs.best_estimator_
    return best
# Define a grid of parameters over which to optimize the random forest
# We will figure out which number of trees is optimal

parameters = {"n_estimators": [10,20,30],
              "max_features":  ["auto","sqrt","log2"]
              "max_depth": [50]}

best = cv_optimize(estimator, parameters, X, y, n_folds=5,\
                    score_func='mean_squared_error', verbose=3)

# Fit the best Random Forest and calculate R^2 values for training and test sets
reg=best.fit(X, y)
training_accuracy = reg.score(X, y)
test_accuracy = reg.score(Xt, yt)

print ("############# based on standard predict ################")
print ("R^2 on training data: %0.4f" % (training_accuracy))
print ("R^2 on test data:     %0.4f" % (test_accuracy))
# Calculate the Root Mean Squared Error

rmse = np.sqrt(mean_squared_error(reg.predict(Xt),yt))
print ("RMSE = %0.3f (this is in log-space!)" % rmse)
print ("So two thirds of the records would be a factor of less than %0.2f \
	away from the real value." % np.power(10,rmse))
import operator
dict_feat_imp = dict(zip(list(predictor_space.columns.values),reg.feature_importances_))
sorted_features = sorted(dict_feat_imp.items(), key=operator.itemgetter(1), reverse=True)
sorted_features
```
    R^2 on training data: 0.9667
    R^2 on test data:     0.6886
    RMSE = 2.650 (this is in log-space!)
    So two thirds of the records would be a factor of less than 446.68 	away from the real value.
    
`Important Features Plot`

```python
csv=pd.DataFrame(sorted_features)
plt.figure();
csv[[0,1]].tail(10).plot(kind='barh', x=0, y=1,legend=False, figsize=(8, 8));
```

![png](images/chicago_1.png)

#### `LightGBM`

```python
estimator = LGBMRegressor(num_boost_round=1000, n_jobs=-1)
# Funtion for cross-validation over a grid of parameters
def cv_optimize(clf, parameters, X, y, n_jobs=1, n_folds=10, score_func=None, \
                verbose=0):
    if score_func:
        gs = GridSearchCV(clf, param_grid=parameters, cv=n_folds, \
                          n_jobs=n_jobs, scoring=score_func, verbose=verbose)
    else:
        gs = GridSearchCV(clf, param_grid=parameters, n_jobs=n_jobs,\
                         cv=n_folds, verbose=verbose)
    gs.fit(X, y)
    print ("BEST", gs.best_params_, gs.best_score_, gs.grid_scores_,\
            gs.scorer_)
    print ("Best score: ", gs.best_score_)
    best = gs.best_estimator_
    return best

# Define a grid of parameters over which to optimize gradient boosting
# We will figure out which number of trees is optimal
parameters = {'boosting_type': ['gbdt'],
            'objective': ['regression'],
            'metric': ['auc'],
            'num_leaves': [20,40,60,80],
            'learning_rate': [0.01,0.1],
            'bagging_fraction': [0.85],
            'bagging_freq': [20],
            'verbose': [1],
            'max_bin':[200]}
best = cv_optimize(estimator, parameters, X, y, n_folds=5,\
                    score_func='mean_squared_error', verbose=3)
# Fit the best Random Forest and calculate R^2 values for training and test sets
reg=best.fit(X, y)
training_accuracy = reg.score(X, y)
test_accuracy = reg.score(Xt, yt)
print ("############# based on standard predict ################")
print ("R^2 on training data: %0.4f" % (training_accuracy))
print ("R^2 on test data:     %0.4f" % (test_accuracy))
# Calculate the Root Mean Squared Error
rmse = np.sqrt(mean_squared_error(reg.predict(Xt),yt))
print ("RMSE = %0.3f (this is in log-space!)" % rmse)
print ("So two thirds of the records would be a factor of less than %0.2f \
	away from the real value." % np.power(10,rmse))
import operator
dict_feat_imp = dict(zip(list(predictor_space.columns.values),reg.feature_importances_))
sorted_features = sorted(dict_feat_imp.items(), key=operator.itemgetter(1), reverse=True)
sorted_features
```
    R^2 on training data: 0.8796
    R^2 on test data:     0.7405
    RMSE = 2.419 (this is in log-space!)
    So two thirds of the records would be a factor of less than 262.46 away from the real value.

`Important Features Plot`

```python
pd.DataFrame(sorted_features)[[0,1]].head(10).plot(kind='barh', x=0, y=1,legend=False, figsize=(8, 8));
```

![png](images/chicago_2.png)

#### RESULTS

Metrics R-squared and RMSE for training and testing data is shown below for each model.

| Model             |        | Model Metrics | Training | Testing |
|-------------------|--------|---------------|----------|---------|
| Linear Regression | Hourly | R-Squared     | 0.5258   | 0.5294  |
|                   |        | RMSE          | 3.0326   | 3.2577  |
|                   | Daily  | R-Squared     | 0.7287   | 0.5484  |
|                   |        | RMSE          | 19.5233  | 21.4986 |
| Random Forest     | Hourly | R-Squared     | 0.9668   | 0.6887  |
|                   |        | RMSE          | 0.80     | 2.65    |
|                   | Daily  | R-Squared     | 0.9726   | 0.6998  |
|                   |        | RMSE          | 6.20     | 17.528  |
| LightGBM          | Hourly | R-Squared     | 0.8796   | 0.7405  |
|                   |        | RMSE          | 1.52     | 2.419   |
|                   | Daily  | R-Squared     | 0.9497   | 0.7327  |
|                   |        | RMSE          | 8.40     | 16.54   |
