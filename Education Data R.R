library(readxl)
library(dplyr)
library(tidyr)

## EDUCATION DATA AGES 25-64
education_data <- read_excel("G:\\My Drive\\Junior Semester 1\\ISA 401\\ISA 401\\Educational attainment of working age population ages 25 to 64.xlsx")

education_data <- education_data %>%
  pivot_wider(names_from = DataFormat, values_from = Data) %>%
  mutate(Percent = as.numeric(Percent))

education_data <- subset(education_data, !(LocationType %in% c('Nation', 'City', 'Territory')))
education_data$Percent <- NULL
education_data$LocationType <- NULL
education_data <- rename(education_data, EducationNumber = Number)
education_data$TimeFrame <- as.numeric(education_data$TimeFrame)
education_data$TimeFrame <- as.Date(paste(education_data$TimeFrame, "01", "01", sep = "-"), format = "%Y-%m-%d")

education_data <- filter(education_data, TimeFrame >= as.Date("2010-01-01"), TimeFrame < as.Date("2020-01-01"))


## ADULT POPULATION AGES 25-64
pop_data <- read_excel("G:\\My Drive\\Junior Semester 1\\ISA 401\\ISA 401\\Adult population by age group.xlsx")

pop_data <- pop_data %>%
  pivot_wider(names_from = DataFormat, values_from = Data) %>%
  mutate(Percent = as.numeric(Percent))

pop_data <- subset(pop_data, !(LocationType %in% c('Nation', 'City', 'Territory')))
pop_data$Percent <- NULL
pop_data$LocationType <- NULL
pop_data <- rename(pop_data, Population = Number)
pop_data$TimeFrame <- as.numeric(pop_data$TimeFrame)
pop_data$TimeFrame <- as.Date(paste(pop_data$TimeFrame, "01", "01", sep = "-"), format = "%Y-%m-%d")

pop_data <- filter(pop_data, TimeFrame >= as.Date("2010-01-01"), TimeFrame < as.Date("2020-01-01"))
pop_data <- filter(pop_data, `Age group` == "25 to 64")
pop_data$`Age group` <- NULL

education_pop_data <- education_data |> 
  full_join(pop_data, by = c("Location", "TimeFrame"))

write.csv(education_pop_data, 'Education_Data.csv', row.names = FALSE)

install.packages("DataExplorer")
library(DataExplorer)

create_report(education_pop_data, output_file = "report.html")
