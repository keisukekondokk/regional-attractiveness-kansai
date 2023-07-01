# 
# (C) Keisuke Kondo
# Release Date: 2023-03-31
# 
# - global.R
# - ui.R
# - server.R
# 

server <- function(input, output) {
  ####################################
  ## MAP VISUALIZATION
  ## 
  ####################################

  #++++++++++++++++++++++++++++++++++++++
  #Map 1
  output$map1 <- renderLeaflet({

    #TMAP
    tp <-
      sfPoly %>%
      dplyr::mutate(b_delta_total = if_else(b_delta_total > 0, NA_real_, b_delta_total)) %>%
      tm_shape() +
      tm_basemap(NULL) +
      tm_fill(
        col = "b_delta_total",
        alpha = 0.5,
        palette = "-Oranges",
        n = 9,
        style = "fixed",
        breaks = c(-8.0, -3.5, -3.0, -2.75, -2.5, -2.25, -2.0, -1.5, -1.0, -0.1),
        id = "muni_name",
        popup.vars = c(
          "都道府県コード" = "pref_code",
          "都道府県名" = "pref_name",
          "市町村コード" = "muni_code",
          "市町村名" = "muni_name",
          "ゾーンコード" = "id_odzone",
          "地域魅力度指数" = "b_delta_total"
        ),
        popup.format = list(
          muni_code = list(big.mark = ""),
          id_odzone = list(big.mark = ""),
          b_delta_total = list(digits = 4)
        ),
        title = paste("地域魅力度指数", "（全トリップ）", sep = "<br>"),
        group = "地域魅力度指数マップ"
      ) +
      tm_borders(lwd = 0.25) +
      tm_shape(sfMuni) +
      tm_basemap(NULL) +
      tm_borders(lwd = 1.5,
                 group = "市区町村境界") +
      tm_shape(sfPref) +
      tm_basemap(NULL) +
      tm_borders(lwd = 3.0,
                 group = "都道府県境界") 
      
    #Leaflet from tmap
    lf <- tmap_leaflet(tp, in.shiny = TRUE)
    lf %>%
      #Tile Layer from Mapbox
      addMapboxGL(accessToken = accessToken,
                  style = styleUrl,
                  setView = FALSE)
    
  })
  
  #++++++++++++++++++++++++++++++++++++++
  #Map 2
  output$map2 <- renderLeaflet({
    
    #TMAP
    tp <-
      sfPoly %>%
      dplyr::mutate(b_delta_office = if_else(b_delta_office > 0, NA_real_, b_delta_office)) %>%
      tm_shape() +
      tm_basemap(NULL) +
      tm_fill(
        col = "b_delta_office",
        alpha = 0.5,
        palette = "-Oranges",
        n = 9,
        style = "fixed",
        breaks = c(-8.0, -3.5, -3.0, -2.75, -2.5, -2.25, -2.0, -1.5, -1.0, -0.1),
        id = "muni_name",
        popup.vars = c(
          "都道府県コード" = "pref_code",
          "都道府県名" = "pref_name",
          "市町村コード" = "muni_code",
          "市町村名" = "muni_name",
          "ゾーンコード" = "id_odzone",
          "地域魅力度指数" = "b_delta_office"
        ),
        popup.format = list(
          muni_code = list(big.mark = ""),
          id_odzone = list(big.mark = ""),
          b_delta_office = list(digits = 4)
        ),
        title = paste("地域魅力度指数", "（出勤トリップ）", sep = "<br>"),
        group = "地域魅力度指数マップ"
      ) +
      tm_borders(lwd = 0.25) +
      tm_shape(sfMuni) +
      tm_basemap(NULL) +
      tm_borders(lwd = 1.5,
                 group = "市区町村境界") +
      tm_shape(sfPref) +
      tm_basemap(NULL) +
      tm_borders(lwd = 3.0,
                 group = "都道府県境界") 
    
    #Leaflet from tmap
    lf <- tmap_leaflet(tp, in.shiny = TRUE)
    lf %>%
      #Tile Layer from Mapbox
      addMapboxGL(accessToken = accessToken,
                  style = styleUrl,
                  setView = FALSE)
    
  })

  #++++++++++++++++++++++++++++++++++++++
  #Map 3
  output$map3 <- renderLeaflet({
    
    #TMAP
    tp <- 
      sfPoly %>%
      dplyr::mutate(b_delta_school = if_else(b_delta_school > 0, NA_real_, b_delta_school)) %>%
      tm_shape() +
      tm_basemap(NULL) +
      tm_fill(
        col = "b_delta_school",
        alpha = 0.5,
        palette = "-Oranges",
        n = 9,
        style = "fixed",
        breaks = c(-8.0, -3.5, -3.0, -2.75, -2.5, -2.25, -2.0, -1.5, -1.0, -0.1),
        id = "muni_name",
        popup.vars = c(
          "都道府県コード" = "pref_code", 
          "都道府県名" = "pref_name", 
          "市町村コード" = "muni_code", 
          "市町村名" = "muni_name", 
          "ゾーンコード" = "id_odzone", 
          "地域魅力度指数" = "b_delta_school"),
        popup.format = list(
          muni_code = list(big.mark = ""),
          id_odzone = list(big.mark = ""),
          b_delta_school = list(digits = 4)
        ),
        title = paste("地域魅力度指数", "（登校トリップ）", sep = "<br>"),
        group = "地域魅力度指数マップ"
      ) +
      tm_borders(lwd = 0.25) +
      tm_shape(sfMuni) +
      tm_basemap(NULL) +
      tm_borders(lwd = 1.5,
                 group = "市区町村境界") +
      tm_shape(sfPref) +
      tm_basemap(NULL) +
      tm_borders(lwd = 3.0,
                 group = "都道府県境界") 
    
    #Leaflet from tmap
    lf <- tmap_leaflet(tp, in.shiny = TRUE)
    lf %>%
      #Tile Layer from Mapbox
      addMapboxGL(accessToken = accessToken,
                  style = styleUrl,
                  setView = FALSE)
    
  })
  
  #++++++++++++++++++++++++++++++++++++++
  #Map 4
  output$map4 <- renderLeaflet({
    
    #TMAP
    tp <- 
      sfPoly %>%
      dplyr::mutate(b_delta_free = if_else(b_delta_free > 0, NA_real_, b_delta_free)) %>%
      tm_shape() +
      tm_basemap(NULL) +
      tm_fill(
        col = "b_delta_free",
        alpha = 0.5,
        palette = "-Oranges",
        n = 9,
        style = "fixed",
        breaks = c(-8.0, -3.5, -3.0, -2.75, -2.5, -2.25, -2.0, -1.5, -1.0, -0.1),
        id = "muni_name",
        popup.vars = c(
          "都道府県コード" = "pref_code", 
          "都道府県名" = "pref_name", 
          "市町村コード" = "muni_code", 
          "市町村名" = "muni_name", 
          "ゾーンコード" = "id_odzone", 
          "地域魅力度指数" = "b_delta_free"),
        popup.format = list(
          muni_code = list(big.mark = ""),
          id_odzone = list(big.mark = ""),
          b_delta_free = list(digits = 4)
        ),
        title = paste("地域魅力度指数", "（自由トリップ）", sep = "<br>"),
        group = "地域魅力度指数マップ"
      ) +
      tm_borders(lwd = 0.25) +
      tm_shape(sfMuni) +
      tm_basemap(NULL) +
      tm_borders(lwd = 1.5,
                 group = "市区町村境界") +
      tm_shape(sfPref) +
      tm_basemap(NULL) +
      tm_borders(lwd = 3.0,
                 group = "都道府県境界") 
    
    #Leaflet from tmap
    lf <- tmap_leaflet(tp, in.shiny = TRUE)
    lf %>%
      #Tile Layer from Mapbox
      addMapboxGL(accessToken = accessToken,
                  style = styleUrl,
                  setView = FALSE)

  })
  
  #++++++++++++++++++++++++++++++++++++++
  #Map 5
  output$map5 <- renderLeaflet({
    
    #TMAP
    tp <- 
      sfPoly %>%
      dplyr::mutate(b_delta_business = if_else(b_delta_business > 0, NA_real_, b_delta_business)) %>%
      tm_shape() +
      tm_basemap(NULL) +
      tm_fill(
        col = "b_delta_business",
        alpha = 0.5,
        palette = "-Oranges",
        n = 9,
        style = "fixed",
        breaks = c(-8.0, -3.5, -3.0, -2.75, -2.5, -2.25, -2.0, -1.5, -1.0, -0.1),
        id = "muni_name",
        popup.vars = c(
          "都道府県コード" = "pref_code", 
          "都道府県名" = "pref_name", 
          "市町村コード" = "muni_code", 
          "市町村名" = "muni_name", 
          "ゾーンコード" = "id_odzone", 
          "地域魅力度指数" = "b_delta_business"),
        popup.format = list(
          muni_code = list(big.mark = ""),
          id_odzone = list(big.mark = ""),
          b_delta_business = list(digits = 4)
        ),
        title = paste("地域魅力度指数", "（業務トリップ）", sep = "<br>"),
        group = "地域魅力度指数マップ"
      ) +
      tm_borders(lwd = 0.25) +
      tm_shape(sfMuni) +
      tm_basemap(NULL) +
      tm_borders(lwd = 1.5,
                 group = "市区町村境界") +
      tm_shape(sfPref) +
      tm_basemap(NULL) +
      tm_borders(lwd = 3.0,
                 group = "都道府県境界") 
    
    #Leaflet from tmap
    lf <- tmap_leaflet(tp, in.shiny = TRUE)
    lf %>%
      #Tile Layer from Mapbox
      addMapboxGL(accessToken = accessToken,
                  style = styleUrl,
                  setView = FALSE)
    
  })
  
  #++++++++++++++++++++++++++++++++++++++
  #Map 6
  output$map6 <- renderLeaflet({
    
    #TMAP
    tp <- 
      sfPoly %>%
      dplyr::mutate(b_delta_home = if_else(b_delta_home > 0, NA_real_, b_delta_home)) %>%
      tm_shape() +
      tm_basemap(NULL) +
      tm_fill(
        col = "b_delta_home",
        alpha = 0.5,
        palette = "-Oranges",
        n = 9,
        style = "fixed",
        breaks = c(-8.0, -3.5, -3.0, -2.75, -2.5, -2.25, -2.0, -1.5, -1.0, -0.1),
        id = "muni_name",
        popup.vars = c(
          "都道府県コード" = "pref_code", 
          "都道府県名" = "pref_name", 
          "市町村コード" = "muni_code", 
          "市町村名" = "muni_name", 
          "ゾーンコード" = "id_odzone", 
          "地域魅力度指数" = "b_delta_home"),
        popup.format = list(
          muni_code = list(big.mark = ""),
          id_odzone = list(big.mark = ""),
          b_delta_home = list(digits = 4)
        ),
        title = paste("地域魅力度指数", "（帰宅トリップ）", sep = "<br>"),
        group = "地域魅力度指数マップ"
      ) +
      tm_borders(lwd = 0.25) +
      tm_shape(sfMuni) +
      tm_basemap(NULL) +
      tm_borders(lwd = 1.5,
                 group = "市区町村境界") +
      tm_shape(sfPref) +
      tm_basemap(NULL) +
      tm_borders(lwd = 3.0,
                 group = "都道府県境界") 
    
    #Leaflet from tmap
    lf <- tmap_leaflet(tp, in.shiny = TRUE)
    lf %>%
      #Tile Layer from Mapbox
      addMapboxGL(accessToken = accessToken,
                  style = styleUrl,
                  setView = FALSE)
    
  })
  
  #++++++++++++++++++++++++++++++++++++++
  #Map 7
  output$map7 <- renderLeaflet({
    
    #TMAP
    tp <- 
      sfPoly %>%
      dplyr::mutate(b_delta_unknown = if_else(b_delta_unknown > 0, NA_real_, b_delta_unknown)) %>%
      tm_shape() +
      tm_basemap(NULL) +
      tm_fill(
        col = "b_delta_unknown",
        alpha = 0.5,
        palette = "-Oranges",
        n = 9,
        style = "fixed",
        breaks = c(-8.0, -3.5, -3.0, -2.75, -2.5, -2.25, -2.0, -1.5, -1.0, -0.1),
        id = "muni_name",
        popup.vars = c(
          "都道府県コード" = "pref_code", 
          "都道府県名" = "pref_name", 
          "市町村コード" = "muni_code", 
          "市町村名" = "muni_name", 
          "ゾーンコード" = "id_odzone", 
          "地域魅力度指数" = "b_delta_unknown"),
        popup.format = list(
          muni_code = list(big.mark = ""),
          id_odzone = list(big.mark = ""),
          b_delta_unknown = list(digits = 4)
        ),
        title = paste("地域魅力度指数", "（不明トリップ）", sep = "<br>"),
        group = "地域魅力度指数マップ"
      ) +
      tm_borders(
        lwd = 0.25
      ) +
      tm_shape(sfMuni) +
      tm_basemap(NULL) +
      tm_borders(lwd = 1.5,
                 group = "市区町村境界") +
      tm_shape(sfPref) +
      tm_basemap(NULL) +
      tm_borders(lwd = 3.0,
                 group = "都道府県境界") 
    
    #Leaflet from tmap
    lf <- tmap_leaflet(tp, in.shiny = TRUE)
    lf %>%
      #Tile Layer from Mapbox
      addMapboxGL(accessToken = accessToken,
                  style = styleUrl,
                  setView = FALSE)
    
  })
}
