library("ISLR2")
library(ggplot2)
data("Boston", package = "ISLR2")

Boston <- as.data.frame(Boston)
pairs(Boston)

crim <- Boston$crim
zn <- Boston$zn

ggplot(Boston, aes(x = crim, y = zn)) +
  geom_point() +
  xlab("Per capita crime rate") +
  ylab("Proportion of residential land zoned over 25,000 sq.ft.")

# Correlation between each variables
cor(Boston)

model3 <- lm(crim ~ ., data = Boston)
summary(model3)

# Begin to perform feature selection
set.seed(6131)

#splitting dataset
index <- createDataPartition(Boston$crim, p = 0.8, list = FALSE)
train_data <- Boston[index, ]
test_data <- Boston[-index, ]
full_model <- lm(crim ~ ., data = train_data)
tets_data_y_bar <- mean(test_data$crim)

#Forward Stepwise Selection
reduced_model_forward <- step(full_model,direction = "forward",trace = 0, p = 0.1)
summary(reduced_model_forward)
for_prediction <- predict(reduced_model_forward, newdata = test_data)
for_MSE <- mean((tets_data_y_bar - for_prediction)^2)
sprintf("MSE: %.2f",for_MSE)


#Backward Stepwise Selection
reduced_model_backward <- step(full_model,direction = "backward",trace = 0, p = 0.1)
back_prediction <- predict(reduced_model_backward, newdata = test_data)
back_MSE <- mean((tets_data_y_bar - back_prediction)^2)
sprintf("MSE: %.2f",back_MSE)

#AIC select
aic_select <- step(full_model, scope = list(lower = train_data$Crime ~ 1, 
                                            upper = train_data$Crime ~ .),direction = "both")
aic_prediction <- predict(aic_select, newdata = test_data)
aic_MSE <- mean((tets_data_y_bar - aic_prediction)^2)
sprintf("MSE: %.2f",aic_MSE)

#BIC select
bic_select <- step(full_model, 
                   scope = list(lower = train_data$Crime ~ 1, 
                                upper = train_data$Crime ~ .),
                   direction = "forward", k = log(nrow(train_data)))
bic_prediction <- predict(bic_select, newdata = test_data)
bic_MSE <- mean((tets_data_y_bar - bic_prediction)^2)
sprintf("MSE: %.2f",bic_MSE)

#Mallows Cp
cp_select <- regsubsets(crim ~ ., data = train_data, method = "exhaustive")
cp_prediction <- predict(bic_select, newdata = test_data)
cp_MSE <- mean((tets_data_y_bar - cp_prediction)^2)
sprintf("MSE: %.2f",cp_MSE)




