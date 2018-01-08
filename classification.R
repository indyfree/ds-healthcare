library("e1071")

#source ('./dataLoader.R')
source('./preprocesing.R')

# Prepare data and Label
states2015 <- get_state_features(plans2015, rates2015, benefits2015)
states2016 <- get_state_features(plans2016, rates2016, benefits2016)
states <- rbind(states2015, states2016)

states <- merge(states, pol2012, by = 'State')
states$Color <- as.factor(states$Color)

# Select Features
feat_list <- c('PercentageAbortionPlans', 'ExtraPay', 'MeanCopay')
states <- states[c(feat_list, 'Color')]

# Perform Classification and Cross Validation
source('./k_fold.R')
set.seed(47)
test_acc <- c()
for (i in 1:20) {
  accs <- performKFold(3, states)
  test_acc <- c(test_acc, mean(accs$testing))
  #print(mean(accs$testing))
}
print(mean(test_acc))

# Perform Logistical Regression to validate results
logit <- glm(Color~., family = binomial(link = logit), data = states)
summary(logit)

