# 
# (C) Keisuke Kondo
# Release Date: 2023-03-31
# Updated Date: 2024-01-01
# 
# - global.R
# - ui.R
# - server.R
# 

#==============================================================================
#Global Environment

## SET MAPBOX API
#Mapbox API--------------------------------------------
#Variables are defined on .Renviron
styleUrl <- Sys.getenv("MAPBOX_STYLE")
accessToken <- Sys.getenv("MAPBOX_ACCESS_TOKEN")
#Mapbox API--------------------------------------------

#Packages
if(!require(shiny)) install.packages("shiny")
if(!require(shinydashboard)) install.packages("shinydashboard")
if(!require(shinycssloaders)) install.packages("shinycssloaders")
if(!require(shinyWidgets)) install.packages("shinyWidgets")
if(!require(leaflet)) install.packages("leaflet")
if(!require(leaflet.mapboxgl)) install.packages("leaflet.mapboxgl")
if(!require(sf)) install.packages("sf")
if(!require(tidyverse)) install.packages("tidyverse")
if(!require(haven)) install.packages("haven")
if(!require(highcharter)) install.packages("highcharter")

#Municipality
dfMuni <- readr::read_csv("data/csv/muni_list.csv") 
dfMuni <- dfMuni %>%
  dplyr::arrange(muni_code)
listMuni <- as.list(paste0(dfMuni$muni_code, ", ", dfMuni$muni_name_en, ", ", dfMuni$pref_name_en, " (", dfMuni$pref_name, dfMuni$muni_name, ")"))

#Shapefile (Municipality)
sfMuni <- sf::read_sf("data/shp_polygon/shp_poly_odflow_kinki_muni.geojson") %>%
  dplyr::mutate_at(c("pref_code", "muni_code"), as.numeric) %>%
  dplyr::left_join(dfMuni %>% select(muni_code, pref_name_en, muni_name_en), by = "muni_code")
sfMuni <- st_transform(sfMuni, crs = 4326)

#Shapefile (Prefecture)
sfPref <- sf::read_sf("data/shp_polygon/shp_poly_odflow_kinki_pref.geojson") %>%
  dplyr::mutate_at(c("pref_code"), as.numeric)
sfPref <- st_transform(sfPref, crs = 4326)

#Shapefile (OD Zone)
sfZone <- sf::read_sf("data/shp_polygon/shp_poly_odflow_kinki.geojson")
sfZone <- st_transform(sfZone, crs = 4326)

#OD Zone Code
dfZone <- readr::read_csv("data/csv/csv_zonecode_odflow_muni.csv") %>%
  dplyr::left_join(dfMuni %>% select(muni_code, pref_name_en, muni_name_en), by = "muni_code")

#Estimation Results from Person Trip Survey
dfDeltaPts <- haven::read_dta("data/dta/dta_estimation_delta_kinki_person_trip_survey.dta")

#Estimation Results from Mobile Spatial Statistics
dfDeltaMss <- haven::read_dta("data/dta/dta_estimation_delta_kinki_mobile_phone_data.dta")

#Dataframe for Map
sfPolyPts <- sfZone %>%
  dplyr::mutate(odzoneCode = as.numeric(S05a_004)) %>%
  dplyr::left_join(dfZone, by = c("odzoneCode" = "id_odzone"), keep = TRUE) %>%
  dplyr::left_join(dfDeltaPts, by = c("odzoneCode" = "id_odzone")) %>%
  dplyr::select(odzoneCode, id_odzone, pref_code, pref_name, pref_name_en, muni_code, muni_name, muni_name_en, starts_with("b_delta"))

#Legend for Leaflet
breaks <- c(-7.0, -5.0, -3.0, -2.75, -2.5, -2.25, -2.0, -1.5, -1.0, 0)
breaks_label <- sapply(1:length(breaks), function(x) { paste0(sprintf("%3.2f", breaks[x-1]), " - ", sprintf("%3.2f", breaks[x])) })[-1]
pal <- leaflet::colorBin("Oranges", domain = 1:10, bins = 9)
color_val <- c(pal(1), pal(2), pal(3), pal(4), pal(5), pal(6), pal(7), pal(8), pal(9))
leg_color_val <- c(color_val, "#E5E5E5")
leg_breaks_label <- c(breaks_label, "NA")
df_pal <- data.frame(color_value = leg_color_val, color_label = leg_breaks_label, stringsAsFactors = F)
