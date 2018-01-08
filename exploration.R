# Data exploration Scripts and Visualisations
source ('./dataLoader.R')
source('./preprocesing.R')

states2016 <- get_state_features(plans2016, rates2016, benefits2016)
states2016 <- merge(states, pol, by = 'State')
states$Color <- as.factor(states$Color)
states <- subset(states, states$NumAbortionPlans > 0)
ggplot(data=states, aes(x=PercentageAbortionPlans, y=ExtraPay)) + geom_point(aes(colour=Color))
print(pol2016)


states2015 <- get_state_features(plans2015, rates2015, benefits2015)