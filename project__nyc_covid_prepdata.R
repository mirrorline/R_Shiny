library(tidyverse)
library(vroom)
library(sf)
library(tigris)
library(leaflet)
library(htmlwidgets)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)

# The above done

#setwd("C:\\Users\\Administrator\\Desktop\\R_projects\\R_Shiny")

###IMPORT DATA
#download master repo from NYC DoH Github

#download.file(url = "https://raw.githubusercontent.com/nychealth/coronavirus-data/refs/heads/master/trends/caserate-by-modzcta.csv", 
              destfile = "caserate-by-modzcta.csv")
#unzip(zipfile = "coronavirus-data-master.zip")

#read in data

#percentpos <- vroom("coronavirus-data-master/trends/percentpositive-by-modzcta.csv")
caserate <- vroom("caserate-by-modzcta.csv", delim = ",")   #>>Done
#testrate <- vroom("coronavirus-data-master/trends/testrate-by-modzcta.csv")

#read in modzcta shapefile and zcta conversion table
modzcta <- st_read('MODZCTA_2010.shp') #Done
zcta_conv <- vroom("https://raw.githubusercontent.com/nychealth/coronavirus-data/refs/heads/master/Geography-resources/ZCTA-to-MODZCTA.csv", delim = ",") #Done


### CLEAN DATA
# clean and reshape caserate data

caserates <- caserate %>% select(-c(2:7))
caserates_long <- caserates %>%
  pivot_longer(2:178, names_to = "modzcta",
               names_prefix = "CASERATE_", values_to = "caserate") ##Done

'''
#clean and reshape percentpos data
percentpositives <- percentpos %>% select(-c(2:7))
percentpos_long <- percentpositives %>%
  pivot_longer(2:178, names_to = "modzcta", 
                names_prefix = "PCTPOS_", values_to = "pctpos")

#clean and reshape testrate data
testrates <- testrate %>% select(-c(2:7))
testrates_long <- testrates %>%
  pivot_longer(2:178, names_to = "modzcta", 
               names_prefix = "TESTRATE_", values_to = "testrate")
'''
# Skipped


### MERGE IN GEOGRAPHY DATA
#combine all three long data frames into one df

# Skipped
'''
# all <- caserates_long %>% 
  left_join(percentpos_long, by = c("week_ending","modzcta")) %>% 
  left_join(testrates_long, by = c("week_ending","modzcta"))
  '''


#merge covid data with zcta shapefile >> Done
all_modzcta <- geo_join(modzcta, caserates_long,
                        'MODZCTA', 'modzcta',
                        how = "inner")


all_modzcta <- inner_join(modzcta, caserates_long, by = c('MODZCTA'='modzcta'))


# Done
all_modzcta <- inner_join(modzcta, caserates_long, by = c('MODZCTA'='modzcta'))
#View(all_modzcta)

date <-as



#NOTE: modzcta and zcta are not the same, as modzctas can encompass severall small zctas!
#code below *would* switch between, but multiple zctas can map to one modzcta, so leaving ....
# all_modzcta$MODZCTA <- zcta_conv$ZCTA[match(all_modzcta$MODZCTA, zcta_conv$MODZCTA)]
all_modzcta$MODZCTA <- zcta_conv$ZCTA[match(all_modzcta$MODZCTA, zcta_conv$MODZCTA)]


#convert week_ending from a character to a date
all_modzcta$week_ending <- as.factor(all_modzcta$week_ending)
#all_modzcta$week_ending <- strptime(all_modzcta$week_ending,format = "%m/%d/%Y") this part is not necessarily necessary
all_modzcta$week_ending <- as.Date(all_modzcta$week_ending,format = "%m/%d/%Y")


#save df for Shiny app
# this is an addition to it

saveRDS(all_modzcta, "all_modzcta.RDS") 

### DATA INSPECTION
#check distribution of caserate data

all_modzcta %>% 
  ggplot(aes(x=as.numeric(caserate))) + 
  geom_histogram(bins=50, fill='#69b3a2', color='white')



###MAKE INTERACTIVE MAP OF CASERATE
labels <- sprintf("<strong>%s</strong><br/>%g cases per 100,000 people", all_modzcta$MODZCTA, all_modzcta$caserate) %>% 
  lapply(htmltools::HTML)

pal <- colorBin(palette = "OrRd", 9, domain = all_modzcta$caserate)
#pal <- colorNumeric(palette = "OrRd", domain = all_modzcta$caserate) #Check on this


#Made the following change
#st_transform(crs = "+init=epsg:4326")
map_interactive <- all_modzcta %>% 
  st_transform(crs = st_crs(4326)) %>% 
  leaflet() %>% 
  addProviderTiles(provider = "CartoDB.Positron") %>% 
  addPolygons(label = labels,
              stroke = FALSE,
              smoothFactor = .5,
              opacity = 1,
              fillOpacity = 0.7,
              fillColor = ~ pal(caserate),
              highlightOptions = highlightOptions(weight = 5,
                                                  fillOpacity = 1,
                                                  color = "black",
                                                  opacity = 1,
                                                  bringToFront = TRUE
                                                  )) %>% 
  addLegend("bottomright",
            pal = pal,
            values = all_modzcta$caserate,
            title = "Cases Per 100,00",
            opacity = 0.7)

saveWidget(map_interactive, "nyc_covid_caserate_map.html")

map_interactive



install.packages("pryr")
library(pryr)
mem_used()



map <- leaflet() %>%
  addTiles() %>%
  setView(lng = -74.0060, lat = 40.7128, zoom = 12) %>% # Set the map's initial view
  addMarkers(lng = -74.0060, lat = 40.7128, popup = "New York City") # Add a marker
