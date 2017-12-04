# Data exploration Scripts and first Visualisations

# Set working directory to current file location (requires Rstudio as an IDE)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
rates <- read.csv(file = file.path("data", "rates2016.csv"), header = T, stringsAsFactors = F)
benefits <- read.csv(file = file.path("data", "benefits2016.csv"), header = T, stringsAsFactors = F)
networks <- read.csv(file = file.path("data", "networks2016.csv"), header = T, stringsAsFactors = F)
plans <- read.csv(file = file.path("data", "PlanAttributes.csv"), header = T, stringsAsFactors = F)
plans <- plans[plans$BusinessYear == "2016", ]


summary(rates)
head(rates$PlanId)
paste("Rates:", length(unique(rates$PlanId)), "different plans (ids)")


summary(benefits)
head(benefits$BenefitName)
head(benefits$PlanId)
paste("Benefits:", length(unique(benefits$PlanId)), "different plans (ids)")

summary(networks)
head(networks$NetworkName, 20)
head(networks$NetworkId, 50)

# Networks == Plans?
paste("Networks:", length(unique(networks$NetworkId)), "different network (ids)")
paste("Networks:", length(networks$NetworkId), "number of networks in dataset (why doubles)")


summary(plans)
head(plans$PlanId, 50)
head(plans$NetworkId, 50)

