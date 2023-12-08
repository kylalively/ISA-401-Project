# ISA 401 Birth Rate By state (per 1000 people)
library(httr) 
library(rvest)
library(DataExplorer)

url <- "https://usafacts.org/metrics/birth-rate-by-state/"

response <- GET(url)

selectors <- c(
  ".jss144", 
  ".jss144+ .MuiTableCell-sizeSmall", 
  ".MuiTableCell-sizeSmall:nth-child(3)", 
  ".MuiTableCell-sizeSmall:nth-child(4)", 
  ".MuiTableCell-sizeSmall:nth-child(5)", 
  ".MuiTableCell-sizeSmall:nth-child(6)", 
  ".MuiTableCell-sizeSmall:nth-child(7)", 
  ".MuiTableCell-sizeSmall:nth-child(8)", 
  ".MuiTableCell-sizeSmall:nth-child(9)", 
  ".MuiTableCell-sizeSmall:nth-child(10)", 
  ".MuiTableCell-sizeSmall:nth-child(11)", 
  ".MuiTableCell-sizeSmall:nth-child(12)", 
  ".MuiTableCell-sizeSmall:nth-child(13)", 
  ".MuiTableCell-sizeSmall:nth-child(14)",
  ".MuiTableCell-sizeSmall:nth-child(15)",
  ".MuiTableCell-sizeSmall:nth-child(16)",
  ".MuiTableCell-sizeSmall:nth-child(17)",
  ".MuiTableCell-sizeSmall:nth-child(18)",
  ".MuiTableCell-sizeSmall:nth-child(19)",
  ".MuiTableCell-sizeSmall:nth-child(20)",
  ".MuiTableCell-sizeSmall:nth-child(21)",
  ".MuiTableCell-sizeSmall:nth-child(22)",
  ".MuiTableCell-sizeSmall:nth-child(23)",
  ".MuiTableCell-sizeSmall:nth-child(24)",
  ".MuiTableCell-sizeSmall:nth-child(25)",
  ".MuiTableCell-sizeSmall:nth-child(26)",
  ".MuiTableCell-sizeSmall:nth-child(27)",
  ".MuiTableCell-sizeSmall:nth-child(28)",
  ".MuiTableCell-sizeSmall:nth-child(29)",
  ".MuiTableCell-sizeSmall:nth-child(30)",
  ".MuiTableCell-sizeSmall:nth-child(31)",
  ".MuiTableCell-sizeSmall:nth-child(32)",
  ".MuiTableCell-sizeSmall:nth-child(33)",
  ".MuiTableCell-sizeSmall:nth-child(34)",
  ".MuiTableCell-sizeSmall:nth-child(35)",
  ".MuiTableCell-sizeSmall:nth-child(36)",
  ".MuiTableCell-sizeSmall:nth-child(37)",
  ".MuiTableCell-sizeSmall:nth-child(38)",
  ".MuiTableCell-sizeSmall:nth-child(39)",
  ".MuiTableCell-sizeSmall:nth-child(40)",
  ".MuiTableCell-sizeSmall:nth-child(41)",
  ".MuiTableCell-sizeSmall:nth-child(42)",
  ".MuiTableCell-sizeSmall:nth-child(43)",
  ".MuiTableCell-sizeSmall:nth-child(44)",
  ".MuiTableCell-sizeSmall:nth-child(45)",
  ".MuiTableCell-sizeSmall:nth-child(46)",
  ".MuiTableCell-sizeSmall:nth-child(47)",
  ".MuiTableCell-sizeSmall:nth-child(48)",
  ".MuiTableCell-sizeSmall:nth-child(49)",
  ".MuiTableCell-sizeSmall:nth-child(50)",
  ".MuiTableCell-sizeSmall:nth-child(51)", 
  ".MuiTableCell-sizeSmall:nth-child(52)"
)


page <- read_html(url)
data_list <- lapply(selectors, function(selector) {
  page %>%
    html_nodes(selector) %>%
    html_text() %>%
    trimws()  # Trim leading and trailing whitespaces
})



scraped_data_birth_rate <- data.frame(data_list)


scraped_data_birth_rate1 <- data.frame(
  Years=data_list[[1]], 
  Utah=data_list[[2]], 
  Vermont=data_list[[3]], 
  Virginia=data_list[[4]], 
  Washington=data_list[[5]], 
  West_Virginia=data_list[[6]], 
  Wisconsin=data_list[[7]], 
  Wyoming=data_list[[8]], 
  Alabama=data_list[[9]], 
  Alaska=data_list[[10]], 
  Florida=data_list[[11]], 
  Georgia=data_list[[12]],
  Hawaii=data_list[[13]],
  Idaho=data_list[[14]], 
  Illinois=data_list[[15]], 
  Indiana=data_list[[16]],
  Iowa=data_list[[17]],
  New_Jersey=data_list[[18]],
  New_Mexico=data_list[[19]],
  New_York=data_list[[20]],
  North_Carolina=data_list[[21]],
  North_Dakota=data_list[[22]],
  Ohio=data_list[[23]],
  Oklahoma=data_list[[24]], 
  Arizona=data_list[[25]], 
  Arkansas=data_list[[26]],
  California=data_list[[27]],
  Colorado=data_list[[28]],
  Connecticut=data_list[[29]],
  Delaware=data_list[[30]],
  District_of_Columbia=data_list[[31]], 
  Oregon=data_list[[32]],
  Pennsylvania=data_list[[33]],
  Rhode_Island=data_list[[34]],
  South_Carolina=data_list[[35]],
  South_Dakota=data_list[[36]],
  Tennessee=data_list[[37]],
  Texas=data_list[[38]],
  Kansas=data_list[[39]],
  Kentucky=data_list[[40]],
  Louisiana=data_list[[41]],
  Maine=data_list[[42]],
  Maryland=data_list[[43]],
  Massachusetts=data_list[[44]],
  Michigan=data_list[[45]],
  Minnesota=data_list[[46]],
  Mississippi=data_list[[47]],
  Missouri=data_list[[48]],
  Montana=data_list[[49]],
  Nebraska=data_list[[50]],
  Nevada=data_list[[51]],
  New_Hampshire=data_list[[52]]
)


scraped_data_birth_rate1 <- scraped_data_birth_rate1[-1, , drop = FALSE]

# Assuming your data frame is named "scraped_data_birth_rate1"
transposed_data <- t(scraped_data_birth_rate1)

# Optionally, to reset row names and make the first row as headers
transposed_data <- as.data.frame(transposed_data)
colnames(transposed_data) <- transposed_data[1, ]
transposed_data <- transposed_data[-1, ]

# Add 'States' column based on row names
transposed_data$States <- row.names(transposed_data)

# Remove the initial state column (the one that contains the initial state)
transposed_data <- transposed_data[, -1, drop = FALSE]



# Convert columns to numeric (except 'States')
num_cols <- setdiff(names(transposed_data), "States")
transposed_data[, num_cols] <- apply(transposed_data[, num_cols], 2, function(x) as.numeric(as.character(x)))


tidy_data <- transposed_data %>%
  mutate(States = case_when(
    TRUE ~ States
  )) %>%
  pivot_longer(cols = -States, names_to = "Year", values_to = "BirthRate") %>%
  mutate(Year = as.integer(str_remove(Year, "\\D+"))) %>%
  arrange(States, Year)




summary(tidy_data)
str(tidy_data)
plot_histogram(tidy_data, title = "Histograms of Numerical Variables")
plot_correlation(tidy_data)


# Save to a CSV -- might need to change save location
write_csv(tidy_data, "C://Users//14406//Adoption Data//Birth_Rate3.csv")