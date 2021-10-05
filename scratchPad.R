# # https://swechhya.github.io/excelR/
# install.packages('excelR')

# # https://github.com/smartinsightsfromdata/rpivotTable
# devtools::install_github(c("ramnathv/htmlwidgets", "smartinsightsfromdata/rpivotTable"))

# https://github.com/jbryer/DTedit
# devtools::install_github('jbryer/DTedit')

library(dplyr)
library(readr)

covid_flight <- covid_impact_on_airport_traffic %>%
    mutate(AggregationMethod = as.factor(AggregationMethod),
           Version = as.factor(Version),
           AirportName = as.factor(AirportName),
           Centroid = as.factor(Centroid),
           City = as.factor(City),
           State = as.factor(State),
           Country = as.factor(Country),
           ISO_3166_2 = as.factor(ISO_3166_2),
           Geography = as.factor(Geography))

library(rpivotTable)
covid_flight %>%
    rpivotTable::rpivotTable()


library(excelR)

data = data.frame(Model = c('Mazda', 'Pegeout', 'Honda Fit', 'Honda CRV'),
                  Date=c(as.Date('2006-01-01'), as.Date('2005-01-01'), as.Date('2004-01-01'), as.Date('2003-01-01') ),
                  Availability = c(TRUE, FALSE, TRUE, TRUE), stringsAsFactors = FALSE)

columns = data.frame(title=c('Model', 'Date', 'Availability' ),
                     width= c(300, 300, 300))
excelTable(data=mtcars)#, columns = columns)
