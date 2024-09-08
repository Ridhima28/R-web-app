#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(shinythemes)

fluidPage(
  tags$head(
    tags$style(HTML("
      hr {
        border-top: 1px solid; /* Adjust the border color and style as needed */
      }
                    .wrapping {
          display: flex;
          flex-wrap: wrap;
        }
        .wrapping > div {
          flex: 1 0 33%; /* Adjust the width as needed */
        }"))
  ),
  theme = shinytheme("superhero"),
  titlePanel("Census Project - STAT 331"),
  sidebarLayout(
    sidebarPanel(
      h2("Graphs To View"),
      checkboxGroupInput(
        "races",
        checkboxInput("use_race", HTML('<h3 
                    style="display: inline;">
                   Race
                   </h3>'), value = TRUE),
        choices = list(
          "White" = "B02001_002",
          "Black" = "B02001_003",
          "Asian" = "B02001_005",
          "American Indian/Alaskan Native" = "B02001_004",
          "Pacific Islander" = "B02001_006",
          "Multiple" = "B02001_008",
          "Other" = "B02001_007"
        )
      ),
      checkboxGroupInput("income", checkboxInput("use_income", HTML('<h3 
                    style="display: inline;">
                   Income
                   </h3>'), value = FALSE),
        choices = list(
          "Less than 10000" = "B19001_002",
          "10000 - 14999" = "B19001_003",
          "15000 - 19999" = "B19001_004",
          "20000 - 24999" = "B19001_005",
          "25000 - 29999" = "B19001_006",
          "30000 - 34999" = "B19001_007",
          "35000 - 44999" = "B19001_008",
          "40000 - 44999" = "B19001_009",
          "45000 - 49999" = "B19001_010",
          "50000 - 59999" = "B19001_011",
          "60000 - 74999" = "B19001_012",
          "75000 - 99999" = "B19001_013",
          "100000 - 124999" = "B19001_014",
          "125000 - 149999" = "B19001_015",
          "150000 - 199999" = "B19001_016",
          "More than 200000" = "B19001_017"
        )
      ),
      checkboxGroupInput(
        "sex",
        checkboxInput("use_sex", HTML('<h3 
                    style="display: inline;">
                   Sex
                   </h3>'), value = FALSE),
        choices = list(
          "Male" = "B01001_002",
          "Female" = "B01001_026"
        )
      ),
      checkboxGroupInput("age", checkboxInput("use_age", HTML('<h3 
                    style="display: inline;">
                   Ages
                   </h3>'), value = FALSE),
        choices = list(
          "Male Under 5" = "B01001_003",
          "Male 5 to 9" = "B01001_004",
          "Male 10 to 14" = "B01001_005",
          "Male 15 to 17" = "B01001_006",
          "Male 18 to 19" = "B01001_007",
          "Male 20" = "B01001_008",
          "Male 21" = "B01001_009",
          "Male 22 to 24" = "B01001_010",
          "Male 25 to 29" = "B01001_011",
          "Male 30 to 34" = "B01001_012",
          "Male 35 to 39" = "B01001_013",
          "Male 40 to 44" = "B01001_014",
          "Male 45 to 49" = "B01001_015",
          "Male 50 to 54" = "B01001_016",
          "Male 55 to 59" = "B01001_017",
          "Male 60 to 61" = "B01001_018",
          "Male 62 to 64" = "B01001_019",
          "Male 65 to 66" = "B01001_020",
          "Male 67 to 69" = "B01001_021",
          "Male 70 to 74" = "B01001_022",
          "Male 75 to 79" = "B01001_023",
          "Male 80 to 84" = "B01001_024",
          "Male Over 85" = "B01001_025",
          "Female Under 5" = "B01001_027",
          "Female 5 to 9" = "B01001_028",
          "Female 10 to 14" = "B01001_029",
          "Female 15 to 17" = "B01001_030",
          "Female 18 to 19" = "B01001_031",
          "Female 20" = "B01001_032",
          "Female 21" = "B01001_033",
          "Female 22 to 24" = "B01001_034",
          "Female 25 to 29" = "B01001_035",
          "Female 30 to 34" = "B01001_036",
          "Female 35 to 39" = "B01001_037",
          "Female 40 to 44" = "B01001_038",
          "Female 45 to 49" = "B01001_039",
          "Female 50 to 54" = "B01001_040",
          "Female 55 to 59" = "B01001_041",
          "Female 60 to 61" = "B01001_042",
          "Female 62 to 64" = "B01001_043",
          "Female 65 to 66" = "B01001_044",
          "Female 67 to 69" = "B01001_045",
          "Female 70 to 74" = "B01001_046",
          "Female 75 to 79" = "B01001_047",
          "Female 80 to 84" = "B01001_048",
          "Female Over 85" = "B01001_049"
        )
      ),
      checkboxGroupInput(
        "household",
        checkboxInput("use_household", HTML('<h3 
                    style="display: inline;">
                   Household Size
                   </h3>'), value = FALSE),
        choices = list(
          "Two Person" = "B11016_003",
          "Three Person" = "B11016_004",
          "Four Person" = "B11016_005",
          "Five Person" = "B11016_006",
          "Six Person" = "B11016_007",
          "Seven Or More Person" = "B11016_008",
          "One Person" = "B11016_010",
          "Non Family Two Person" = "B11016_011",
          "Non Family Three Person" = "B11016_012",
          "Non Family Four Person" = "B11016_013",
          "Non Family Five Person" = "B11016_014",
          "Non Family Six Person" = "B11016_015",
          "Non Family Seven Or More Person" = "B11016_016"
        )
      ),
      width = 2
    ),
    mainPanel(
      h2("Locations To Compare"),
      hr(),
      fluidRow(
        column(
          4,
          h3("Location One"),
          fluidRow(
            div(
              class = "wrapping",
              column(6, selectInput("loc_1_places", h4("Location"), choices = NULL))
            ),
            div(
              class = "wrapping",
              column(6, selectInput(
                "loc_1_state",
                h4("State/Territory"),
                choices = list(
                  "ALABAMA" = "01",
                  "ALASKA" = "02",
                  "ARIZONA" = "04",
                  "ARKANSAS" = "05",
                  "CALIFORNIA" = "06",
                  "COLORADO" = "08",
                  "CONNECTICUT" = "09",
                  "DELAWARE" = "10",
                  "DISTRICT OF COLUMBIA" = "11",
                  "FLORIDA" = "12",
                  "GEORGIA" = "13",
                  "HAWAII" = "15",
                  "IDAHO" = "16",
                  "ILLINOIS" = "17",
                  "INDIANA" = "18",
                  "IOWA" = "19",
                  "KANSAS" = "20",
                  "KENTUCKY" = "21",
                  "LOUISIANA" = "22",
                  "MAINE" = "23",
                  "MARYLAND" = "24",
                  "MASSACHUSETTS" = "25",
                  "MICHIGAN" = "26",
                  "MINNESOTA" = "27",
                  "MISSISSIPPI" = "28",
                  "MISSOURI" = "29",
                  "MONTANA" = "30",
                  "NEBRASKA" = "31",
                  "NEVADA" = "32",
                  "NEW HAMPSHIRE" = "33",
                  "NEW JERSEY" = "34",
                  "NEW MEXICO" = "35",
                  "NEW YORK" = "36",
                  "NORTH CAROLINA" = "37",
                  "NORTH DAKOTA" = "38",
                  "OHIO" = "39",
                  "OKLAHOMA" = "40",
                  "OREGON" = "41",
                  "PENNSYLVANIA" = "42",
                  "RHODE ISLAND" = "44",
                  "SOUTH CAROLINA" = "45",
                  "SOUTH DAKOTA" = "46",
                  "TENNESSEE" = "47",
                  "TEXAS" = "48",
                  "UTAH" = "49",
                  "VERMONT" = "50",
                  "VIRGINIA" = "51",
                  "WASHINGTON" = "53",
                  "WEST VIRGINIA" = "54",
                  "WISCONSIN" = "55",
                  "WYOMING" = "56",
                  "PUERTO RICO" = "72"
                )
              ))
            )
          )
        ),
        column(
          4,
          checkboxInput("loc_2", HTML('<h3 
                    style="display: inline;">
                   Location Two
                   </h3>'), value = FALSE),
          fluidRow(
            div(
              class = "wrapping",
              column(6, selectInput("loc_2_places", h4("Location"), choices = NULL))
            ),
            div(
              class = "wrapping",
              column(6, selectInput(
                "loc_2_state",
                h4("State/Territory"),
                choices = list(
                  "ALABAMA" = "01",
                  "ALASKA" = "02",
                  "ARIZONA" = "04",
                  "ARKANSAS" = "05",
                  "CALIFORNIA" = "06",
                  "COLORADO" = "08",
                  "CONNECTICUT" = "09",
                  "DELAWARE" = "10",
                  "DISTRICT OF COLUMBIA" = "11",
                  "FLORIDA" = "12",
                  "GEORGIA" = "13",
                  "HAWAII" = "15",
                  "IDAHO" = "16",
                  "ILLINOIS" = "17",
                  "INDIANA" = "18",
                  "IOWA" = "19",
                  "KANSAS" = "20",
                  "KENTUCKY" = "21",
                  "LOUISIANA" = "22",
                  "MAINE" = "23",
                  "MARYLAND" = "24",
                  "MASSACHUSETTS" = "25",
                  "MICHIGAN" = "26",
                  "MINNESOTA" = "27",
                  "MISSISSIPPI" = "28",
                  "MISSOURI" = "29",
                  "MONTANA" = "30",
                  "NEBRASKA" = "31",
                  "NEVADA" = "32",
                  "NEW HAMPSHIRE" = "33",
                  "NEW JERSEY" = "34",
                  "NEW MEXICO" = "35",
                  "NEW YORK" = "36",
                  "NORTH CAROLINA" = "37",
                  "NORTH DAKOTA" = "38",
                  "OHIO" = "39",
                  "OKLAHOMA" = "40",
                  "OREGON" = "41",
                  "PENNSYLVANIA" = "42",
                  "RHODE ISLAND" = "44",
                  "SOUTH CAROLINA" = "45",
                  "SOUTH DAKOTA" = "46",
                  "TENNESSEE" = "47",
                  "TEXAS" = "48",
                  "UTAH" = "49",
                  "VERMONT" = "50",
                  "VIRGINIA" = "51",
                  "WASHINGTON" = "53",
                  "WEST VIRGINIA" = "54",
                  "WISCONSIN" = "55",
                  "WYOMING" = "56",
                  "PUERTO RICO" = "72"
                )
              ))
            )
          )
        ),
        column(
          4,
          checkboxInput("loc_3", HTML('<h3 
                    style="display: inline;">
                   Location Three
                   </h3>'), value = FALSE),
          fluidRow(
            div(
              class = "wrapping",
              column(6, selectInput("loc_3_places", h4("Location"), choices = NULL))
            ),
            div(
              class = "wrapping",
              column(6, selectInput(
                "loc_3_state",
                h4("State/Territory"),
                choices = list(
                  "ALABAMA" = "01",
                  "ALASKA" = "02",
                  "ARIZONA" = "04",
                  "ARKANSAS" = "05",
                  "CALIFORNIA" = "06",
                  "COLORADO" = "08",
                  "CONNECTICUT" = "09",
                  "DELAWARE" = "10",
                  "DISTRICT OF COLUMBIA" = "11",
                  "FLORIDA" = "12",
                  "GEORGIA" = "13",
                  "HAWAII" = "15",
                  "IDAHO" = "16",
                  "ILLINOIS" = "17",
                  "INDIANA" = "18",
                  "IOWA" = "19",
                  "KANSAS" = "20",
                  "KENTUCKY" = "21",
                  "LOUISIANA" = "22",
                  "MAINE" = "23",
                  "MARYLAND" = "24",
                  "MASSACHUSETTS" = "25",
                  "MICHIGAN" = "26",
                  "MINNESOTA" = "27",
                  "MISSISSIPPI" = "28",
                  "MISSOURI" = "29",
                  "MONTANA" = "30",
                  "NEBRASKA" = "31",
                  "NEVADA" = "32",
                  "NEW HAMPSHIRE" = "33",
                  "NEW JERSEY" = "34",
                  "NEW MEXICO" = "35",
                  "NEW YORK" = "36",
                  "NORTH CAROLINA" = "37",
                  "NORTH DAKOTA" = "38",
                  "OHIO" = "39",
                  "OKLAHOMA" = "40",
                  "OREGON" = "41",
                  "PENNSYLVANIA" = "42",
                  "RHODE ISLAND" = "44",
                  "SOUTH CAROLINA" = "45",
                  "SOUTH DAKOTA" = "46",
                  "TENNESSEE" = "47",
                  "TEXAS" = "48",
                  "UTAH" = "49",
                  "VERMONT" = "50",
                  "VIRGINIA" = "51",
                  "WASHINGTON" = "53",
                  "WEST VIRGINIA" = "54",
                  "WISCONSIN" = "55",
                  "WYOMING" = "56",
                  "PUERTO RICO" = "72"
                )
              ))
            )
          )
        )
      ),
      hr(),
      plotOutput("resultMainPlot"),
      width = 10
    )
  )
)
