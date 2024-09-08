Web App Description:

This Shiny application provides a user-friendly interface to explore U.S. census data by state and city. The app utilizes FIPS codes to allow users to filter data on various demographic factors such as race, sex, income, and household size. Users can select specific categories and locations using checkboxes to visualize and compare data between different regions.

Features:
Location Selection: Populated using FIPS codes from an integrated Excel file, users can select states and cities to view their census data. This might take a moment as the data is loaded from a large file.
Category Filtering: Easily explore different demographic categories like race, gender, income, and more by using checkboxes to activate or deactivate groups for analysis.
Multi-Location Comparison: Add and compare data for up to three locations simultaneously.

***important note***
Ui.R and Server.R run the shiny application. The excel file contains all the FIPS codes needed. *Please be aware it takes a moment to populate the select boxes for the location as it needs to read through the excel file*

