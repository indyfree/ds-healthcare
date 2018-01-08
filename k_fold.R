library("e1071")
library("randomForest")

performKFold <- function(k, df, tune=F) {
  accuracy <- data.frame(training = numeric(k), testing = numeric(k))
  
  # Create Folds
  df<-df[sample(nrow(df)),]
  folds <- cut(seq(1,nrow(df)),breaks=k,labels=FALSE)
  label <- df[,c('Color')]
  data <- df[, 1:ncol(df)-1]
  
  for (i in 1:k) {
    # Split up data
    test <- which(folds==i,arr.ind=TRUE)
    
    # Train Model
    #model <- trainSVM(data[-c(test),], label[-c(test)])
    model <- trainRF(data[-c(test),], label[-c(test)])
    #print(importance(model))
    
    # Calculate Training Accuracy
    accuracy$training[i] <- calcAccuracy(model, data[-c(test),], label[-c(test)])

    # Calculate Test Set Accuracies
    accuracy$testing[i] <- calcAccuracy(model, data[test,], label[test])
  }
  return(accuracy)
}

calcAccuracy <- function(model, features, target) {
  prediction <- predict(model, features, scale = F)
  cm <- table(prediction,target)
  return(sum(diag(cm))/sum(cm))
}

trainSVM <- function(features, target, gamma = (1/ncol(features)), cost = 1) {
  model <- svm(features, target, gamma = gamma, cost = cost, scale=F, type='C')
  return(model)
}

trainRF <- function(features, target) {
  model <- randomForest(features, target)
  return(model)
}
