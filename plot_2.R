
if(!require("osmdata")) install.packages("osmdata")
if(!require("tidyverse")) install.packages("tidyverse")
if(!require("sf")) install.packages("sf")
if(!require("ggmap")) install.packages("ggmap")
if(!require("geosphere")) install.packages("geosphere")

library(osmdata)
library(sf)
library(tidyverse)
library(ggmap)

library(geosphere)  ## FOR DISTM FUNCTION
### <- ** -> 
q <- getbb("Yerevan") %>%
  opq() %>%
  add_osm_feature("amenity", "cinema")

str(q)

cinema <- osmdata_sf(q)

cinema 

cinema$osm_points

yerevan_map <- get_map(getbb("Yerevan"), maptype = "terrain")

ggmap(yerevan_map) + 
  geom_sf(data = cinema$osm_points,
          inherit.aes = FALSE,
          colour = "#238443",
          fill = "#004529",
          alpha = .7,
          size = 7,
          shape=21) +

  
  labs(x="Cinemas",y="")

str(cinema)
class(cinema$osm_points$geometry)

points <- cinema$osm_points

coords <- st_coordinates(points)

long <- coords[,"X"]
lat <- coords[,"Y"]



long

yerevan <- get_map(getbb("Yerevan"))
grid <- st_make_grid(yerevan_map, n = c(10,10))


#ggplot(data = cinema$osm_points, aes(x = long, y = lat)) +
#  ggmap(yerevan_map)+
#  geom_point() +
#  ggtitle("With 'color' mapping")
  
