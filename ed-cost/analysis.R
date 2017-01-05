# Educational cost exploratory data analysis -- see README.md for data details

#### Set up ####

# Set your working directory
setwd('~/Documents/info-370/r-intro/ed-cost/')

# Install external libraries for use - only needs to be done once on your machine
# install.packages(dplry) 
# install.packages(plotly)
# install.packages(stringr)

# Load the libraries into R - needs to be done each time you want to use the library
library(dplyr) 
library(stringr)
library(ggplot2)
library(plotly)

# Set margin spacing for graphics
par(mar=c(5,8,4,2))

# Load data into R using the `read.csv` function
ed.data <- read.csv('./data/cost-data.csv')

#### Getting to know your data #####

# View it
View(ed.data)

# Determine shape of the dataset
dim(ed.data)

# View / change column names
colnames(ed.data)
colnames(ed.data)[8] <- 'tuition.2012'
colnames(ed.data)[9] <- 'tuition.2014'


# Use the `nrow` function to determine how many institutions there are
nrow(ed.data)

# Use the `summary` function to summarize the Sector.name column of your dataset
sector.summary <- summary(ed.data$Sector.name)
sector.summary

# An aside: use the `barplot` function to plot the summary 
barplot(sector.summary, horiz = TRUE, las=1, cex.names = .5)


# What was the most expensive school in 2014 (base R calculation)?
most.expensive <- ed.data[ed.data$tuition.2014 == max(ed.data$tuition.2014),] # using basic R selection

# What was the most expensive school in 2014 (using dplyr)?
most.expensive <- ed.data %>% 
      filter(tuition.2014 == max(tuition.2014)) %>%  
      select(Name.of.institution)

# What was the least expensive school in 2014?
least.expensive <- ed.data %>% 
                    filter(tuition.2014 == min(tuition.2014)) %>%  
                    select(Name.of.institution)

# How expensive was UW?
ed.data %>% filter(str_detect(Name.of.institution, 'Washington')) %>% select(Name.of.institution)
ed.data %>% filter(Name.of.institution == "University of Washington-Seattle Campus")


#### What is the average annual tuition by sector in 2014? ####
by.sector <- ed.data %>% 
              group_by(Sector.name) %>% 
              summarize(avg.tuition = mean(tuition.2014, na.rm = T))

barplot(by.sector$avg.tuition, names.arg = by.sector$Sector.name, horiz = TRUE, las=1, cex.names = .5)

#### How did the cost of UW rank against other Washington schools? ####

# Filter down to Washington schools, then compute the rank
wa.data <- ed.data %>% filter(State == 'WA') %>%
           mutate(wa.rank = rank(-tuition.2014))

##### Which state has the most higher-ed institutions? #####
by.state <- ed.data %>% 
            group_by(State) %>% 
            summarize(num.schools = n())


##### Computation ####

# Calculate the absolute change in tution between the two years
ed.data <- ed.data %>%
              mutate(change = tuition.2014 - tuition.2012)

#### Which *sector* had the largest average change in tuition? ####
sector.average <- ed.data %>% 
                    group_by(Sector, Sector.name) %>% 
                    summarize(avg.change = mean(change, na.rm = TRUE))

##### Bonus: Map the number of schools using plotly #####
# Hint: See https://plot.ly/r/choropleth-maps/

# Store map in a variable
simple.map <- plot_geo(by.state, locationmode = 'USA-states') %>% 
        add_trace(
          z = ~num.schools, color = ~num.schools, locations = ~State
        )

# Show the map
simple.map

# Set geography options for map
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)

# Pass simple map into a layout function
map.with.layout <- simple.map %>% 
        layout(
          title = 'Number of Schools per State',
          geo = g
        )

# Show map with a better layout
map.with.layout
