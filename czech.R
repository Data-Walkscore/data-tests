library(dplyr)
library(RCzechia) # a package of Czech administrative areas
library(sf)


mesto <- kraje() %>% # All Czech NUTS3 ...
  filter(NAZ_CZNUTS3 == 'Hlavní město Praha') %>% # ... city of Prague
  st_transform(5514) # a metric CRS 

grid_spacing <- 1000  # size of squares, in units of the CRS (i.e. meters for 5514)

polygony <- st_make_grid(mesto, square = T, cellsize = c(grid_spacing, grid_spacing)) %>% # the grid, covering bounding box
  st_sf() # not really required, but makes the grid nicer to work with later

plot(polygony, col = 'white')
plot(st_geometry(mesto), add = T)
