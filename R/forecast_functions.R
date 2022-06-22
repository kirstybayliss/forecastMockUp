
#' Make a mock-up daily forecast by sampling from input catalogue
#' Returns random samples from a catalogue. Assumes required duration is 1 day but can be generalised.
#'
#' @param catalog catalogue to sample events from
#' @param date date for which to generate catalogue
#' @param n_cats number of catalogues to simulate
#'
#' @return r dataframe object containing forecast columns
#' @export

mock_daily_forecast <- function(catalog, date, n_cats ){
  ## Set up list of forecasts
  forecasts <-  list(length=length(n_cats))
  ## Set up catalog we're using
  cat_to_use <- catalog[as.POSIXct(catalog$time_string) < date,]
  ## set up rate
  rate <- nrow(cat_to_use)/abs(as.numeric(difftime(as.POSIXct(cat_to_use$time_string[1]), as.POSIXct(cat_to_use$time_string[nrow(cat_to_use)], tz="UTC"), units="days")))
  for(i in 1:n_cats){
    ## choose number of events for catalogue from poisson with rate = catalogue rate
    num_events_cat <- rpois(1, rate)
    newcat <-  cat_to_use[round(runif(num_events_cat, 1, length(cat_to_use))),]
    ## change the catalog_id to reflect this mock-up:
    ## these events get catalog_id from whatever catalog number we are currently making
    newcat$catalog_id <- i
    forecasts[[i]] <- newcat
  }
  forecast_df = do.call(rbind, forecasts)
  return(forecast_df)
}

#' Write forecast to file
#' Write a forecast to a txt file that will be read by pycsep
#'
#' @param date string with date of forecast (for file naming)
#' @param forecast_df dataframe of forecast data (assumes structure of mock_daily_forecast)
#' @param output_path path of location to save forecast
#' @return Writes forecast to file at specified location
#' @export

write_forecast <- function(date, forecast_df, output_path){
  forecast_name <- paste0(output_path,"/mockup_forecast_", date, ".txt")
  write.table(format(as.data.frame(forecast_df, digits = 6)), forecast_name, quote = FALSE, row.names = FALSE, col.names = FALSE, sep=",")
}

