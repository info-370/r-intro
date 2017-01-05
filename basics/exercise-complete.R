# An exercise for working with basic data in R

# Create a vector `students` with three names in it
students <- c('Rashmi', 'Amelia', 'Allen')

# Create a vector `math.grades` that represents grades for each person (0 - 100 scale)
math.grade <- c(97, 95, 96)

# Create a vector `spanish.grades` that represents grades for each person (0 - 100 scale)
spanish.grades <- 97:99

# Use the `data.frame` function to combine `students`, `math.grades`, and `spanish.grades` into a variable `people`
people <- data.frame(students, math.grades, spanish.grades)

# Calculate a new column `average` which is the average grade across courses
# Hint: calculate the average manually, not with any functions
people$average <- (people$math.grades + people$spanish.grades)/2

# Which student(s) had the highest average grade?
people[people$average == max(people$average),'students']

# Which students had lower spanish grades than math grades?
people[people$spanish.grades > people$math.grades, 'students']

# Plot the relationship between math and spanish grades using the `plot` function
plot(people$math.grades, people$spanish.grades)

# A few more labels     
plot(people$math.grades, people$spanish.grades, xlab = 'Math Grade', ylab = "Spansih Grade")
title(main="Grades") # add a title
