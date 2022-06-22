## Set seed for reproducible results
set.seed(321)
source("R/forecast_functions.R")

## Load in catalog
catalog <- read.csv("../input/ISIDE_catalog_raw_PyCSEP",  col_names = c("lon", "lat", "M", "time_string", "depth", "catalog_id", "event_id"), skip = 1)

## R script should accept date from command line
## We do this here with commandArgs (see https://www.r-bloggers.com/2015/09/passing-arguments-to-an-r-script-from-command-lines/)
args = commandArgs(trailingOnly=TRUE)

## test if there is a date supplied: if not, return an error
if (length(args)==0) {
  stop("Date must be supplied to generate forecast", call.=FALSE)
}

## args is a string, convert to a date
## I use as.POSIXct for datetimes, but other options are available!
forecast_date = as.POSIXct(args[1])

## generate mock forecasts
forecast_dataframe <- mock_daily_forecast(catalog, forecast_date, 10)

## write to a file
write_forecast(forecast_date, forecast_dataframe, "forecasts/")
