install.packages("openxlsx")    # For reading Excel files
install.packages("rrBLUP")      # For GWAS
install.packages("qtl")         # For QTL analysis

library(openxlsx)  
library(rrBLUP)    
library(qtl)     

# Load the dataset
wheat_data <- read.xlsx("Wheat_DatasetQG.xlsx")

# Extract phenotype and genotype data
phenotype <- wheat_data[, c("Sample_ID", "Grain_Weight", "Plant_Height", "Yield")]
genotype <- wheat_data[, c("Sample_ID", "SNP_1", "SNP_2", "SNP_3", "SNP_4", "SNP_5")]

# Save phenotype and genotype to CSV files for reference
write.csv(phenotype, "phenotype.csv", row.names = FALSE)
write.csv(genotype, "genotype.csv", row.names = FALSE)

# Convert genotype data into numeric format (if required)
genotype_matrix <- as.matrix(genotype[, -1])  # Exclude Sample_ID
rownames(genotype_matrix) <- genotype$Sample_ID

# Check the structure of both datasets
str(phenotype)
str(genotype_matrix)

# Check the dimensions
dim(phenotype)
dim(genotype_matrix)

# Inspect `Sample_ID` in `phenotype` and rownames in `genotype_matrix`
head(phenotype$Sample_ID)
head(rownames(genotype_matrix))

# Identify mismatched IDs
missing_in_genotype <- setdiff(phenotype$Sample_ID, rownames(genotype_matrix))
missing_in_phenotype <- setdiff(rownames(genotype_matrix), phenotype$Sample_ID)

cat("Missing in genotype:", missing_in_genotype, "\n")
cat("Missing in phenotype:", missing_in_phenotype, "\n")



# GWAS using rrBLUP
gwas_results <- GWAS(
  pheno = phenotype,                  # Phenotypic data
  geno = genotype_matrix,             # Genotypic data
  P3D = TRUE                          # Compressed mixed model
)

# Save GWAS results
write.csv(gwas_results, "GWAS_Results.csv", row.names = TRUE)

# View top GWAS results
head(gwas_results)


# Create a cross object for QTL analysis
cross <- read.cross(
  format = "csv",
  genfile = "genotype.csv",
  phefile = "phenotype.csv",
  genotypes = c("AA", "AB", "BB")
)

# Estimate genetic map
cross <- est.map(cross)

# Perform single-QTL scan
qtl_results <- scanone(cross, method = "hk")  # Haley-Knott regression

# Plot LOD scores
plot(qtl_results)

# Identify significant QTLs
significant_qtl <- summary(qtl_results, threshold = 3)  # Adjust threshold

# Save QTL results
write.csv(qtl_results, "QTL_Results.csv", row.names = TRUE)

# View top QTL findings
print(significant_qtl)


manhattan <- function(gwas_results) {
  plot(
    -log10(gwas_results$P.Value),
    main = "Manhattan Plot",
    xlab = "SNPs",
    ylab = "-log10(p-value)",
    pch = 19,
    col = "blue"
  )
}
manhattan(gwas_results)

plot(qtl_results, main = "LOD Score Plot")
