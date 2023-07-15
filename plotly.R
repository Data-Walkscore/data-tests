
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

citation("osmdata")

city = "Yerevan"

aua <- c(40.19316854628843, 44.50449984955174)

## Request traffic signals in Yerevan

q <- getbb(city) %>%
  opq() %>%
  add_osm_feature("highway", "traffic_signals")

#### READ OSM DATA AS LIST IN R

signals <- osmdata_sf(q)

signals

signals$osm_points 

distances = c(1:length(signals$osm_points$osm_id))

########## DISTANCE FROM AUA to 
for(i in 1:length(distances)){
  distances[i] = distm(aua, c(signals$osm_points$geometry[[i]][1], signals$osm_points$geometry[[i]][2]), fun = distGeo)
}

####### Minimal distance from aua to nearest signal

min(distances)

### HOW MANY SIGNALS WE WILL FIND IN A 3KM RADIUS

distances
max(distances)


sum(distances[ distances < 600000])

q2 <- getbb(city) %>% 
  opq() %>%
  add_osm_feature("highway", "primary")

primary <- osmdata_sf(q2)

lines_primary <- st_transform(primary$osm_lines$geometry, 4269)

## ## ## 
POINT_AUA <- as.data.frame(rbind(aua))

names(POINT_AUA)[1] = "lon1"
names(POINT_AUA)[2] = "lat1"
POINT_AUA <- st_as_sf(POINT_AUA, coords = c("lon1","lat1"))
POINT_AUA <- st_set_crs(POINT_AUA, 4269)

###### --------- ### 
min(st_distance(POINT_AUA$geometry, lines_primary))


yerevan_map <- get_map(getbb("Yerevan"), maptype = "toner-background")

yerevan_map


info <- getbb("Yerevan")


len_x <- info["x","max"] - info["x", "min"]
len_x

len_y <-  info["y","max"] - info["y", "min"]
info
#df<-data.frame(info[,"max"], info[,"min"] )
#for(i in 1:10){
#  for(j in 1:10){
#    df[i+j+2,]= df[i+j+1,]+c(len_x/10,len_y/10)
#  }
#}

#str(df)

df <- data.frame(Index = 1:100) 

x_vec <- c()
y_vec <- c()

for(i in 1:10){
  for(j in 1:10){
      x_vec <- c(x_vec,  info["x", "min"] + i*(len_x/10))
      y_vec <- c(y_vec, info["y", "min"] + i*(len_y/10))
  }
}
df
df$GRID_X <- x_vec
df$GRID_Y <- y_vec
df

ggmap(yerevan_map) + 
  geom_sf(data = signals$osm_points,
          inherit.aes = FALSE,
          colour = "#238443",
          fill = "#004529",
          alpha = .5,
          size = 4,
          shape=21) +
  geom_sf(data = primary$osm_lines,
          inherit.aes = FALSE,
          colour = "#238443",
          fill = "#004529",
          alpha = .5,
          size = 4,
          shape=21) +
  
  labs(x="",y="")


ggmap(yerevan_map) + 
  geom_point(data=df, aes(x=GRID_X, y = GRID_Y), color="red", size = 7)

