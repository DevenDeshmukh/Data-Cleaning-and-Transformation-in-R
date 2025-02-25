# Load necessary libraries
library(readxl)
library(dplyr)
library(lubridate)

# Step 1: Load the Data and Inspect It
employees <- read_excel("Employees data.xlsx")

# Fix column names (remove spaces)
colnames(employees) <- gsub(" ", "_", colnames(employees))  # Replaces spaces with underscores

# Check column names
print(colnames(employees))

# Step 2: Handle Missing Values
employees$Name[is.na(employees$Name)] <- "Unknown"
employees$Department[is.na(employees$Department)] <- "Unassigned"

# Impute missing salaries with the average salary
avg_salary <- mean(employees$Salary, na.rm = TRUE)
employees$Salary[is.na(employees$Salary)] <- avg_salary

# Drop rows where Age or DOB is missing
employees <- employees[!is.na(employees$Age) & !is.na(employees$DOB), ]

# Step 3: Standardize Column Formats
employees$DOB <- as.Date(employees$DOB)
employees$Joining_Date <- as.Date(employees$Joining_Date)

# Convert Performance Score to a factor variable
employees$Performance_Score <- as.factor(employees$Performance_Score)

# Step 4: Create New Derived Columns
employees$Tenure_Years <- as.numeric(difftime(Sys.Date(), employees$Joining_Date, units = "days")) / 365

# Create "Experience Level" column based on tenure
employees$Experience_Level <- cut(
  employees$Tenure_Years,
  breaks = c(-Inf, 1, 5, 10, Inf),
  labels = c("Beginner", "Intermediate", "Experienced", "Veteran"),
  right = FALSE
)

# Save the cleaned dataset
write.csv(employees, "cleaned_employees.csv", row.names = FALSE)

# Print message upon successful completion
print("Data cleaning and transformation completed. Cleaned dataset saved as cleaned_employees.csv")
