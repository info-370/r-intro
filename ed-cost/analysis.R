# Educational cost exploratory data analysis -- see README.md for details

# Set your working directory
setwd('~/Documents/info-370/r-intro/ed-cost/')

# Load libraries
# install.packages(dplry) # only needs to be done once on your machine
library(dplyr) # needs to be done each time you want to use the library
library(stringr)
library(ggplot2)
library(plotly)

# Load data into R using the read.csv function
ed.data <- read.csv('./data/cost-data.csv')

#### Getting to know your data ######

# View it
View(data)

# Determine shape of the dataset
dim(ed.data)

# Change column names
colnames(ed.data)
colnames(ed.data)[8] <- 'tuition.2012'
colnames(ed.data)[9] <- 'tuition.2014'

##### Summary information #####

# How many institutions are there?
length(unique(c(ed.data$Name.of.institution, ed.data$State))) # too complicated
nrow(ed.data)

# Oh no! duplicates!
View(ed.data[duplicated(paste(ed.data$Name.of.institution, ed.data$State)),]) # too complicated
# Multiple locations in the same state with the same name! http://www.stevenshenager.edu/locations

# What types of schools are there?
sector.summary <- summary(ed.data$Sector.name)
sector.summary

# Set margin spacing for upcoming graphic 
par(mar=c(5,8,4,2))
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

# How does UW compare to other higher-education locations in Washington
wa.data <- ed.data %>% filter(State == 'WA') %>%
           arrange(tuition.2014) %>% 
           mutate(wa.rank = rank(-tuition.2014)) %>% 
           filter(Name.of.institution == "University of Washington-Seattle Campus")

##### Aggregation #####

# Which state has the most schools in it?
by.state <- ed.data %>% 
            group_by(State) %>% 
            summarize(num.schools = n())


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
