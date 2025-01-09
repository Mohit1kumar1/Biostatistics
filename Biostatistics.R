install.packages("car")
install.packages("lme4")
install.packages("emmeans")
install.packages("readxl")
library(ggplot2)
library(dplyr)
library(car)
library(lme4)
library(emmeans)

# Read the wheat dataset
wheat_data <- readxl::read_excel("Wheat_Dataset.xlsx")
head(wheat_data)
# 1. Analysis of Variance (ANOVA)
# Comparing Yield across Varieties
anova_result <- aov(Yield_tons_per_hectare ~ Variety, data = wheat_data)
summary(anova_result)

# Visualizing the data for ANOVA
ggplot(wheat_data, aes(x = Variety, y = Yield_tons_per_hectare)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Yield by Wheat Variety", x = "Variety", y = "Yield (tons/ha)")
  
# 2. Multiple Pairwise Comparisons and Linear Contrasts
# Using Tukey's Honest Significant Difference (HSD) test
pairwise <- TukeyHSD(anova_result)
print(pairwise)

# Linear contrasts for specific comparisons
contrast_result <- emmeans(anova_result, pairwise ~ Variety, adjust = "none")
summary(contrast_result)

# 3. Balanced Multi-factor ANOVA
# Simulating balanced data for demonstration
balanced_data <- data.frame(
  Variety = rep(c("A", "B", "C"), each = 20),
  Fertilizer = rep(c("F1", "F2"), times = 30),
  Yield = rnorm(60, mean = 4.5, sd = 0.5)
)

# Two-way ANOVA
balanced_anova <- aov(Yield ~ Variety * Fertilizer, data = balanced_data)
summary(balanced_anova)

# Interaction plot
interaction.plot(
  x.factor = balanced_data$Fertilizer,
  trace.factor = balanced_data$Variety,
  response = balanced_data$Yield,
  type = "b",
  col = 1:3,
  pch = c(19, 17, 15)
)

# 4. Experimental Designs
# Simulating a randomized block design
set.seed(123)
block_data <- data.frame(
  Block = rep(1:5, each = 4),
  Treatment = rep(c("T1", "T2", "T3", "T4"), times = 5),
  Response = rnorm(20, mean = 10, sd = 2)
)

# ANOVA for randomized block design
block_anova <- aov(Response ~ Treatment + Block, data = block_data)
summary(block_anova)

# 5. Matrix Algebra
# Demonstrating matrix calculations
X <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 2, ncol = 3)
Y <- matrix(c(7, 8, 9, 10, 11, 12), nrow = 3, ncol = 2)
result <- X %*% Y
print(result)

# 6. Mixed Linear Models
# Simulating data for a mixed model
mixed_data <- data.frame(
  Variety = rep(c("A", "B", "C"), each = 10),
  Location = rep(c("Loc1", "Loc2"), times = 15),
  Yield = rnorm(30, mean = 4.5, sd = 0.5)
)

# Fitting a mixed-effects model
mixed_model <- lmer(Yield ~ Variety + (1 | Location), data = mixed_data)
summary(mixed_model)

# Extracting and plotting estimated marginal means
emmeans_result <- emmeans(mixed_model, ~ Variety)
plot(emmeans_result)

# End of script
