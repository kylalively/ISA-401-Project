## ENTERING BY AGE GROUP
library(readxl)

raw_data <- read_excel("G:\\My Drive\\Junior Semester 1\\ISA 401\\ISA 401\\ISA Project\\Children entering foster care by age group.xlsx")

library(dplyr)
library(tidyr)

enter_by_age <- raw_data %>%
  pivot_wider(names_from = DataFormat, values_from = Data) %>%
  mutate(Percent = as.numeric(Percent))

enter_by_age <- subset(enter_by_age, !(LocationType %in% c('Nation', 'City', 'Territory')))
enter_by_age$Percent <- NULL
enter_by_age$LocationType <- NULL
enter_by_age <- rename(enter_by_age, EnteringNumber = Number)
enter_by_age$TimeFrame <- as.numeric(enter_by_age$TimeFrame)
enter_by_age$TimeFrame <- as.Date(paste(enter_by_age$TimeFrame, "01", "01", sep = "-"), format = "%Y-%m-%d")

enter_by_age <- filter(enter_by_age, TimeFrame >= as.Date("2000-01-01"))

## EXITING BY AGE GROUP 
raw_data <- read_excel("G:\\My Drive\\Junior Semester 1\\ISA 401\\ISA 401\\ISA Project\\Children exiting foster care by age group.xlsx")

exiting_by_age <- raw_data %>%
  pivot_wider(names_from = DataFormat, values_from = Data) %>%
  mutate(Percent = as.numeric(Percent)) 

exiting_by_age <- subset(exiting_by_age, !(LocationType %in% c('Nation', 'City', 'Territory')))
exiting_by_age <- rename(exiting_by_age, ExitingNumber = Number)
exiting_by_age$Percent <- NULL
exiting_by_age$LocationType <- NULL
exiting_by_age$TimeFrame <- as.numeric(exiting_by_age$TimeFrame)
exiting_by_age$TimeFrame <- as.Date(paste(exiting_by_age$TimeFrame, "01", "01", sep = "-"), format = "%Y-%m-%d")

exiting_by_age <- filter(exiting_by_age, TimeFrame >= as.Date("2000-01-01"))

## ADOPTION by AGE GROUp 
raw_data <- read_excel("G:\\My Drive\\Junior Semester 1\\ISA 401\\ISA 401\\Adopted by age group Updated.xlsx")

adopted_by_age <- raw_data %>%
  pivot_wider(names_from = DataFormat, values_from = Data) %>%
  mutate(Percent = as.numeric(Percent))

adopted_by_age <- subset(adopted_by_age, !(LocationType %in% c('Nation', 'City', 'Territory')))
adopted_by_age <- rename(adopted_by_age, AdoptionNumber = Number)
adopted_by_age$Percent <- NULL
adopted_by_age$LocationType <- NULL
adopted_by_age$TimeFrame <- as.numeric(adopted_by_age$TimeFrame)
adopted_by_age$TimeFrame <- as.Date(paste(adopted_by_age$TimeFrame, "01", "01", sep = "-"), format = "%Y-%m-%d")

## CHILD POPULATION BY AGE GROUP
raw_data <- read_excel("G:\\My Drive\\Junior Semester 1\\ISA 401\\ISA 401\\Child population by single age.xlsx")

child_pop <- raw_data %>%
  pivot_wider(names_from = DataFormat, values_from = Data) %>%
  subset(!(LocationType %in% c('Nation', 'City', 'Territory'))) %>%
  rename(ChildPopulation = Number) %>%
  filter(`Single Age` != 'Total 18 and below') %>%
  mutate(`Single Age` = ifelse(`Single Age` == '<1', 0, suppressWarnings(as.numeric(`Single Age`)))) %>%
  mutate(`Age group` = cut(`Single Age`, breaks = c(-Inf, 1, 6, 11, 16, Inf), labels = c('<1', '1 to 5', '6 to 10', '11 to 15', '16 to 20'), right = FALSE)) %>%
  mutate(TimeFrame = as.Date(paste(TimeFrame, "01", "01", sep = "-"), format = "%Y-%m-%d")) %>%
  mutate(ChildPopulation = as.numeric(ChildPopulation)) %>%
  select(`Age group`, TimeFrame, ChildPopulation, Location) %>%
  filter(TimeFrame >= as.Date("2000-01-01")) %>%
  group_by(`Age group`, TimeFrame, Location) %>%
  summarise(ChildPopulation = sum(ChildPopulation, na.rm = TRUE), .groups = 'drop')

## COMBINING DATA
entering_and_exiting_data <- enter_by_age %>%
  full_join(exiting_by_age, by = c( "Location", "Age group", "TimeFrame")) |> 
  full_join(adopted_by_age, by = c( "Location", "Age group", "TimeFrame")) |> 
  full_join(child_pop, by = c( "Location", "Age group", "TimeFrame")) 
entering_and_exiting_data$LocationType <- NULL
entering_and_exiting_data <- entering_and_exiting_data %>%
  filter(`Age group` != 'Total')
entering_and_exiting_data <- entering_and_exiting_data %>%
  filter(TimeFrame < as.Date("2022-01-01"))


## CSV AND REPORT
write.csv(entering_and_exiting_data, 'Final_Data_by_Age.csv', row.names = FALSE)

create_report(entering_and_exiting_data, output_file = "Child Data by Age Report.html")
