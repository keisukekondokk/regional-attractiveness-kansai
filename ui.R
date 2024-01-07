# 
# (C) Keisuke Kondo
# Release Date: 2023-03-31
# Updated Date: 2024-01-01
# 
# - global.R
# - ui.R
# - server.R
# 

dashboardPage(
  skin = "blue",
  #++++++++++++++++++++++++++++++++++++++
  #Header
  dashboardHeader(
    title = "Regional Attractiveness Index",
    titleWidth = 300,
    tags$li(
      actionLink(
        "github",
        label = "",
        icon = icon("github"),
        href = "https://github.com/keisukekondokk/regional-attractiveness-kansai",
        onclick = "window.open('https://github.com/keisukekondokk/regional-attractiveness-kansai', '_blank')"
      ),
      class = "dropdown"
    )
  ),
  #++++++++++++++++++++++++++++++++++++++
  #SideBar
  dashboardSidebar(width = 300,
                   sidebarMenu(
                     id = "sidebar_switch",
                     menuItem("Map (Person Trip Survey)",
                              tabName = "tab_pts1",
                              icon = icon("map")),
                     menuItem("Map (Mobile Phone Data)",
                              tabName = "tab_mss1",
                              icon = icon("map")),
                     menuItem("Time Series (Mobile Phone Data)",
                              tabName = "tab_mss2",
                              icon = icon("map")),
                     menuItem("Readme",
                              tabName = "readme",
                              icon = icon("info-circle"))
                   )),
  #++++++++++++++++++++++++++++++++++++++
  #Body
  dashboardBody(
    tags$style(type = "text/css", "html, body {margin: 0; width: 100%; height: 100%}"),
    tags$style(type = "text/css", "h2 {margin-top: 20px; margin-bottom: 5px}"),
    tags$style(type = "text/css", "h3, h4 {margin-top: 15px; margin-bottom: 3px}"),
    tags$style(
      type = "text/css",
      "#map1, #map2 {margin: 0; height: calc(100vh - 50px) !important;}"
    ),
    tags$style(
      type = "text/css",
      ".panel {padding: 5px; background-color: #FFFFFF; opacity: 0.7;} .panel:hover {opacity: 1;}"
    ),
    tags$style(
      type = "text/css",
      "body {overflow-y: scroll;}"
    ),
    #++++++++++++++++++++++++++++++++++++++
    #TabItems
    tabItems(
      #------------------------------------------------------------------
      #Tab1
      tabItem(
        tabName = "tab_pts1",
        fluidRow(
          style = "margin-top: -20px; margin-bottom: -20px;",
          absolutePanel(
            id = "panel_map1",
            class = "panel panel-default",
            top = "15vh",
            bottom = "auto",
            left = "auto",
            right = "auto",
            width = 220,
            height = "auto",
            draggable = TRUE,
            style = "z-index: 100;",
            radioButtons(
              "map1_button",
              label = h4(span(icon("person-walking"), "Select trip type:")),
              choices = list(
                "Total Trips" = 1,
                "Commuting to Office" = 2,
                "Commuting to School" = 3,
                "Free Trips" = 4,
                "Business Trips" = 5,
                "Returning to Home" = 6,
                "Unknown Trips" = 7
              ),
              selected = 1,
              width = "100%"
            )
          ),
          leafletOutput("map1") %>%
            withSpinner(color = getOption("spinner.color", default = "#3C8EBC"))
        )
      ),
      #------------------------------------------------------------------
      #Tab2
      tabItem(
        tabName = "tab_mss1",
        fluidRow(
          style = "margin-top: -20px; margin-bottom: -20px;",
          absolutePanel(
            id = "panel_map2",
            class = "panel panel-default",
            top = "15vh",
            bottom = "auto",
            left = "auto",
            right = "auto",
            width = 220,
            height = "auto",
            draggable = TRUE,
            style = "z-index:10;",
            airDatepickerInput(
              "listMapDate",
              label = h4(span(icon("calendar"), "Select year and month:")),
              value = "2016-08-01",
              min = "2015-09-01",
              max = "2016-08-01",
              view = "months",
              minView = "months",
              dateFormat = "MMMM yyyy",
              autoClose = TRUE
            ),
            radioButtons(
              "listMapDay",
              label = h4(span(icon("business-time"), "Select day type:")),
              choices = list(
                "Weekday" = 1,
                "Weekend/Holiday" = 2
              ),
              selected = 1,
              width = "100%"
            ),
            #
            radioButtons(
              "listMapGender",
              label = h4(span(
                icon("user"), "Select gender type:"
              )),
              choices = list(
                "Total" = 0,
                "Male" = 1,
                "Female" = 2
              ),
              selected = 0,
              width = "100%"
            ),
            # Slider bar for Infectious State
            radioButtons(
              "listMapAge",
              label = h4(span(icon("users"), "Select age gruop:")),
              choices = list(
                "Total" = 0,
                "15-39" = 1,
                "40-59" = 2,
                "60 and over" = 3
              ),
              selected = 0,
              width = "100%"
            ),
            div(
              actionButton(
                inputId = "buttonMapUpdate", 
                label = span(icon("play-circle"), "Update"), 
                width = "100%",
                class = "btn btn-primary"
              )
            )
          ),
          leafletOutput("map2") %>%
            withSpinner(color = getOption("spinner.color", default = "#3C8EBC"))
        )
      ),
      #------------------------------------------------------------------
      #Tab3
      tabItem(
        tabName = "tab_mss2",
        fluidRow(
          style = "margin-top: -20px; margin-bottom: -10px;",
          column(
            width = 12,
            div(style = "margin-top: 10px")
          ),
          column(
            width = 6,
            selectInput(
              "listLineMuni1",
              width = "100%",
              label = h4(span(icon("chart-line"), "Select Municipality for Baseline (Solid Line)")),
              choices = listMuni,
              selected = "28110, Chuo-ku Kobe-shi, Hyogo (兵庫県神戸市中央区)"
            )
          ),
          column(
            width = 6,
            selectInput(
              "listLineMuni2",
              width = "100%",
              label = h4(span(icon("chart-line"), "Select Municipality for Comparison (Dashed Line)")),
              choices = listMuni,
              selected = "27104, Konohana-ku Osaka-shi, Osaka (大阪府大阪市此花区)"
            )
          ),
          column(
            width = 6,
            radioButtons(
              "listLineGender",
              width = "100%",
              label = h4(span(icon("chart-line"), "Select Gender Type:")),
              choices = list(
                "Total" = 0,
                "Male" = 1,
                "Female" = 2
              ),
              selected = 0,
              inline = TRUE
            )
          ),
          column(
            width = 6,
            radioButtons(
              "listLineAge",
              width = "100%",
              label = h4(span(icon("chart-line"), "Select Age Group:")),
              choices = list(
                "Total" = 0,
                "15-39" = 1,
                "40-59" = 2,
                "60 and over" = 3
              ),
              selected = 0,
              inline = TRUE
            )
          ),
          column(
            width = 12,
            style = "margin-bottom: 20px; color: white;",
            actionButton(
              "buttonLineUpdate", 
              span(icon("play-circle"), "Update"), 
              class = "btn btn-primary",
              width = "100%"
            )
          ),
          box(
            width = 12,
            highchartOutput("line1", height = "550px") %>%
              withSpinner(color = getOption("spinner.color", default = "#3C8EBC"))
          )
        )
      ),
      #------------------------------------------------------------------
      #Tab4
      tabItem(
        tabName = "readme",
        fluidRow(
          style = "margin-bottom: -15px; margin-left: -30px; margin-right: -30px;",
          column(
            width = 12,
            box(
              width = NULL,
              title = h2(span(icon("info-circle"), "Readme")),
              solidHeader = TRUE,
              #------------------------------------------------------------------
              h3(style = "border-bottom: solid 1px black;", span(icon("fas fa-pen-square"), "Introduction")),
              p("This web app visualizes the regional attractiveness index, estimated from mobility data. The concept is proposed in Kondo (2023)."),
              #------------------------------------------------------------------
              h3(style = "border-bottom: solid 1px black;", span(icon("user-circle"), "Author")),
              p(
                "Keisuke Kondo", br(),
                "Senior Fellow, Research Institute of Economy, Trade and Industry (RIETI)", br(),
                "Associate Professor, Research Institute for Economics and Business Administration (RIEB), Kobe University"
              ),
              h3(style = "border-bottom: solid 1px black;", span(icon("envelope-open"), "Contact")),
              p("Email: kondo-keisuke@rieti.go.jp"),
              h3(style = "border-bottom: solid 1px black;", span(icon("fas fa-file-alt"), "Terms of Use")),
              p(
                "Users (hereinafter referred to as the User or Users depending on context) of the content on this web site (hereinafter referred to as the Content) are required to conform to the terms of use described herein (hereinafter referred to as the Terms of Use). Furthermore, use of the Content constitutes agreement by the User with the Terms of Use. The content of the Terms of Use is subject to change without prior notice."
              ),
              h4("Copyright"),
              p("The copyright of the developed code belongs to Keisuke Kondo."),
              h4("Copyright of Third Parties"),
              p(
                "Keisuke Kondo developed the Content based on the information on the 2010 Person Trip Survey of Kinki Metropolitan Area and the From-To Analysis of the Regional Economy and Society Analyzing System (RESAS). The original data of From-To Analysis is based on Mobile Spatial Statistics® of NTT DOCOMO. The shapefiles were taken from the Digital National Land Information (MLIT of Japan) and the Portal Site of Official Statistics of Japan, e-Stat. Users must confirm the terms of use of the RESAS and the e-Stat, prior to using the Content."
              ),
              h4("License"),
              p("The developed code is released under the MIT License."),
              h4("Disclaimer"),
              p("(a) Keisuke Kondo makes the utmost effort to maintain, but nevertheless does not guarantee, the accuracy, completeness, integrity, usability, and recency of the Content."),
              p("(b) Keisuke Kondo and any organization to which Keisuke Kondo belongs hereby disclaim responsibility and liability for any loss or damage that may be incurred by Users as a result of using the Content. Keisuke Kondo and any organization to which Keisuke Kondo belongs are neither responsible nor liable for any loss or damage that a User of the Content may cause to any third party as a result of using the Content"),
              p("(c) The Content may be modified, moved or deleted without prior notice."),
              #------------------------------------------------------------------
              h3(style = "border-bottom: solid 1px black;", span(icon("database"), "Data Sources")),
              h4("2010 Person Trip Survey of Kinki Metropolitan Area: Keihanshin Metropolitan Area Transportation Planning Council"),
              p(
                "URL: ",
                a(
                  href = "https://www.kkr.mlit.go.jp/plan/pt/",
                  "https://www.kkr.mlit.go.jp/plan/pt/",
                  .noWS = "outside"
                ),
                .noWS = c("after-begin", "before-end")
              ), 
              h4("Digital National Land Information: MLIT of Japan"),
              p(
                "URL: ",
                a(
                  href = "https://nlftp.mlit.go.jp/ksj/index.html",
                  "https://nlftp.mlit.go.jp/ksj/index.html",
                  .noWS = "outside"
                ),
                .noWS = c("after-begin", "before-end")
              ),
              h4("From-To Analysis: RESAS API"),
              p(
                "URL: ",
                a(
                  href = "https://opendata.resas-portal.go.jp/docs/api/v1/partner/docomo/destination.html",
                  "https://opendata.resas-portal.go.jp/docs/api/v1/partner/docomo/destination.html",
                  .noWS = "outside"
                ),
                .noWS = c("after-begin", "before-end")
              ), 
              h4("Shapefile of Japanese Prefectures: e-Stat, Portal Site of Official Statistics of Japan"),
              p(
                "URL: ",
                a(
                  href = "https://www.e-stat.go.jp/",
                  "https://www.e-stat.go.jp/",
                  .noWS = "outside"
                ),
                .noWS = c("after-begin", "before-end")
              ),
              #------------------------------------------------------------------
              h3(style = "border-bottom: solid 1px black;", span(icon("book"), "Reference")),
              p(
                "Kondo, Keisuke (2023) Measuring the Attractiveness of Trip Destinations: A Study of the Kansai Region of Japan, RIEB Discussion Paper Series No.2023-07"
              ),
              p(
                "URL: ",
                a(
                  href = "https://www.rieb.kobe-u.ac.jp/academic/ra/dp/English/dp2023-07.html",
                  "https://www.rieb.kobe-u.ac.jp/academic/ra/dp/English/dp2023-07.html",
                  .noWS = "outside"
                ),
                .noWS = c("after-begin", "before-end")
              ),
              #------------------------------------------------------------------
              br(),
              p(
                "Updated Date: January 1, 2024", br(), 
                "Updated Date: July 2, 2023", br(), 
                "Release Date: March 31, 2023"
              )
              #------------------------------------------------------------------
            )
          )
        )
      )
    )
  )
)
