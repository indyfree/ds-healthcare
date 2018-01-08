library('ggplot2') # visualization
library('ggthemes') # visualization
# Data exploration Scripts and Visualisations
source ('./dataLoader.R')
source('./preprocesing.R')

states2016 <- get_state_features(plans2016, rates2016, benefits2016)
states2016 <- merge(states2016, pol2012, by = 'State')
states2016$Color <- as.factor(states2016$Color)
#states2016 <- subset(states2016, states2016$NumAbortionPlans > 0)
#ggplot(data=states2016, aes(x=State, y=NumAbortionPlans)) + geom_point(aes(colour=Color))


states2015 <- get_state_features(plans2015, rates2015, benefits2015)
states2015 <- merge(states2015, pol2012, by = 'State')
states2015$Color <- as.factor(states2015$Color)
#states2015 <- subset(states2015, states2015$NumAbortionPlans > 0)

#summary(states2015)
#ggplot(data=states2015, aes(x=PercentageAbortionPlans, y=MeanCoins)) + geom_point(aes(colour=Color))


p1 <- ggplot(data=states2015, aes(x=State, y=NumAbortionPlans, fill=Color)) + geom_bar(stat='identity') + ggtitle("Abortion Plans per State 2015")
p1 <- p1 + theme(
  axis.title.x = element_blank(),
  axis.title.y = element_blank())
p2 <- ggplot(data=states2016, aes(x=State, y=NumAbortionPlans, fill=Color)) + geom_bar(stat='identity') + ggtitle("Abortion Plans per State 2016")
p2 <- p2 + theme(
  axis.title.x = element_blank(),
  axis.title.y = element_blank())
multiplot(p1, p2)

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
