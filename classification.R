library("e1071")

source ('./dataLoader.R')
source('./preprocesing.R')

states <- get_state_features(plans, rates, benefits)

# 4. Merge political orientation (Label)
states <- merge(states, pol, by = 'State')
states$Color <- as.factor(states$Color)

# 5. Shuffle Data and split into training and testing
states <-states[sample(nrow(states)),]
train <- states[1:(nrow(states)/2),]
test <- states[(nrow(states)/2):nrow(states),]

# 6. Train Classifier
features <- train[c('PercentageAbortionPlans', 'ExtraPay')]
target <- train$Color
svm <- trainSVM(features, target)
calcAccuracy(svm, features, target)

# 7. Test Classifier
features <- test[c('PercentageAbortionPlans', 'ExtraPay')]
target <- test$Color
calcAccuracy(svm, features, target)

# Training Functions
calcAccuracy <- function(model, features, target) {
  prediction <- predict(model, features, scale = F)
  print(prediction)
  cm <- table(prediction,target)
  return(sum(diag(cm))/sum(cm))
}

trainSVM <- function(features, target, gamma = (1/ncol(features)), cost = 1) {
  model <- svm(features, target, gamma = gamma, cost = cost, scale=F, type='C')
  return(model)
}