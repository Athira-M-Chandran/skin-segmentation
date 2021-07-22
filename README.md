# Skin Segmentation
Prediction of skin and non-skin can be done based on the evaluation of blue, green and red  pixels. 
#### Abstract
The skin segmentation dataset is constructed over blue, green, red color space. The skin dataset 
is collected by randomly sampling B, G, R values from face images of various age groups (young, 
middle, and old), race groups (white, black, and Asian), and genders obtained from FERET 
database and PAL database. Total learning sample size is 245057; out of which 50859 is skin 
samples and 194198 is non-skin samples.
#### Loading dataset
`skin<- read.csv("c:/data/Skin_Nonskin.csv") `
#### Data Exploration
Explore data to get an idea about its structure

`View(skin)`

`str(skin) # displays internal structure`

`summary(skin) # statistical summary of every variable in the dataset`

`head(skin)   # Displays top 6 values`
#### Data Visualization
Box plot representation is shown below:

`boxplot(skin[,1:3])`

Box plot is used to represent descriptive statistics of each variable in a dataset. It represents the 
minimum, first quartile, median, third quartile, and the maximum values of a variable.
#### Splitting dataset
First step is to partition the dataset as training and testing data. ‘caTools ‘package is used to 
make a balanced partitioning.

`sample_data = sample.split(skin, SplitRatio = 0.75) #splitting the rows`

`train <- subset(skin, sample_data == TRUE) #logic TRUE values move to train data`

`test <- subset(skin, sample_data == FALSE) #logic FALSE data move to test`
#### Data Analytics Techniques
### 1. Naive Bayes
Here the dataset contains 245057 samples. It has different blue, green, red pixels to identify 
whether it is skin or non-skin. For classifying this Naïve Bayes classification technique can be 
used.

Now utilize ‘e1071’ package for classifying

`skin_bayes <- naiveBayes(skin_color ~ ., data = train)`

Prediction is done on test data because higher test accuracy is found on test data.

`pred <- predict(skin_bayes, newdata = test)`

Accuracy is determined using confusion matrix. ‘caret’ package is used for confusion matrix.

`skin_matrix <- table(test$skin_color, pred) `
`confusionMatrix(skin_matrix) #Model evaluation`
##### Result
In the above result, from the prediction table, 9361 out of 10659 are able to be classified as skin 
and 47251 out of 50605 are able to be classified as non-skin. So, the accuracy to predict skin is 
87.8% and the accuracy to predict non skin is 93.37%. This results in an overall accuracy of 
**92.41%.
**
### 2. Decision Tree

Decision tree is a type of supervised learning algorithm mostly used for classification problem. 
This algorithm split the data into two or more homogeneous sets based on the most significant 
attributes making the group as distinct as possible.

For implementing decision tree ‘rpart’ package is imported and ‘rpart.plot’ package will help to 
get a visual plot of a decision tree.

`skin_decision <- rpart(formula = skin_color ~.,
 data = train,
 method = "class",
 control = rpart.control(cp = 0),
 parms = list(split = "information"))`
 
`rpart.plot(skin_decision,type= 4 , extra=1)`

![Decision Tree](https://github.com/Athira-M-Chandran/skin-segmentation/blob/69f7f016e7675d1c47cb0a273d8e13122aece4d0/decision_tree.png?raw=true)

Predict the dataset as skin or non-skin using predict() on test.

`skin_pred <- predict(object = skin_decision,
 newdata = test,
 type = "class")`
 
 Here also the accuracy is determined using confusion matrix. 
 
`skin_dec_matrix <- table(test$skin_color, skin_pred)`

`confusionMatrix(skin_dec_matrix) #model evaluation`
#### Result
In the above result, from the prediction table, 12696 out of 12736 are able to be classified as 
skin and 48509 out of 48528 are able to be classified as non-skin. So, the accuracy to predict 
skin is 99.69% and the accuracy to predict non skin is 99.96%. This results in an overall accuracy 
of **99.90%**.

### Conclusion
The accuracy of Naïve Bayes to predict skin and non-skin on bases of green, blue, red is **92.41%**
and for Decision tree is **99.90%**. From the overall result it is clear that Decision tree is more 
accurate compared to Naïve Bayes
