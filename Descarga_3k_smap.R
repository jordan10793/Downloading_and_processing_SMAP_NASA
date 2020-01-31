# Universidad de Costa Rica
# Taller especializado en SIG y Teledetección
# II Ciclo 2018
# Estudiante: Jorge Daniel García Girón, Carné: B12703
# Rutina para la obtención, transformación y reproyección de los 
# productos SMAP Soil Moisture de resolución 3 x 3 Kilómetros

# Paquetes requeridos SMAPR (excludsivo para datos de SMAP) para 
# obtencion y descarga de datos y RASTER para la tranformación y 
# reproyección.

require(smapr)
require(raster)

# Login en repositorio de datos NASAS EarthData.

# Sys.setenv(ed_un = 'jorge_daniel', ed_pw = 'Geo.ucr10')
set_smap_credentials('jorge_daniel', 'Geo.ucr10', save = F)

# Busque de producto por categoría, fecha, versión.
# Para buscar producto en un rango de fechas:
# start_date <- as.Date("2015-03-31")
# end_date <- as.Date("2015-04-02")
# date_sequence <- seq(start_date, end_date, by = 1)
# find_smap(id = "SPL4SMGP", dates = date_sequence, version = 3)

available_data <- find_smap(id = "SPL3SMA", date = "2015-07-07", version = 3)

# Descripcion de producto encontrado.

str(available_data)

# Descarga de producto encontrado.

downloads <- download_smap(available_data, 'F:/')

# Guardar el objeto que contiene el producto descargado en caso
# tener que volver a procesarlo en la misma rutina.

save(downloads, file = "F:/Datos_Soil/File3K_0772015.RData")

# Descripción del producto descargado.

str(downloads)

# Lista de repositorio de informacion almacenada en el producto
# .h5 descargado.

list_smap(downloads, all = FALSE)

# Con el tipo de dato requerido identificado se procede a extraerlo
# del repositorio .h5 para asignarlo a un objeto.

sm_raster <- extract_smap(downloads, "Soil_Moisture_Retrieval_Data/soil_moisture")  

# Prueba de recorte.

AC <- shapefile("F:/AC_adm0.shp")
proj_ac_extent <- spTransform(AC, crs(sm_raster))
ac_soil_moisture <- crop(sm_raster, proj_ac_extent)
ac_soil_moisture_m <- mask(ac_soil_moisture, proj_ac_extent)
plot(ac_soil_moisture_m)
writeRaster(ac_soil_moisture_m, "F:/Prueba/3K/ac_soil_raster_m_7_7_2015.tif")

# Se visualiza el producto extraído.

#plot(sm_raster, main = "Level 3 soil moisture")

# Se transforma esta capa en un archovo raster de formato GEOTIFF.

#writeRaster(sm_raster, "G:/Prueba/3K/soil_raster_28_5_2015.tif")

# Fin de rutina.
