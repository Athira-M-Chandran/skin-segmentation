##############  PACKAGES  #############


library(grid)
library(gridExtra)
library(caTools)

library(ggplot2)

library(e1071)
library(lattice)

library(caret)

library(rpart)
library(rpart.plot)


###########  DATA EXPLORATION  ##########

skin<- read.csv("c:/data/Skin_Nonskin.csv")
View(skin)
str(skin)     #displays internal structure
summary(skin) #displays descriptive statistics of every variable in the dataset
head(skin)    #displays top 6 values

###########  DATA VISUALIZATION  ##########

boxplot(skin[,1:3])    #represent descriptive statistics of each variable

#Histogram representation
# Blue component
B <- ggplot(data=skin, aes(x=B))+
  geom_histogram(binwidth=5, color = "blue", aes(fill=as.factor(skin_color))) + 
  xlab("Blue Pixel") +  
  ylab("Frequency") + 
  theme(legend.position="none")+
  ggtitle("Histogram of Blue")+
  geom_vline(data=skin, aes(xintercept = mean(B)),linetype="dashed",color="black")

# Green
G <- ggplot(data=skin, aes(x=G))+
  geom_histogram(binwidth=5, color="black", aes(fill=as.factor(skin_color))) + 
  xlab("Green pixel") +  
  ylab("Frequency") + 
  theme(legend.position="none")+
  ggtitle("Histogram of Green")+
  geom_vline(data=skin, aes(xintercept = mean(G)),linetype="dashed",color="black")

# Red
R <- ggplot(data=skin, aes(x=R))+
  geom_histogram(binwidth=5, color="black", aes(fill = as.factor(skin_color))) + 
  xlab("Red Pixel") +  
  ylab("Frequency") + 
  theme(legend.position="right")+
  ggtitle("Histogram of Red")+
  geom_vline(data=skin, aes(xintercept = mean(R)),linetype="dashed",color="black")

pos <- theme(legend.position="right")
# Plot all visualizations
grid.arrange(B,
             G ,
             R ,
             nrow = 3,
             top = textGrob("Skin Non-skin Frequency Histogram", 
                            gp=gpar(fontsize=15))
)

skin$skin_color <- factor(skin$skin_color, 
                   levels = c (1, 2), 
                   labels = c (0,1)) 

#splitting the rows
sample_data = sample.split(skin, SplitRatio = 0.75)
train <- subset(skin, sample_data == TRUE)
test <- subset(skin, sample_data == FALSE)

#############  NAIVE BAYES     ############



# set seed function get same result each time
set.seed(120)  
skin_bayes <- naiveBayes(skin_color ~ . , data = train)
skin_bayes

# Predicting on test data'
pred <- predict(skin_bayes, newdata = test)

# Confusion Matrix
skin_matrix <- table(test$skin_color, pred)
skin_matrix

# Model Evaluation
confusionMatrix(skin_matrix)


#############  DECISION TREE   ############

skin_decision <- rpart(formula = skin_color ~.,
                       data = train,
                       method = "class",
                       control = rpart.control(cp = 0),
                       parms = list(split = "information"))
print(skin_decision)

# Plot
rpart.plot(skin_decision,type= 4 , extra= 1)

# Predicting on test data
skin_pred <- predict(object = skin_decision,
                     newdata = test,
                     type = "class")
# Model Evaluation
skin_dec_matrix <- table(test$skin_color, skin_pred)

# Confusion Matrix
confusionMatrix(skin_dec_matrix)


############ Logistic Regression ###################



skin_log <- glm(skin_color ~ ., family = binomial(link = "logit") , data = train)
skin_log

skin_pred_log <- predict(object = skin_log,
                         newdata = test,
                         type = "response")
skin_pred_log
skin_prediction <- ifelse(skin_pred_log > 0.5, 1, 0)
skin_log_matrix <- table(test$skin_color, skin_prediction)
confusionMatrix(skin_log_matrix)
