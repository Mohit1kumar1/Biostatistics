if (!require("openxlsx")) install.packages("openxlsx")
library(openxlsx)

set.seed(123)
num_rows <- 50

Wheat_DatasetQG <- data.frame(
  Sample_ID = paste0("Wheat_", seq(1, num_rows)),
  Genotype = sample(c("A", "B", "C", "D"), num_rows, replace = TRUE),
  Location = sample(c("Field_1", "Field_2", "Field_3"), num_rows, replace = TRUE),
  Replication = sample(1:3, num_rows, replace = TRUE),
  Grain_Weight = round(rnorm(num_rows, mean = 35, sd = 5), 2),  # grams
  Plant_Height = round(rnorm(num_rows, mean = 90, sd = 10), 1), # cm
  Days_to_Maturity = sample(100:150, num_rows, replace = TRUE),
  Yield = round(rnorm(num_rows, mean = 4.5, sd = 0.7), 2),      # tons/ha
  Protein_Content = round(runif(num_rows, min = 10, max = 15), 1), # %
  SNP_1 = sample(c(0, 1, 2), num_rows, replace = TRUE),
  SNP_2 = sample(c(0, 1, 2), num_rows, replace = TRUE),
  SNP_3 = sample(c(0, 1, 2), num_rows, replace = TRUE),
  SNP_4 = sample(c(0, 1, 2), num_rows, replace = TRUE),
  SNP_5 = sample(c(0, 1, 2), num_rows, replace = TRUE),
  Environment = sample(c("Drought", "Irrigated", "Heat"), num_rows, replace = TRUE)
)

write.xlsx(Wheat_DatasetQG, file = "Wheat_DatasetQG.xlsx", rowNames = FALSE)
cat("Wheat_DatasetQG.xlsx has been created in your working directory.\n")
