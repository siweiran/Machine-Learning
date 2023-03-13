library(readr)
library(tree)
library(rpart)
library(rpart.plot)
library(caret)
library(randomForest)

Transaction <- read_csv("/Users/ran/Desktop/UCD Winter/BAX 452/Assign 6/Transaction.csv")
Transaction

# CART model
Transaction <- read_csv("/Users/ran/Desktop/UCD Winter/BAX 452/Assign 6/Transaction.csv")
set.seed(5230)
Transaction <- Transaction[-1]
Transaction$payment_default <- factor(Transaction$payment_default, levels = c(0, 1))
sample <- sample(c(TRUE, FALSE), nrow(Transaction), replace=TRUE, prob=c(0.8,0.2))
train  <- Transaction[sample, ]
test   <- Transaction[!sample, ]

class_tree_tran <- rpart(payment_default ~ ., data = train, method = "class",cp = 0.004)

rpart.plot(class_tree_tran, type = 4, extra = 1)

#model performance
preds <- predict(class_tree_tran, new_data = test, type = "class")
accuracy <- mean(preds == test$payment_default)
accuracy

### The output shows the accuracy of the classification model is 0.7062037. The computation speed of classification tree is faster.


# Random Forest
Transaction <- read_csv("/Users/ran/Desktop/UCD Winter/BAX 452/Assign 6/Transaction.csv")
set.seed(5230)
Transaction <- Transaction[-1]
Transaction$payment_default <- factor(Transaction$payment_default, levels = c(0, 1))
sample <- sample(c(TRUE, FALSE), nrow(Transaction), replace=TRUE, prob=c(0.8,0.2))
train  <- Transaction[sample, ]
test   <- Transaction[!sample, ]

ranfor_tran <- randomForest(payment_default ~ ., data = train, importance = TRUE)
# 
preds <- predict(ranfor_tran, newdata = test)
accuracy <- mean(preds == test$payment_default)
accuracy
### The output shows the accuracy of the classification model is 0.8129 The computation speed of classification tree
### is slower. The accuracy is higher than we use CART model. This makes sense because we use bootstrap in the random ### forest. Although this process is much slower than CART model, the accuracy will be higher.