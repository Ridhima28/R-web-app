#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

api_key <- "b27a9847a9dde0fb751cb95e6bc8ad37ca6e1293"
library(tidycensus)
library(ggplot2)
library(terra)
library(r2r)
library(here)
library(tidyverse)
library(ggthemes)

census_api_key(api_key, install = TRUE, overwrite = TRUE)
readRenviron("~/.Renviron")

# Pulled from https://www.census.gov/geographies/reference-files/2020/demo/popest/2020-fips.html

fips_codes_df <- readxl::read_xlsx(here::here("final-project", "all-geocodes-v2020.xlsx"), skip = 3) |> mutate(across(-last_col(), as.numeric))

state_names_df <- fips_codes_df |>
  filter(`Summary Level` == 40) |>
  mutate(`State` = `Area Name (including legal/statistical area description)`) |>
  select(`State Code (FIPS)`, `State`)

fips_codes_cleaned_df <- fips_codes_df |>
  filter(`Summary Level` == 50) |>
  mutate(`County` = `Area Name (including legal/statistical area description)`) |>
  select(!(`Consolidtated City Code (FIPS)`:`Area Name (including legal/statistical area description)`))

fips_codes_cleaned_df <- left_join(state_names_df, fips_codes_cleaned_df) |> mutate(`State Code (FIPS)` = sprintf("%02d", `State Code (FIPS)`), `County Code (FIPS)` = sprintf("%03d", `County Code (FIPS)`))

race_vars1 <- c(
  White = "B02001_002E",
  Black = "B02001_003E",
  Asian = "B02001_005E",
  AI_AN = "B02001_004E", ## American Indian and Alaska Native
  NH_PI = "B02001_006E", ## Native Hawaiian and Other Pacific Islander
  some_Other = "B02001_007E", ## Other
  Two_or_more = "B02001_008E" ## Two or more
)

income_var <- c(
  less_10000 = "B19001_002E",
  between_10000_14999 = "B19001_003E",
  between_15000_19999 = "B19001_004E",
  between_20000_24999 = "B19001_005E",
  between_25000_29999 = "B19001_006E",
  between_30000_34999 = "B19001_007E",
  between_35000_44999 = "B19001_008E",
  between_40000_44999 = "B19001_009E",
  between_45000_49999 = "B19001_010E",
  between_50000_59999 = "B19001_011E",
  between_60000_74999 = "B19001_012E",
  between_75000_99999 = "B19001_013E",
  between_100000_124999 = "B19001_014E",
  between_125000_149999 = "B19001_015E",
  between_150000_199999 = "B19001_016E",
  more_200000 = "B19001_017E"
)

sex_var <- c(
  total_male = "B01001_002E",
  total_female = "B01001_026E"
)

age_var <- c(
  male_under_5 = "B01001_003E",
  male_5to9 = "B01001_004E",
  male_10to14 = "B01001_005E",
  male_15to17 = "B01001_006E",
  male_18to19 = "B01001_007E",
  male_20 = "B01001_008E",
  male_21 = "B01001_009E",
  male_22to24 = "B01001_010E",
  male_25to29 = "B01001_011E",
  male_30to34 = "B01001_012E",
  male_35to39 = "B01001_013E",
  male_40to44 = "B01001_014E",
  male_45to49 = "B01001_015E",
  male_50to54 = "B01001_016E",
  male_55to59 = "B01001_017E",
  male_60to61 = "B01001_018E",
  male_62to64 = "B01001_019E",
  male_65to66 = "B01001_020E",
  male_67to69 = "B01001_021E",
  male_70to74 = "B01001_022E",
  male_75to79 = "B01001_023E",
  male_80to84 = "B01001_024E",
  male_over_85 = "B01001_025E",
  female_under_5 = "B01001_027E",
  female_5to9 = "B01001_028E",
  female_10to14 = "B01001_029E",
  female_15to17 = "B01001_030E",
  female_18to19 = "B01001_031E",
  female_20 = "B01001_032E",
  female_21 = "B01001_033E",
  female_22to24 = "B01001_034E",
  female_25to29 = "B01001_035E",
  female_30to34 = "B01001_036E",
  female_35to39 = "B01001_037E",
  female_40to44 = "B01001_038E",
  female_45to49 = "B01001_039E",
  female_50to54 = "B01001_040E",
  female_55to59 = "B01001_041E",
  female_60to61 = "B01001_042E",
  female_62to64 = "B01001_043E",
  female_65to66 = "B01001_044E",
  female_67to69 = "B01001_045E",
  female_70to74 = "B01001_046E",
  female_75to79 = "B01001_047E",
  female_80to84 = "B01001_048E",
  female_over_85 = "B01001_049E"
)

household_var <- c(
  two_person = "B11016_003E",
  three_person = "B11016_004E",
  four_person = "B11016_005E",
  five_person = "B11016_006E",
  six_person = "B11016_007E",
  seven_or_more_person = "B11016_008E",
  one_person = "B11016_010E",
  non_family_two_person = "B11016_011E",
  non_family_three_person = "B11016_012E",
  non_family_four_person = "B11016_013E",
  non_family_five_person = "B11016_014E",
  non_family_six_person = "B11016_015E",
  non_family_seven_or_more_person = "B11016_016E"
)

lookup_codes_df <- data.frame(
  variable_code = c(
    "B11016_003", "B11016_004", "B11016_005", "B11016_006", "B11016_007", "B11016_008", "B11016_010",
    "B11016_011", "B11016_012", "B11016_013", "B11016_014", "B11016_015", "B11016_016", "B02001_002",
    "B02001_003", "B02001_005", "B02001_004", "B02001_006", "B02001_007", "B02001_008", "B19001_002",
    "B19001_003", "B19001_004", "B19001_005", "B19001_006", "B19001_007", "B19001_008", "B19001_009",
    "B19001_010", "B19001_011", "B19001_012", "B19001_013", "B19001_014", "B19001_015", "B19001_016",
    "B19001_017", "B01001_002", "B01001_026", "B01001_003", "B01001_004", "B01001_005", "B01001_006",
    "B01001_007", "B01001_008", "B01001_009", "B01001_010", "B01001_011", "B01001_012", "B01001_013",
    "B01001_014", "B01001_015", "B01001_016", "B01001_017", "B01001_018", "B01001_019", "B01001_020",
    "B01001_021", "B01001_022", "B01001_023", "B01001_024", "B01001_025", "B01001_027", "B01001_028",
    "B01001_029", "B01001_030", "B01001_031", "B01001_032", "B01001_033", "B01001_034", "B01001_035",
    "B01001_036", "B01001_037", "B01001_038", "B01001_039", "B01001_040", "B01001_041", "B01001_042",
    "B01001_043", "B01001_044", "B01001_045", "B01001_046", "B01001_047", "B01001_048", "B01001_049"
  ),
  variable_name = c(
    "Two-person households", "Three-person households", "Four-person households", "Five-person households",
    "Six-person households", "Seven or more person households", "One-person households",
    "Non-family two-person households", "Non-family three-person households", "Non-family four-person households",
    "Non-family five-person households", "Non-family six-person households", "Non-family seven or more person households",
    "White", "Black", "Asian", "American Indian and Alaska Native (AI_AN)", "Native Hawaiian and Other Pacific Islander (NH_PI)",
    "Some other race", "Two or more races", "Less than $10,000", "$10,000 to $14,999", "$15,000 to $19,999",
    "$20,000 to $24,999", "$25,000 to $29,999", "$30,000 to $34,999", "$35,000 to $39,999", "$40,000 to $44,999",
    "$45,000 to $49,999", "$50,000 to $59,999", "$60,000 to $74,999", "$75,000 to $99,999", "$100,000 to $124,999",
    "$125,000 to $149,999", "$150,000 to $199,999", "More than $200,000", "Total male", "Total female", "Males under 5 years",
    "Males 5 to 9 years", "Males 10 to 14 years", "Males 15 to 17 years", "Males 18 to 19 years", "Males 20 years",
    "Males 21 years", "Males 22 to 24 years", "Males 25 to 29 years", "Males 30 to 34 years", "Males 35 to 39 years",
    "Males 40 to 44 years", "Males 45 to 49 years", "Males 50 to 54 years", "Males 55 to 59 years", "Males 60 to 61 years",
    "Males 62 to 64 years", "Males 65 to 66 years", "Males 67 to 69 years", "Males 70 to 74 years", "Males 75 to 79 years",
    "Males 80 to 84 years", "Males over 85 years", "Females under 5 years", "Females 5 to 9 years", "Females 10 to 14 years",
    "Females 15 to 17 years", "Females 18 to 19 years", "Females 20 years", "Females 21 years", "Females 22 to 24 years",
    "Females 25 to 29 years", "Females 30 to 34 years", "Females 35 to 39 years", "Females 40 to 44 years", "Females 45 to 49 years",
    "Females 50 to 54 years", "Females 55 to 59 years", "Females 60 to 61 years", "Females 62 to 64 years", "Females 65 to 66 years",
    "Females 67 to 69 years", "Females 70 to 74 years", "Females 75 to 79 years", "Females 80 to 84 years", "Females over 85 years"
  ),
  category = c(
    "Household", "Household", "Household", "Household", "Household", "Household", "Household", "Household", "Household",
    "Household", "Household", "Household", "Household", "Race", "Race", "Race", "Race", "Race", "Race", "Race", "Income",
    "Income", "Income", "Income", "Income", "Income", "Income", "Income", "Income", "Income", "Income", "Income", "Income",
    "Income", "Income", "Income", "Sex", "Sex", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age",
    "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age",
    "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age", "Age",
    "Age"
  )
)


loc_1_filtered <- fips_codes_cleaned_df
loc_2_filtered <- fips_codes_cleaned_df
loc_3_filtered <- fips_codes_cleaned_df

function(input, output, session) {
  location_dfs <- reactiveValues(
    loc_1_result_df = NULL,
    loc_2_result_df = NULL,
    loc_3_result_df = NULL
  )

  variables <- reactiveValues(active = character(0))

  observeEvent(input$use_race, {
    if (input$use_race) {
      variables$active <- c(variables$active, "Race")
    } else {
      variables$active <- variables$active[variables$active != "Race"]
    }
  })

  observeEvent(input$use_income, {
    if (input$use_income) {
      variables$active <- c(variables$active, "Income")
    } else {
      variables$active <- variables$active[variables$active != "Income"]
    }
  })

  observeEvent(input$use_sex, {
    if (input$use_sex) {
      variables$active <- c(variables$active, "Sex")
    } else {
      variables$active <- variables$active[variables$active != "Sex"]
    }
  })

  observeEvent(input$use_household, {
    if (input$use_household) {
      variables$active <- c(variables$active, "Household")
    } else {
      variables$active <- variables$active[variables$active != "Household"]
    }
  })

  observeEvent(input$use_age, {
    if (input$use_age) {
      variables$active <- c(variables$active, "Age")
    } else {
      variables$active <- variables$active[variables$active != "Age"]
    }
  })

  locations <- reactiveValues(active = c("loc_1"))

  observeEvent(input$loc_2, {
    if (input$loc_2) {
      locations$active <- c(locations$active, "loc_2")
    } else {
      locations$active <- locations$active[locations$active != "loc_2"]
    }
  })

  observeEvent(input$loc_3, {
    if (input$loc_3) {
      locations$active <- c(locations$active, "loc_3")
    } else {
      locations$active <- locations$active[locations$active != "loc_3"]
    }
  })

  observeEvent(input$loc_1_state, {
    loc_1_filtered <- fips_codes_cleaned_df |> filter(fips_codes_cleaned_df$`State Code (FIPS)` == input$loc_1_state)
    updateSelectInput(session, "loc_1_places", choices = c("", unique(loc_1_filtered[grepl("\\bcounty$", tolower(loc_1_filtered$`County`)), ]$`County`)))
  })

  observeEvent(input$loc_2_state, {
    loc_2_filtered <- fips_codes_cleaned_df |> filter(fips_codes_cleaned_df$`State Code (FIPS)` == input$loc_2_state)
    updateSelectInput(session, "loc_2_places", choices = c("", unique(loc_2_filtered[grepl("\\bcounty$", tolower(loc_2_filtered$`County`)), ]$`County`)))
  })

  observeEvent(input$loc_3_state, {
    loc_3_filtered <- fips_codes_cleaned_df |> filter(fips_codes_cleaned_df$`State Code (FIPS)` == input$loc_3_state)
    updateSelectInput(session, "loc_3_places", choices = c("", unique(loc_3_filtered[grepl("\\bcounty$", tolower(loc_3_filtered$`County`)), ]$`County`)))
  })

  observeEvent(input$loc_1_places, {
    if (input$loc_1_places != "") {
      location_dfs$loc_1_result_df <- get_data(input, input$loc_1_state, input$loc_1_places)
    }
  })

  observeEvent(input$loc_2_places, {
    if (input$loc_2_places != "") {
      location_dfs$loc_2_result_df <- get_data(input, input$loc_2_state, input$loc_2_places)
    }
  })

  observeEvent(input$loc_3_places, {
    if (input$loc_3_places != "") {
      location_dfs$loc_3_result_df <- get_data(input, input$loc_3_state, input$loc_3_places)
    }
  })

  output$loc_output <- renderText({
    paste("List items:", paste(variables$active, collapse = ", "))
  })


  output$resultMainPlot <- renderPlot(
    {
      mutated <- mutate_data(location_dfs, input)
      joined <- join_data(mutated, input)
      if (!is.null(joined)) {
        joined <- joined |> filter(var_type %in% variables$active)
        if (!is.null(input$races) & input$use_race) {
          joined <- joined |> filter(joined$variable %in% input$races | joined$var_type != "Race")
        }
        if (!is.null(input$household) & input$use_household) {
          joined <- joined |> filter(joined$variable %in% input$household | joined$var_type != "Household")
        }
        if (!is.null(input$income) & input$use_income) {
          joined <- joined |> filter(joined$variable %in% input$income | joined$var_type != "Income")
        }
        if (!is.null(input$age) & input$use_age) {
          joined <- joined |> filter(joined$variable %in% input$age | joined$var_type != "Age")
        }
        if (!is.null(input$sex) & input$use_sex) {
          joined <- joined |> filter(joined$variable %in% input$sex | joined$var_type != "Sex")
        }
        joined <- left_join(joined, lookup_codes_df, by = c("variable" = "variable_code"))
        joined <- joined |> mutate(variable_name = fct_reorder(variable_name, estimate))
        plot_title <- str_c("Population By Group Of ", str_c(unique(joined$NAME), collapse = " V.S. "))
        ggplot(joined, aes(x = estimate, y = variable_name, fill = NAME)) +
          geom_bar(stat = "identity", position = position_dodge(width = 1)) +
          facet_wrap(~var_type, scales = "free", ncol = 2) +
          theme_clean() +
          labs(x = "Population Estimate", y = "", subtitle = "Identify As", fill = "Location", title = str_wrap(plot_title, width = 100)) +
          theme(axis.text.y = element_text(hjust = 1, face = "bold", size = 12), plot.margin = margin(t = 0, r = 0, b = 2, l = 0, unit = "lines"), strip.text.x = element_text(size = 18, face = "bold"), plot.title = element_text(face = "bold", size = 32), plot.subtitle = element_text(face = "bold", size = 16)) +
          geom_text(aes(label = format(estimate, big.mark = ",")), hjust = -0.1, position = position_dodge(width = 0.9)) +
          scale_fill_discrete(labels = function(x) str_wrap(x, width = 10))
      }
    },
    height = 2600
  )

  get_data <- function(input, state, location) {
    return(get_acs(
      geography = "county",
      state = state,
      county = location,
      variables = c(race_vars1, income_var, sex_var, household_var, age_var),
      year = 2020
    ))
  }

  mutate_data <- function(frames, input) {
    var_start_codes <- c("B02001" = "Race", "B19001" = "Income", "B01001" = "Age", "B11016" = "Household", "Sex" = "Sex")
    if (!is.null(frames$loc_1_result_df)) {
      loc_1 <- frames$loc_1_result_df
      frames$loc_1_result_df <- loc_1 |> mutate(var_type = var_start_codes[ifelse(variable == "B01001_002" | variable == "B01001_026", "Sex", (str_split(variable, "_") |> sapply(`[[`, 1)))])
    }
    if (!is.null(frames$loc_2_result_df)) {
      loc_2 <- frames$loc_2_result_df
      frames$loc_2_result_df <- loc_2 |> mutate(var_type = var_start_codes[ifelse(variable == "B01001_002" | variable == "B01001_026", "Sex", (str_split(variable, "_") |> sapply(`[[`, 1)))])
    }
    if (!is.null(frames$loc_3_result_df)) {
      loc_3 <- frames$loc_3_result_df
      frames$loc_3_result_df <- loc_3 |> mutate(var_type = var_start_codes[ifelse(variable == "B01001_002" | variable == "B01001_026", "Sex", (str_split(variable, "_") |> sapply(`[[`, 1)))])
    }
    return(frames)
  }

  join_data <- function(frames, input) {
    joined_frame <- frames$loc_1_result_df
    if (!is.null(frames$loc_1_result_df) & !is.null(frames$loc_2_result_df) & is.null(frames$loc_3_result_df)) {
      joined_frame <- rbind(frames$loc_1_result_df, frames$loc_2_result_df)
    } else if (!is.null(frames$loc_1_result_df) & is.null(frames$loc_2_result_df) & !is.null(frames$loc_3_result_df)) {
      joined_frame <- rbind(frames$loc_1_result_df, frames$loc_3_result_df)
    } else if (!is.null(frames$loc_1_result_df) & !is.null(frames$loc_2_result_df) & !is.null(frames$loc_3_result_df)) {
      joined_frame <- rbind(frames$loc_1_result_df, frames$loc_2_result_df)
      joined_frame <- rbind(joined_frame, frames$loc_3_result_df)
    }
    return(joined_frame)
  }
}
