# 
# (C) Keisuke Kondo
# Release Date: 2023-03-31
# Updated Date: 2024-01-01
# 
# - global.R
# - ui.R
# - server.R
# 

server <- function(input, output, session) {
  ###################################################################
  ## VISUALIZATION
  ## - Tab1: Map (Person Trip Survey) by Leaflet
  ## - Tab2: Map (Mobile Phone Data) by Leaflet
  ## - Tab3: Time-Series (Mobile Phone Data) by Higherchart
  ###################################################################
  
  #++++++++++++++++++++++++++++++++++++++
  #Tab1 Map
  #++++++++++++++++++++++++++++++++++++++
  
  #Leaflet Output
  output$map1 <- renderLeaflet({
    
    #SF Object
    sfPolyPtsLegend <- sfPolyPts %>%
      dplyr::mutate(b_delta_color_group = cut(b_delta_total, breaks = breaks, labels = breaks_label)) %>%
      dplyr::mutate(b_delta_color_group = as.character(b_delta_color_group)) %>%
      dplyr::left_join(df_pal, by = c("b_delta_color_group" = "color_label"))%>%
      dplyr::rename(b_delta_color_value = color_value) %>%
      dplyr::mutate(b_delta_color_value = if_else(is.na(b_delta_color_value), "#E5E5E5", b_delta_color_value)) 
    
    #Leaflet Object
    leaflet() %>%
      #Tile Layer from Mapbox
      addMapboxGL(
        accessToken = accessToken,
        style = styleUrl,
        setView = FALSE
      ) %>%
      addPolygons(
        data = sfPolyPtsLegend,
        fillColor = ~b_delta_color_value, 
        fillOpacity = 0.5,
        stroke = FALSE, 
        popup = paste0(
          "<b>Municipality code: </b>　", sfPolyPtsLegend$muni_code, "<br>",
          "<b>Municipality name (en): </b>　", sfPolyPtsLegend$muni_name_en, ", ", sfPolyPtsLegend$pref_name_en, "<br>",
          "<b>Municipality name (jp): </b>　", sfPolyPtsLegend$pref_name, sfPolyPtsLegend$muni_name, "<br>",
          "<b>OD zone code: </b>　", sfPolyPtsLegend$id_odzone, "<br>",
          "<b>Regional attractive index (total trips): </b>　", round(sfPolyPtsLegend$b_delta_total, 3), "<br>"
        ),
        popupOptions = list(maxWidth = 500, closeOnClick = TRUE),
        label = paste(sfPolyPtsLegend$muni_name_en, sfPolyPtsLegend$pref_name_en, sep = ", "),
        group = "Regional Attractiveness Index"
      ) %>%
      addPolygons(
        data = sfMuni, 
        fill = FALSE, 
        color = "#F0F0F0", 
        weight = 1.0, 
        group = "Municipality Division"
      ) %>%
      addPolygons(
        data = sfPref, 
        fill = FALSE, 
        color = "#303030", 
        weight = 3.0, 
        group = "Prefecture Division"
      ) %>%
      addLegend(
        colors = df_pal$color_value,
        labels = df_pal$color_label,
        title = paste("Regional Attractiveness Index", "(Total Trips)", sep = "<br>")
      ) %>%
      addLayersControl(
        overlayGroups = c("Regional Attractiveness Index", "Municipality Division", "Prefecture Division"),
        position = "topright",
        options = layersControlOptions(collapsed = TRUE)
      )
  })

  #LeafletProxy
  map1_proxy <- leafletProxy("map1", session)

  #Switch Leaflet
  observeEvent(input$map1_button, {
    #LEAFLET for Total Trips
    if(input$map1_button == 1) {
      #SF Object
      sfPolyPtsLegend <- sfPolyPts %>%
        dplyr::mutate(b_delta_color_group = cut(b_delta_total, breaks = breaks, labels = breaks_label)) %>%
        dplyr::mutate(b_delta_color_group = as.character(b_delta_color_group)) %>%
        dplyr::left_join(df_pal, by = c("b_delta_color_group" = "color_label"))%>%
        dplyr::rename(b_delta_color_value = color_value) %>%
        dplyr::mutate(b_delta_color_value = if_else(is.na(b_delta_color_value), "#E5E5E5", b_delta_color_value)) 
      
      #Leaflet Object
      map1_proxy %>%
        clearShapes() %>%
        clearControls() %>%
        addPolygons(
          data = sfPolyPtsLegend,
          fillColor = ~b_delta_color_value, 
          fillOpacity = 0.5,
          stroke = FALSE, 
          popup = paste0(
            "<b>Municipality code: </b>　", sfPolyPtsLegend$muni_code, "<br>",
            "<b>Municipality name (en): </b>　", sfPolyPtsLegend$muni_name_en, ", ", sfPolyPtsLegend$pref_name_en, "<br>",
            "<b>Municipality name (jp): </b>　", sfPolyPtsLegend$pref_name, sfPolyPtsLegend$muni_name, "<br>",
            "<b>OD zone code: </b>　", sfPolyPtsLegend$id_odzone, "<br>",
            "<b>Regional attractive index (total trips): </b>　", round(sfPolyPtsLegend$b_delta_total, 3), "<br>"
          ),
          popupOptions = list(maxWidth = 500, closeOnClick = TRUE),
          label = paste(sfPolyPtsLegend$muni_name_en, sfPolyPtsLegend$pref_name_en, sep = ", "),
          group = "Regional Attractiveness Index"
        ) %>%
        addPolygons(
          data = sfMuni, 
          fill = FALSE, 
          color = "#F0F0F0", 
          weight = 1.0, 
          group = "Municipality Division"
        ) %>%
        addPolygons(
          data = sfPref, 
          fill = FALSE, 
          color = "#303030", 
          weight = 3.0, 
          group = "Prefecture Division"
        ) %>%
        addLegend(
          colors = df_pal$color_value,
          labels = df_pal$color_label,
          title = paste("Regional Attractiveness Index", "(Total Trips)", sep = "<br>")
        ) %>%
        addLayersControl(
          overlayGroups = c("Regional Attractiveness Index", "Municipality Division", "Prefecture Division"),
          position = "topright",
          options = layersControlOptions(collapsed = TRUE)
        )
    }
    #LEAFLET for Commuting to Offices
    else if(input$map1_button == 2) {
      #SF Object
      sfPolyPtsLegend <- sfPolyPts %>%
        dplyr::mutate(b_delta_color_group = cut(b_delta_office, breaks = breaks, labels = breaks_label)) %>%
        dplyr::mutate(b_delta_color_group = as.character(b_delta_color_group)) %>%
        dplyr::left_join(df_pal, by = c("b_delta_color_group" = "color_label"))%>%
        dplyr::rename(b_delta_color_value = color_value) %>%
        dplyr::mutate(b_delta_color_value = if_else(is.na(b_delta_color_value), "#E5E5E5", b_delta_color_value)) 

      #Leaflet Object
      map1_proxy %>%
        clearShapes() %>%
        clearControls() %>%
        addPolygons(
          data = sfPolyPtsLegend,
          fillColor = ~b_delta_color_value, 
          fillOpacity = 0.5,
          stroke = FALSE, 
          popup = paste0(
            "<b>Municipality code: </b>　", sfPolyPtsLegend$muni_code, "<br>",
            "<b>Municipality name (en): </b>　", sfPolyPtsLegend$muni_name_en, ", ", sfPolyPtsLegend$pref_name_en, "<br>",
            "<b>Municipality name (jp): </b>　", sfPolyPtsLegend$pref_name, sfPolyPtsLegend$muni_name, "<br>",
            "<b>OD zone code: </b>　", sfPolyPtsLegend$id_odzone, "<br>",
            "<b>Regional attractive index (commuting to office)：</b>　", round(sfPolyPtsLegend$b_delta_office, 3), "<br>"
          ),
          popupOptions = list(maxWidth = 500, closeOnClick = TRUE),
          label = paste(sfPolyPtsLegend$muni_name_en, sfPolyPtsLegend$pref_name_en, sep = ", "),
          group = "Regional Attractiveness Index"
        ) %>%
        addPolygons(
          data = sfMuni, 
          fill = FALSE, 
          color = "#F0F0F0", 
          weight = 1.0, 
          group = "Municipality Division"
        ) %>%
        addPolygons(
          data = sfPref, 
          fill = FALSE, 
          color = "#303030", 
          weight = 3.0, 
          group = "Prefecture Division"
        ) %>%
        addLegend(
          colors = df_pal$color_value,
          labels = df_pal$color_label,
          title = paste("Regional attractive index", "(commuting to office)", sep = "<br>")
        ) %>%
        addLayersControl(
          overlayGroups = c("Regional Attractiveness Index", "Municipality Division", "Prefecture Division"),
          position = "topright",
          options = layersControlOptions(collapsed = TRUE)
        )
    }
    #LEAFLET for Commuting to Schools
    else if(input$map1_button == 3) {
      #SF Object
      sfPolyPtsLegend <- sfPolyPts %>%
        dplyr::mutate(b_delta_color_group = cut(b_delta_school, breaks = breaks, labels = breaks_label)) %>%
        dplyr::mutate(b_delta_color_group = as.character(b_delta_color_group)) %>%
        dplyr::left_join(df_pal, by = c("b_delta_color_group" = "color_label"))%>%
        dplyr::rename(b_delta_color_value = color_value) %>%
        dplyr::mutate(b_delta_color_value = if_else(is.na(b_delta_color_value), "#E5E5E5", b_delta_color_value)) 
      
      #Leaflet Object
      map1_proxy %>%
        clearShapes() %>%
        clearControls() %>%
        addPolygons(
          data = sfPolyPtsLegend,
          fillColor = ~b_delta_color_value, 
          fillOpacity = 0.5,
          stroke = FALSE, 
          popup = paste0(
            "<b>Municipality code: </b>　", sfPolyPtsLegend$muni_code, "<br>",
            "<b>Municipality name (en): </b>　", sfPolyPtsLegend$muni_name_en, ", ", sfPolyPtsLegend$pref_name_en, "<br>",
            "<b>Municipality name (jp): </b>　", sfPolyPtsLegend$pref_name, sfPolyPtsLegend$muni_name, "<br>",
            "<b>OD zone code: </b>　", sfPolyPtsLegend$id_odzone, "<br>",
            "<b>Regional attractive index (commuting to school): </b>　", round(sfPolyPtsLegend$b_delta_school, 3), "<br>"
          ),
          popupOptions = list(maxWidth = 500, closeOnClick = TRUE),
          label = paste(sfPolyPtsLegend$muni_name_en, sfPolyPtsLegend$pref_name_en, sep = ", "),
          group = "Regional Attractiveness Index"
        ) %>%
        addPolygons(
          data = sfMuni, 
          fill = FALSE, 
          color = "#F0F0F0", 
          weight = 1.0, 
          group = "Municipality Division"
        ) %>%
        addPolygons(
          data = sfPref, 
          fill = FALSE, 
          color = "#303030", 
          weight = 3.0, 
          group = "Prefecture Division"
        ) %>%
        addLegend(
          colors = df_pal$color_value,
          labels = df_pal$color_label,
          title = paste("Regional attractive index", "(commuting to school)", sep = "<br>")
        ) %>%
        addLayersControl(
          overlayGroups = c("Regional Attractiveness Index", "Municipality Division", "Prefecture Division"),
          position = "topright",
          options = layersControlOptions(collapsed = TRUE)
        )
    }
    #LEAFLET
    else if(input$map1_button == 4) {
      #SF Object
      sfPolyPtsLegend <- sfPolyPts %>%
        dplyr::mutate(b_delta_color_group = cut(b_delta_free, breaks = breaks, labels = breaks_label)) %>%
        dplyr::mutate(b_delta_color_group = as.character(b_delta_color_group)) %>%
        dplyr::left_join(df_pal, by = c("b_delta_color_group" = "color_label"))%>%
        dplyr::rename(b_delta_color_value = color_value) %>%
        dplyr::mutate(b_delta_color_value = if_else(is.na(b_delta_color_value), "#E5E5E5", b_delta_color_value)) 
      
      #Leaflet Object
      map1_proxy %>%
        clearShapes() %>%
        clearControls() %>%
        addPolygons(
          data = sfPolyPtsLegend,
          fillColor = ~b_delta_color_value, 
          fillOpacity = 0.5,
          stroke = FALSE, 
          popup = paste0(
            "<b>Municipality code: </b>　", sfPolyPtsLegend$muni_code, "<br>",
            "<b>Municipality name (en): </b>　", sfPolyPtsLegend$muni_name_en, ", ", sfPolyPtsLegend$pref_name_en, "<br>",
            "<b>Municipality name (jp): </b>　", sfPolyPtsLegend$pref_name, sfPolyPtsLegend$muni_name, "<br>",
            "<b>OD zone code: </b>　", sfPolyPtsLegend$id_odzone, "<br>",
            "<b>Regional attractive index (free trips)：</b>　", round(sfPolyPtsLegend$b_delta_free, 3), "<br>"
          ),
          popupOptions = list(maxWidth = 500, closeOnClick = TRUE),
          label = paste(sfPolyPtsLegend$muni_name_en, sfPolyPtsLegend$pref_name_en, sep = ", "),
          group = "Regional Attractiveness Index"
        ) %>%
        addPolygons(
          data = sfMuni, 
          fill = FALSE, 
          color = "#F0F0F0", 
          weight = 1.0, 
          group = "Municipality Division"
        ) %>%
        addPolygons(
          data = sfPref, 
          fill = FALSE, 
          color = "#303030", 
          weight = 3.0, 
          group = "Prefecture Division"
        ) %>%
        addLegend(
          colors = df_pal$color_value,
          labels = df_pal$color_label,
          title = paste("Regional attractive index", "(free trips)", sep = "<br>")
        ) %>%
        addLayersControl(
          overlayGroups = c("Regional Attractiveness Index", "Municipality Division", "Prefecture Division"),
          position = "topright",
          options = layersControlOptions(collapsed = TRUE)
        )
    }
    #LEAFLET
    else if(input$map1_button == 5) {
      #SF Object
      sfPolyPtsLegend <- sfPolyPts %>%
        dplyr::mutate(b_delta_color_group = cut(b_delta_business, breaks = breaks, labels = breaks_label)) %>%
        dplyr::mutate(b_delta_color_group = as.character(b_delta_color_group)) %>%
        dplyr::left_join(df_pal, by = c("b_delta_color_group" = "color_label"))%>%
        dplyr::rename(b_delta_color_value = color_value) %>%
        dplyr::mutate(b_delta_color_value = if_else(is.na(b_delta_color_value), "#E5E5E5", b_delta_color_value)) 
      
      #Leaflet Object
      map1_proxy %>%
        clearShapes() %>%
        clearControls() %>%
        addPolygons(
          data = sfPolyPtsLegend,
          fillColor = ~b_delta_color_value, 
          fillOpacity = 0.5,
          stroke = FALSE, 
          popup = paste0(
            "<b>Municipality code: </b>　", sfPolyPtsLegend$muni_code, "<br>",
            "<b>Municipality name (en): </b>　", sfPolyPtsLegend$muni_name_en, ", ", sfPolyPtsLegend$pref_name_en, "<br>",
            "<b>Municipality name (jp): </b>　", sfPolyPtsLegend$pref_name, sfPolyPtsLegend$muni_name, "<br>",
            "<b>OD zone code: </b>　", sfPolyPtsLegend$id_odzone, "<br>",
            "<b>Regional attractive index (business trips)：</b>　", round(sfPolyPtsLegend$b_delta_business, 3), "<br>"
          ),
          popupOptions = list(maxWidth = 500, closeOnClick = TRUE),
          label = paste(sfPolyPtsLegend$muni_name_en, sfPolyPtsLegend$pref_name_en, sep = ", "),
          group = "Regional Attractiveness Index"
        ) %>%
        addPolygons(
          data = sfMuni, 
          fill = FALSE, 
          color = "#F0F0F0", 
          weight = 1.0, 
          group = "Municipality Division"
        ) %>%
        addPolygons(
          data = sfPref, 
          fill = FALSE, 
          color = "#303030", 
          weight = 3.0, 
          group = "Prefecture Division"
        ) %>%
        addLegend(
          colors = df_pal$color_value,
          labels = df_pal$color_label,
          title = paste("Regional attractive index", "(business trips)", sep = "<br>")
        ) %>%
        addLayersControl(
          overlayGroups = c("Regional Attractiveness Index", "Municipality Division", "Prefecture Division"),
          position = "topright",
          options = layersControlOptions(collapsed = TRUE)
        )
    }
    #LEAFLET
    else if(input$map1_button == 6) {
      #SF Object
      sfPolyPtsLegend <- sfPolyPts %>%
        dplyr::mutate(b_delta_color_group = cut(b_delta_home, breaks = breaks, labels = breaks_label)) %>%
        dplyr::mutate(b_delta_color_group = as.character(b_delta_color_group)) %>%
        dplyr::left_join(df_pal, by = c("b_delta_color_group" = "color_label"))%>%
        dplyr::rename(b_delta_color_value = color_value) %>%
        dplyr::mutate(b_delta_color_value = if_else(is.na(b_delta_color_value), "#E5E5E5", b_delta_color_value)) 
      
      #Leaflet Object
      map1_proxy %>%
        clearShapes() %>%
        clearControls() %>%
        addPolygons(
          data = sfPolyPtsLegend,
          fillColor = ~b_delta_color_value, 
          fillOpacity = 0.5,
          stroke = FALSE, 
          popup = paste0(
            "<b>Municipality code: </b>　", sfPolyPtsLegend$muni_code, "<br>",
            "<b>Municipality name (en): </b>　", sfPolyPtsLegend$muni_name_en, ", ", sfPolyPtsLegend$pref_name_en, "<br>",
            "<b>Municipality name (jp): </b>　", sfPolyPtsLegend$pref_name, sfPolyPtsLegend$muni_name, "<br>",
            "<b>OD zone code: </b>　", sfPolyPtsLegend$id_odzone, "<br>",
            "<b>Regional attractive index (returning to home)：</b>　", round(sfPolyPtsLegend$b_delta_home, 3), "<br>"
          ),
          popupOptions = list(maxWidth = 500, closeOnClick = TRUE),
          label = paste(sfPolyPtsLegend$muni_name_en, sfPolyPtsLegend$pref_name_en, sep = ", "),
          group = "Regional Attractiveness Index"
        ) %>%
        addPolygons(
          data = sfMuni, 
          fill = FALSE, 
          color = "#F0F0F0", 
          weight = 1.0, 
          group = "Municipality Division"
        ) %>%
        addPolygons(
          data = sfPref, 
          fill = FALSE, 
          color = "#303030", 
          weight = 3.0, 
          group = "Prefecture Division"
        ) %>%
        addLegend(
          colors = df_pal$color_value,
          labels = df_pal$color_label,
          title = paste("Regional attractive index", "(returning to home)", sep = "<br>")
        ) %>%
        addLayersControl(
          overlayGroups = c("Regional Attractiveness Index", "Municipality Division", "Prefecture Division"),
          position = "topright",
          options = layersControlOptions(collapsed = TRUE)
        )
    }
    #LEAFLET
    else if(input$map1_button == 7) {
      #SF Object
      sfPolyPtsLegend <- sfPolyPts %>%
        dplyr::mutate(b_delta_color_group = cut(b_delta_unknown, breaks = breaks, labels = breaks_label)) %>%
        dplyr::mutate(b_delta_color_group = as.character(b_delta_color_group)) %>%
        dplyr::left_join(df_pal, by = c("b_delta_color_group" = "color_label"))%>%
        dplyr::rename(b_delta_color_value = color_value) %>%
        dplyr::mutate(b_delta_color_value = if_else(is.na(b_delta_color_value), "#E5E5E5", b_delta_color_value)) 
      
      #Leaflet Object
      map1_proxy %>%
        clearShapes() %>%
        clearControls() %>%
        addPolygons(
          data = sfPolyPtsLegend,
          fillColor = ~b_delta_color_value, 
          fillOpacity = 0.5,
          stroke = FALSE, 
          popup = paste0(
            "<b>Municipality code: </b>　", sfPolyPtsLegend$muni_code, "<br>",
            "<b>Municipality name (en): </b>　", sfPolyPtsLegend$muni_name_en, ", ", sfPolyPtsLegend$pref_name_en, "<br>",
            "<b>Municipality name (jp): </b>　", sfPolyPtsLegend$pref_name, sfPolyPtsLegend$muni_name, "<br>",
            "<b>OD zone code: </b>　", sfPolyPtsLegend$id_odzone, "<br>",
            "<b>Regional attractive index (unknown trips)：</b>　", round(sfPolyPtsLegend$b_delta_unknown, 3), "<br>"
          ),
          popupOptions = list(maxWidth = 500, closeOnClick = TRUE),
          label = paste(sfPolyPtsLegend$muni_name_en, sfPolyPtsLegend$pref_name_en, sep = ", "),
          group = "Regional Attractiveness Index"
        ) %>%
        addPolygons(
          data = sfMuni, 
          fill = FALSE, 
          color = "#F0F0F0", 
          weight = 1.0, 
          group = "Municipality Division"
        ) %>%
        addPolygons(
          data = sfPref, 
          fill = FALSE, 
          color = "#303030", 
          weight = 3.0, 
          group = "Prefecture Division"
        ) %>%
        addLegend(
          colors = df_pal$color_value,
          labels = df_pal$color_label,
          title = paste("Regional attractive index", " (unknown trips)", sep = "<br>")
        ) %>%
        addLayersControl(
          overlayGroups = c("Regional Attractiveness Index", "Municipality Division", "Prefecture Division"),
          position = "topright",
          options = layersControlOptions(collapsed = TRUE)
        )
    } 
  }, ignoreInit = TRUE)
  
  #++++++++++++++++++++++++++++++++++++++
  #Tab2 Map
  #++++++++++++++++++++++++++++++++++++++

  #Leaflet Output
  observeEvent(input$buttonMapUpdate, {
    
    #Popup
    popup_yearmonth = as.character(format(input$listMapDate, format = "%Y-%m"))
    
    #Popup
    if( input$listMapDay == 1 ){
      popup_day = "Weekday"
    } 
    else if ( input$listMapDay == 2 ){
      popup_day = "Weekend/Holiday"
    }
    
    #Popup
    if( input$listMapGender == 0 ){
      popup_gender = "Total"
    } 
    else if ( input$listMapGender == 1 ){
      popup_gender = "Male"
    }
    else if ( input$listMapGender == 2 ){
      popup_gender = "Female"
    }
    
    #Popup
    if( input$listMapAge == 0 ){
      popup_age = "Total"
    } 
    else if ( input$listMapAge == 1 ){
      popup_age = "15-39"
    }
    else if ( input$listMapAge == 2 ){
      popup_age = "40-59"
    }
    else if ( input$listMapAge == 3 ){
      popup_age = "60 and above"
    }
    
    #DataFrame Filtered 
    dfDeltaMssMap <- dfDeltaMss %>%
      dplyr::filter(
        year == lubridate::year(input$listMapDate) &
          month == lubridate::month(input$listMapDate) &
          day == input$listMapDay &
          gender == input$listMapGender & 
          age_group == input$listMapAge
      )
    
    #Shapefiles
    sfPolyMssLegend <- sfMuni %>%
      dplyr::left_join(dfDeltaMssMap, by = c( "muni_code" = "code_pref_muni" )) %>%
      dplyr::select(pref_code, pref_name, pref_name_en, muni_code, muni_name, muni_name_en, starts_with("b_delta")) %>%
      dplyr::mutate(b_delta_total = if_else(b_delta_total > 0, NA_real_, b_delta_total)) %>%
      dplyr::mutate(b_delta_color_group = cut(b_delta_total, breaks = breaks, labels = breaks_label)) %>%
      dplyr::mutate(b_delta_color_group = as.character(b_delta_color_group)) %>%
      dplyr::left_join(df_pal, by = c("b_delta_color_group" = "color_label"))%>%
      dplyr::rename(b_delta_color_value = color_value) %>%
      dplyr::mutate(b_delta_color_value = if_else(is.na(b_delta_color_value), "#E5E5E5", b_delta_color_value)) 
    
    #Leaflet Object
    output$map2 <- renderLeaflet({
      leaflet() %>%
        #Tile Layer from Mapbox
        addMapboxGL(
          accessToken = accessToken,
          style = styleUrl,
          setView = FALSE
        ) %>%
        addPolygons(
          data = sfPolyMssLegend,
          fillColor = ~b_delta_color_value, 
          fillOpacity = 0.5,
          stroke = FALSE, 
          popup = paste0(
            "<b>Date: </b>　", popup_yearmonth, "<br>",
            "<b>Day: </b>　", popup_day, "<br>",
            "<b>Gender: </b>　", popup_gender, "<br>",
            "<b>Age Group: </b>　", popup_age, "<br>",
            "<b>Municipality code: </b>　", sfPolyMssLegend$muni_code, "<br>",
            "<b>Municipality name (en): </b>　", sfPolyMssLegend$muni_name_en, ", ", sfPolyMssLegend$pref_name_en, "<br>",
            "<b>Municipality name (jp): </b>　", sfPolyMssLegend$pref_name, sfPolyMssLegend$muni_name, "<br>",
            "<b>Regional attractive index: </b>　", round(sfPolyMssLegend$b_delta_total, 3), "<br>"
          ),
          popupOptions = list(maxWidth = 500, closeOnClick = TRUE),
          label = paste0(sfPolyMssLegend$muni_name_en, ", ", sfPolyMssLegend$pref_name_en),
          group = "Regional Attractiveness Index"
        ) %>%
        addPolygons(
          data = sfMuni, 
          fill = FALSE, 
          color = "#F0F0F0", 
          weight = 1.0, 
          group = "Municipality Division"
        ) %>%
        addPolygons(
          data = sfPref, 
          fill = FALSE, 
          color = "#303030", 
          weight = 3.0, 
          group = "Prefecture Division"
        ) %>%
        addLegend(
          colors = df_pal$color_value,
          labels = df_pal$color_label,
          title = "Regional Attractiveness Index"
        ) %>%
        addLayersControl(
          overlayGroups = c("Regional Attractiveness Index", "Municipality Division", "Prefecture Division"),
          position = "topright",
          options = layersControlOptions(collapsed = TRUE)
        )      
    })
  }, ignoreInit = FALSE, ignoreNULL = FALSE, once = TRUE)
  
  #LeafletProxy
  map2_proxy <- leafletProxy("map2", session)
  
  #Switch Leaflet
  observeEvent(input$buttonMapUpdate, {
    
    #Popup
    popup_yearmonth = as.character(format(input$listMapDate, format = "%Y-%m"))
    
    #Popup
    if( input$listMapDay == 1 ){
      popup_day = "Weekday"
    } 
    else if ( input$listMapDay == 2 ){
      popup_day = "Weekend/Holiday"
    }
    
    #Popup
    if( input$listMapGender == 0 ){
      popup_gender = "Total"
    } 
    else if ( input$listMapGender == 1 ){
      popup_gender = "Male"
    }
    else if ( input$listMapGender == 2 ){
      popup_gender = "Female"
    }
    
    #Popup
    if( input$listMapAge == 0 ){
      popup_age = "Total"
    } 
    else if ( input$listMapAge == 1 ){
      popup_age = "15-39"
    }
    else if ( input$listMapAge == 2 ){
      popup_age = "40-59"
    }
    else if ( input$listMapAge == 3 ){
      popup_age = "60 and above"
    }

    #DataFrame Filtered 
    dfDeltaMssMap <- dfDeltaMss %>%
      dplyr::filter(
        year == lubridate::year(input$listMapDate) &
          month == lubridate::month(input$listMapDate) &
          day == input$listMapDay &
          gender == input$listMapGender & 
          age_group == input$listMapAge
      )

    #Shapefiles
    sfPolyMssLegend <- sfMuni %>%
      dplyr::left_join(dfDeltaMssMap, by = c( "muni_code" = "code_pref_muni" )) %>%
      dplyr::select(pref_code, pref_name, pref_name_en, muni_code, muni_name, muni_name_en, starts_with("b_delta")) %>%
      dplyr::mutate(b_delta_total = if_else(b_delta_total > 0, NA_real_, b_delta_total)) %>%
      dplyr::mutate(b_delta_color_group = cut(b_delta_total, breaks = breaks, labels = breaks_label)) %>%
      dplyr::mutate(b_delta_color_group = as.character(b_delta_color_group)) %>%
      dplyr::left_join(df_pal, by = c("b_delta_color_group" = "color_label"))%>%
      dplyr::rename(b_delta_color_value = color_value) %>%
      dplyr::mutate(b_delta_color_value = if_else(is.na(b_delta_color_value), "#E5E5E5", b_delta_color_value)) 
    
    #Leaflet Object
    map2_proxy %>%
      clearShapes() %>%
      clearControls() %>%
      addPolygons(
        data = sfPolyMssLegend,
        fillColor = ~b_delta_color_value, 
        fillOpacity = 0.5,
        stroke = FALSE, 
        popup = paste0(
          "<b>Date: </b>　", popup_yearmonth, "<br>",
          "<b>Day: </b>　", popup_day, "<br>",
          "<b>Gender: </b>　", popup_gender, "<br>",
          "<b>Age Group: </b>　", popup_age, "<br>",
          "<b>Municipality code: </b>　", sfPolyMssLegend$muni_code, "<br>",
          "<b>Municipality name (en): </b>　", sfPolyMssLegend$muni_name_en, ", ", sfPolyMssLegend$pref_name_en, "<br>",
          "<b>Municipality name (jp): </b>　", sfPolyMssLegend$pref_name, sfPolyMssLegend$muni_name, "<br>",
          "<b>Regional attractive index: </b>　", round(sfPolyMssLegend$b_delta_total, 3), "<br>"
        ),
        popupOptions = list(maxWidth = 500, closeOnClick = TRUE),
        label = paste0(sfPolyMssLegend$muni_name_en, ", ", sfPolyMssLegend$pref_name_en),
        group = "Regional Attractiveness Index"
      ) %>%
      addPolygons(
        data = sfMuni, 
        fill = FALSE, 
        color = "#F0F0F0", 
        weight = 1.0, 
        group = "Municipality Division"
      ) %>%
      addPolygons(
        data = sfPref, 
        fill = FALSE, 
        color = "#303030", 
        weight = 3.0, 
        group = "Prefecture Division"
      ) %>%
      addLegend(
        colors = df_pal$color_value,
        labels = df_pal$color_label,
        title = "Regional Attractiveness Index"
      ) %>%
      addLayersControl(
        overlayGroups = c("Regional Attractiveness Index", "Municipality Division", "Prefecture Division"),
        position = "topright",
        options = layersControlOptions(collapsed = TRUE)
      )
  }, ignoreInit = TRUE, ignoreNULL = FALSE)
  
  #++++++++++++++++++++++++++++++++++++++
  #Tab3 Time-series
  #++++++++++++++++++++++++++++++++++++++
  observeEvent(input$buttonLineUpdate, {
    
    #Municipality Code
    inputListLineMuni1 <- as.numeric(strsplit(input$listLineMuni1, ", ")[[1]][1])
    inputListLineMuni2 <- as.numeric(strsplit(input$listLineMuni2, ", ")[[1]][1])
    
    #DataFrame Base Day1
    dfDeltaLineDay1Base <- dfDeltaMss %>%
      dplyr::filter(
        code_pref_muni == inputListLineMuni1 &
          day == 1 &
          gender == input$listLineGender & 
          age_group == input$listLineAge
      ) %>%
      dplyr::left_join(dfMuni, by = c("code_pref_muni" = "muni_code")) %>%
      dplyr::mutate(time = paste0(year, "-", stringr::str_pad(month, 2, pad = "0"), "-01")) %>%
      dplyr::mutate(ts = as.Date(time, format = "%Y-%m-%d", tz = "Asia/Tokyo"))
    
    #DataFrame Base Day2
    dfDeltaLineDay2Base <- dfDeltaMss %>%
      dplyr::filter(
        code_pref_muni == inputListLineMuni1 &
          day == 2 &
          gender == input$listLineGender & 
          age_group == input$listLineAge
      ) %>%
      dplyr::left_join(dfMuni, by = c("code_pref_muni" = "muni_code")) %>%
      dplyr::mutate(time = paste0(year, "-", stringr::str_pad(month, 2, pad = "0"), "-01")) %>%
      dplyr::mutate(ts = as.Date(time, format = "%Y-%m-%d"))
    
    #DataFrame Comparison Day1
    dfDeltaLineDay1Comp <- dfDeltaMss %>%
      dplyr::filter(
        code_pref_muni == inputListLineMuni2 &
          day == 1 &
          gender == input$listLineGender & 
          age_group == input$listLineAge
      ) %>%
      dplyr::left_join(dfMuni, by = c("code_pref_muni" = "muni_code")) %>%
      dplyr::mutate(time = paste0(year, "-", stringr::str_pad(month, 2, pad = "0"), "-01")) %>%
      dplyr::mutate(ts = as.Date(time, format = "%Y-%m-%d", tz = "Asia/Tokyo"))
    
    #DataFrame Comparison Day2
    dfDeltaLineDay2Comp <- dfDeltaMss %>%
      dplyr::filter(
        code_pref_muni == inputListLineMuni2 &
          day == 2 &
          gender == input$listLineGender & 
          age_group == input$listLineAge
      ) %>%
      dplyr::left_join(dfMuni, by = c("code_pref_muni" = "muni_code")) %>%
      dplyr::mutate(time = paste0(year, "-", stringr::str_pad(month, 2, pad = "0"), "-01")) %>%
      dplyr::mutate(ts = as.Date(time, format = "%Y-%m-%d"))
    
    #Highcharts: Value
    output$line1 <- renderHighchart({
      
      hc1 <- highchart() %>%
        hc_add_series(
          data = dfDeltaLineDay1Base,
          hcaes(x = ts, y = b_delta_total),
          type = "line",
          color = "#2F7ED8",
          lineWidth = 2,
          name = paste0(dfDeltaLineDay1Base$muni_name_en[1], " (Weekday)"),
          showInLegend = TRUE
        ) %>%
        hc_add_series(
          data = dfDeltaLineDay2Base,
          hcaes(x = ts, y = b_delta_total),
          type = "line",
          color = "#CD5C5C",
          lineWidth = 2,
          name = paste0(dfDeltaLineDay2Base$muni_name_en[1], " (Weekend/Holiday)"),
          showInLegend = TRUE
        ) %>%
        hc_add_series(
          data = dfDeltaLineDay1Comp,
          hcaes(x = ts, y = b_delta_total),
          type = "line",
          color = "#2F7ED8",
          lineWidth = 2,
          name = paste0(dfDeltaLineDay1Comp$muni_name_en[1], " (Weekday)"),
          showInLegend = TRUE,
          dashStyle = "longdash"
        ) %>%
        hc_add_series(
          data = dfDeltaLineDay2Comp,
          hcaes(x = ts, y = b_delta_total),
          type = "line",
          color = "#CD5C5C",
          lineWidth = 2,
          name = paste0(dfDeltaLineDay2Comp$muni_name_en[1], " (Weekend/Holiday)"),
          showInLegend = TRUE,
          dashStyle = "longdash"
        ) %>%
        hc_yAxis(
          title = list(text = "Regional Attractiveness Index"),
          allowDecimals = TRUE
        ) %>%
        hc_xAxis(
          type = "datetime", 
          showLastLabel = TRUE,
          dateTimeLabelFormats = list(day = "%d", month = "%b-%Y")
        ) %>%
        hc_tooltip(valueDecimals = 4,
                   pointFormat = "Municipality: {point.series.name} <br> Delta: {point.y}") %>%
        hc_add_theme(hc_theme_flat()) %>%
        hc_credits(enabled = TRUE)
      
      #plot
      hc1
      
    })
    
  }, ignoreInit = FALSE, ignoreNULL = FALSE)
  
}
