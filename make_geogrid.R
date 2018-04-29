require(ggplot2)
require(gridExtra)
require(viridis)
require(geogrid) #devtools::install_github("jbaileyh/geogrid")
require(maptools) # Not in example, but is needed
require(geojsonio) # used to write out geojson


#source("get152LA.R"); get152LA()

raw <- read_polygons("152LA.geojson")

# raw@data$xcentroid <- sp::coordinates(raw)[,1]
# raw@data$ycentroid <- sp::coordinates(raw)[,2]
# 
# clean <- function(shape) {
#   
#   shape@data$id = rownames(shape@data)
#   shape.points = fortify(shape, region="id")
#   shape.df = merge(shape.points, shape@data, by="id")
# }
# 
# result_df_raw <- clean(raw)
# 
# 
# rawplot <- ggplot(result_df_raw) +
#   geom_polygon(aes(x = long.x, y = lat.x, fill=st_area.shape., group = group)) +
#   geom_text(aes(xcentroid, ycentroid, label = substr(ctyua17nm, 1, 4)), size = 2,color = "white") +
#   coord_equal() +
#   scale_fill_viridis() +
#   guides(fill = FALSE) +
#   theme_void()
# 
# rawplot


# par(mfrow = c(2, 3), mar = c(0, 0, 2, 0))
# for (i in 1:6) {
#   new_cells <- calculate_grid(shape = raw, grid_type = "hexagonal", seed = i)
#   plot(new_cells, main = paste("Seed", i, sep = " "))
# }
# 
# par(mfrow = c(2, 3), mar = c(0, 0, 2, 0))
# for (i in 7:12) {
#   new_cells <- calculate_grid(shape = raw, grid_type = "hexagonal", seed = i)
#   plot(new_cells, main = paste("Seed", i, sep = " "))
# }

for(i in 1:12){
  
  new_cells_hex <- calculate_grid(shape = raw, grid_type = "hexagonal", seed = i)
  resulthex <- assign_polygons(raw, new_cells_hex)

  geojson_write(resulthex,file = paste0("152LAhex",as.character(i),".geojson"))
  
}
