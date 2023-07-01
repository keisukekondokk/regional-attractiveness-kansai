# 
# (C) Keisuke Kondo
# Release Date: 2023-03-31
# 
# - global.R
# - ui.R
# - server.R
# 

#==============================================================================
#Global Environment

#Packages
library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(tmap)
library(leaflet)
library(leaflet.mapboxgl)
library(sf)
library(tidyverse)
library(haven)

#シェープファイル(市町村単位)
sfMuni <- sf::read_sf("data/shp_polygon/shp_poly_odflow_kinki_muni.geojson")

#シェープファイル(都道府県単位)
sfPref <- sf::read_sf("data/shp_polygon/shp_poly_odflow_kinki_pref.geojson")

#シェープファイル(ODゾーン集計ポリゴン)
sfZone <- sf::read_sf("data/shp_polygon/shp_poly_odflow_kinki.geojson")

#Zone Code
dfZone <- readr::read_csv("data/csv/csv_zonecode_odflow_muni.csv")

#Estimation Results
dfDelta <- haven::read_dta("data/dta/dta_estimation_delta_kinki.dta")

#最終データフレームを作成
sfPoly <- sfZone %>%
  dplyr::mutate(odzoneCode = as.numeric(S05a_004)) %>%
  dplyr::left_join(dfZone, by = c("odzoneCode" = "id_odzone"), keep = TRUE) %>%
  dplyr::left_join(dfDelta, by = c("odzoneCode" = "id_odzone")) %>%
  dplyr::select(odzoneCode, id_odzone, pref_code, pref_name, muni_code, muni_name, starts_with("b_delta"))

#TMAP
tmap_mode("view")

## SET MAPBOX API
#Mapbox API--------------------------------------------
#Variables are defined on .Renviron``
styleUrl <- Sys.getenv("MAPBOX_STYLE")
accessToken <- Sys.getenv("MAPBOX_ACCESS_TOKEN")
#Mapbox API--------------------------------------------
