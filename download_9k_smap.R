# University of Costa Rica
# Workshop specialized in GIS and Remote Sensing
# II Cycle 2018
# Student: Jorge Daniel García Girón, Card: B12703
# Routine for obtaining, processing and reprojection of SMAP Soil Moisture products with a resolution of 9 x 9 kilometers

# SMAPR required packages (exclusive for SMAP data) for obtaining and downloading data and RASTER for the transformation and reprojection.

require('smapr')
require('raster')

# Insert credentials in NASA EarthData data repository.

Sys.setenv(ed_un = 'username', ed_pw = 'password')

# Product search by category, date, version (example Data Set ID: SPL4SMAU, https://nsidc.org/data/smap/smap-data.html).
# To search for a product in a range of dates:

start_date <- as.Date("2018-06-28")
end_date <- as.Date("2018-06-30")
date_sequence <- seq(start_date, end_date, by = 1)
available_data <- find_smap(id = "SPL4SMAU", dates = date_sequence, version = 4)
# available_data <- find_smap(id = "SPL4SMAU", dates = "2016-03-08", version = 4)

# Product description found.

str(available_data)

# Download of product found.

# downloads <- download_smap(available_data[8, ], 'directory folder')
local_files <- download_smap(available_data, "directory folder", overwrite = FALSE, verbose = FALSE)

# Save the R object that contains the downloaded product in case you have to reprocess it in the same routine.

# save(local_files, file = "F:/Datos_Soil/File_7_4_2015.RData")

# Description of the downloaded product.

str(local_files)

# Repository list of information stored in the downloaded .h5 product.

list_smap(local_files[1, ])

# With the type of data required and identified, proceed to extract it from the .h5 file to assign it to an R object.

sm_raster <- extract_smap(local_files, '/Analysis_Data/sm_rootzone_analysis')  

# Clip of study area according to Central America vector (quadrant).

AC <- shapefile("Shapefile file delimitation")
proj_ac_extent <- spTransform(AC, crs(sm_raster))
ac_soil_moisture <- crop(sm_raster, proj_ac_extent)
# ac_soil_moisture_m <- mask(ac_soil_moisture, proj_ac_extent)

# The average value is calculated for the days downloaded.

mean_sm <- calc(ac_soil_moisture_m, fun = mean)

# The extracted product is displayed.

plot(mean_sm)

# This layer is transformed into a raster file of GEOTIFF format.

writeRaster(mean_sm, "directory/file.tif", NAflag = -9999, overwrite = T)

# End of code.
