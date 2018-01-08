
# Load data
plans <- read.csv(file = file.path("data", "PlanAttributes.csv"), header = T, na.strings = c("", " ", NA), stringsAsFactors = F)

benefits2015 <- read.csv(file = file.path("data", "benefits2015.csv"), header = T, na.strings = c("", " ", NA), stringsAsFactors = F)
rates2015 <- read.csv(file = file.path("data", "rates2015.csv"), header = T, na.strings = c("", " ", NA), stringsAsFactors = F)
plans2015 <- subset(plans, plans$BusinessYear == 2015)

benefits2016 <- read.csv(file = file.path("data", "benefits2016.csv"), header = T, na.strings = c("", " ", NA), stringsAsFactors = F)
rates2016 <- read.csv(file = file.path("data", "rates2016.csv"), header = T, na.strings = c("", " ", NA), stringsAsFactors = F)
plans2016 <- subset(plans, plans$BusinessYear == 2016)
pol2012 <- read.csv(file = file.path("data", "political2012.csv"), header = T, na.strings = c("", " ", NA), stringsAsFactors = F)
pol2016 <- read.csv(file = file.path("data", "political2016.csv"), header = T, na.strings = c("", " ", NA), stringsAsFactors = F)
