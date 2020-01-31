# Universidad de Costa Rica
# Taller especializado en SIG y Teledetección
# II Ciclo 2018
# Estudiante: Jorge Daniel García Girón, Carné: B12703
# Rutina para la obtención, transformación y reproyección de los 
# productos SMAP Soil Moisture de resolución 9 x 9 Kilómetros

# Paquetes requeridos SMAPR (excludsivo para datos de SMAP) para 
# obtencion y descarga de datos y RASTER para la tranformación y 
# reproyección.

require('smapr')
require('raster')

# Insertar credenciales en repositorio de datos NASA EarthData.

Sys.setenv(ed_un = 'jorge_daniel', ed_pw = 'Geo.ucr10')

# Busqueda de producto por categoría, fecha, versión.
# Para buscar producto en un rango de fechas:
start_date <- as.Date("2018-06-28")
end_date <- as.Date("2018-06-30")
date_sequence <- seq(start_date, end_date, by = 1)
available_data <- find_smap(id = "SPL4SMAU", dates = date_sequence, version = 4)

# available_data <- find_smap(id = "SPL4SMAU", dates = "2016-03-08", version = 4)

# Descripcion de producto encontrado.

str(available_data)

# Descarga de producto encontrado.

# downloads <- download_smap(available_data[8, ], 'G:/Prueba')

local_files <- download_smap(available_data, "C:/SM", overwrite = FALSE, verbose = FALSE)

# Guardar el objeto que contiene el producto descargado en caso
# tener que volver a procesarlo en la misma rutina.

save(local_files, file = "F:/Datos_Soil/File_7_4_2015.RData")

# Descripción del producto descargado.

str(local_files)

# Lista de repositorio de informacion almacenada en el producto
# .h5 descargado.

list_smap(local_files[1, ])

# Con el tipo de dato requerido identificado se procede a extraerlo
# del repositorio .h5 para asignarlo a un objeto.  

sm_raster <- extract_smap(local_files, '/Analysis_Data/sm_rootzone_analysis')  

# Recorte de área de estudio segun vectorial de América Central (cuadrante).

AC <- shapefile("F:/AC_adm0.shp")
proj_ac_extent <- spTransform(AC, crs(sm_raster))
ac_soil_moisture <- crop(sm_raster, proj_ac_extent)
# ac_soil_moisture_m <- mask(ac_soil_moisture, proj_ac_extent)

# Se calcula el valor promedio para los 15 días

mean_sm <- calc(ac_soil_moisture_m, fun = mean)

# Se visualiza el producto extraído.

plot(mean_sm)

# Se transforma esta capa en un archivo raster de formato GEOTIFF.

writeRaster(mean_sm, "F:/Prueba/9K/ac_soil_raster_28_30_6_2018.tif", NAflag = -9999, overwrite = T)

# Fin de rutina.
