# Data exploration Scripts and Visualisations

benefits <- read.csv(file = file.path("data", "benefits2016.csv"), header = T, na.strings = c("", " ", NA), stringsAsFactors = F)
plans <- read.csv(file = file.path("data", "PlanAttributes.csv"), header = T, na.strings = c("", " ", NA), stringsAsFactors = F)
rates <- read.csv(file = file.path("data", "rates2016.csv"), header = T, na.strings = c("", " ", NA), stringsAsFactors = F)
pol <- read.csv(file = file.path("data", "political_orientation.csv"), header = T, na.strings = c("", " ", NA), stringsAsFactors = F)

source('./preprocesing.R')
states <- get_state_features(plans, rates, benefits)
states <- merge(states, pol, by = 'State')
states$Color <- as.factor(states$Color)

states <- subset(states, states$NumAbortionPlans > 0)

ggplot(data=states, aes(x=PercentageAbortionPlans, y=ExtraPay)) + geom_point(aes(colour=Color))
