## state by state
adoption_data_21 = read.csv('2021.csv')
adoption_data_20 = read.csv('2020.csv')
adoption_data_19 = read.csv('2019.csv')
adoption_data_18 = read.csv('2018.csv')
adoption_data_17 = read.csv('2017.csv')
state_adoption_stats <- rbind(adoption_data_21, adoption_data_20, adoption_data_19,
                              adoption_data_18, adoption_data_17)
names(state_adoption_stats)[names(state_adoption_stats) == 'Number'] <- 
  'num_adoptions'
population_21 = read.csv('2021_population.csv')
population_20 = read.csv('2020_population.csv')
population_19 = read.csv('2019_population.csv')
population_18 = read.csv('2018_population.csv')
population_17 = read.csv('2017_population.csv')
state_population_stats <- rbind(population_21, population_20, population_19,
                                population_18, population_17)

by_state <- merge(state_adoption_stats, state_population_stats,
                  by = c("State", "Year"), all.x = TRUE)
write.csv(by_state, 'population_adoption_data.csv', row.names = T)
write.csv(state_adoption_stats, 'state_adoption_statistics.csv', row.names = T)

library(DataExplorer)

create_report(by_state, output_file = "Population Adoption Data Report.html")
create_report(state_adoption_stats, output_file = "State Adoption Statistics Report.html")
