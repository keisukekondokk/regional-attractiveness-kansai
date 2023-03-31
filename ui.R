# 
# (C) Keisuke Kondo
# Release Date: 2023-03-31
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
    title = "地域魅力度指数",
    titleWidth = 300,
    tags$li(
      actionLink(
        "github",
        label = "",
        icon = icon("github"),
        href = "https://github.com/keisukekondokk/person-trip-kansai",
        onclick = "window.open('https://github.com/keisukekondokk/person-trip-kansai', '_blank')"
      ),
      class = "dropdown"
    )
  ),
  #++++++++++++++++++++++++++++++++++++++
  #SideBar
  dashboardSidebar(width = 300,
                   sidebarMenu(
                     menuItem("地域魅力度指数（合計トリップ）",
                              tabName = "tab_map1",
                              icon = icon("map")),
                     menuItem("地域魅力度指数（出勤トリップ）",
                              tabName = "tab_map2",
                              icon = icon("map")),
                     menuItem("地域魅力度指数（登校トリップ）",
                              tabName = "tab_map3",
                              icon = icon("map")),
                     menuItem("地域魅力度指数（自由トリップ）",
                              tabName = "tab_map4",
                              icon = icon("map")),
                     menuItem("地域魅力度指数（業務トリップ）",
                              tabName = "tab_map5",
                              icon = icon("map")),
                     menuItem("地域魅力度指数（帰宅トリップ）",
                              tabName = "tab_map6",
                              icon = icon("map")),
                     menuItem("地域魅力度指数（不明トリップ）",
                              tabName = "tab_map7",
                              icon = icon("map")),
                     menuItem("はじめに",
                              tabName = "info",
                              icon = icon("info-circle"))
                   )),
  #++++++++++++++++++++++++++++++++++++++
  #Body
  dashboardBody(
    tags$style(type = "text/css", "html, body {margin: 0; width: 100%; height: 100%}"),
    tags$style(type = "text/css", "h2 {margin-top: 30px}"),
    tags$style(type = "text/css", "h3, h4 {margin-top: 20px}"),
    tags$style(
      type = "text/css",
      "#map1, #map2, #map3, #map4, #map5, #map6, #map7 {margin: 0; height: calc(100vh - 50px) !important;}"
    ),
    #++++++++++++++++++++++++++++++++++++++
    #Tab
    tabItems(
      tabItem(
        tabName = "tab_map1",
        fluidRow(
          style = "margin-top: -20px; margin-bottom: -20px;",
          leafletOutput("map1") %>%
            withSpinner(color = getOption("spinner.color", default = "#3C8EBC"))
        )
      ),
      tabItem(
        tabName = "tab_map2",
        fluidRow(
          style = "margin-top: -20px; margin-bottom: -20px;",
          leafletOutput("map2") %>%
            withSpinner(color = getOption("spinner.color", default = "#3C8EBC"))
        )
      ),
      tabItem(
        tabName = "tab_map3",
        fluidRow(
          style = "margin-top: -20px; margin-bottom: -20px;",
          leafletOutput("map3") %>%
            withSpinner(color = getOption("spinner.color", default = "#3C8EBC"))
        )
      ),
      tabItem(
        tabName = "tab_map4",
        fluidRow(
          style = "margin-top: -20px; margin-bottom: -20px;",
          leafletOutput("map4") %>%
            withSpinner(color = getOption("spinner.color", default = "#3C8EBC"))
        )
      ),
      tabItem(
        tabName = "tab_map5",
        fluidRow(
          style = "margin-top: -20px; margin-bottom: -20px;",
          leafletOutput("map5") %>%
            withSpinner(color = getOption("spinner.color", default = "#3C8EBC"))
        )
      ),
      tabItem(
        tabName = "tab_map6",
        fluidRow(
          style = "margin-top: -20px; margin-bottom: -20px;",
          leafletOutput("map6") %>%
            withSpinner(color = getOption("spinner.color", default = "#3C8EBC"))
        )
      ),
      tabItem(
        tabName = "tab_map7",
        fluidRow(
          style = "margin-top: -20px; margin-bottom: -20px;",
          leafletOutput("map7") %>%
            withSpinner(color = getOption("spinner.color", default = "#3C8EBC"))
        )
      ),
      tabItem(
        tabName = "info",
        fluidRow(
          style = "margin-bottom: -20px; margin-left: -30px; margin-right: -30px;",
          column(
            width = 12,
            box(
              width = NULL,
              title = h2(span(icon("info-circle"), "はじめに")),
              solidHeader = TRUE,
              p("2023年3月31日公開", align = "right"),
              #------------------------------------------------------------------
              h3(style = "border-bottom: solid 1px black;", span(icon("pencil-square"), "本サイトの説明")),
              p("Kondo (2023)において提案した人流データから推定する地域魅力度指数を可視化しています。"),
              #------------------------------------------------------------------
              h3(style = "border-bottom: solid 1px black;", span(icon("user-circle"), "作成者")),
              p("近藤恵介"),
              p("独立行政法人経済産業研究所・上席研究員"),
              p("神戸大学経済経営研究所・准教授"),
              h3(style = "border-bottom: solid 1px black;", span(icon("envelope-open"), "連絡先")),
              p("Email: kondo-keisuke@rieti.go.jp"),
              h3(style = "border-bottom: solid 1px black;", span(icon("file-text"), "利用規約")),
              p(
                "当サイトで公開している情報（以下「コンテンツ」）は、どなたでも自由に利用できます。コンテンツ利用に当たっては、本利用規約に同意したものとみなします。本利用規約の内容は、必要に応じて事前の予告なしに変更されることがありますので、必ず最新の利用規約の内容をご確認ください。"
              ),
              h4("著作権"),
              p("本コンテンツの著作権は、近藤恵介に帰属します。"),
              h4("第三者の権利"),
              p(
                "本コンテンツは、「近畿圏パーソントリップ調査」（京阪神都市圏交通計画協議会）および「国土数値情報」（国土交通省）の情報に基づいて作成しています。本コンテンツを利用する際は、第三者の権利を侵害しないようにしてください。"
              ),
              h4("免責事項"),
              p("(a) 作成にあたり細心の注意を払っていますが、本サイトの内容の完全性・正確性・有用性等についていかなる保証を行うものでありません。"),
              p("(b) 本サイトを利用したことによるすべての障害・損害・不具合等、作成者および作成者の所属するいかなる団体・組織とも、一切の責任を負いません。"),
              p("(c) 本サイトは、事前の予告なく変更、移転、削除等が行われることがあります。"),
              #------------------------------------------------------------------
              h3(style = "border-bottom: solid 1px black;", span(icon("database"), "データ出所")),
              h4("近畿圏パーソントリップ調査（京阪神都市圏交通計画協議会）"),
              p(
                "URL: ",
                a(
                  href = "https://stopcovid19.metro.tokyo.lg.jp/",
                  "https://stopcovid19.metro.tokyo.lg.jp/",
                  .noWS = "outside"
                ),
                .noWS = c("after-begin", "before-end")
              ), 
              h4("国土数値情報（国土数値情報）"),
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
              h3(style = "border-bottom: solid 1px black;", span(icon("database"), "参考文献")),
              p(
                "Kondo, Keisuke (2023) Measuring the Attractiveness of Trip Destinations: A Study of the Kansai Region, RIEB Discussion Paper Series No.2023-07"
              ),
              p(
                "URL: ",
                a(
                  href = "https://www.rieb.kobe-u.ac.jp/academic/ra/dp/English/dp2023-07.html",
                  "https://www.rieb.kobe-u.ac.jp/academic/ra/dp/English/dp2023-07.html",
                  .noWS = "outside"
                ),
                .noWS = c("after-begin", "before-end")
              )
            )
          )
        )
      )
    )
  )
)
