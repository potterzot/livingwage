#' convert BLS json data to a data frame.
#'
#' @export
#'
#' @param dat the json data from a call to \code{blsAPI}.
#' @return a data.frame.
bls_df <- function(dat) {
  df <- data.frame(year=character(),
                   period=character(),
                   periodName=character(),
                   value=character(),
                   stringsAsFactors=FALSE)

  i <- 0
  for(d in dat){
    i <- i + 1
    df[i,] <- unlist(d)
  }
  df
}

#' Get BLS data and return as a data frame.
get_bls <- function(series, opts, name = "value", version = 2) {
  seriesid <- list('seriesid' = unlist(series, use.names = FALSE))
  payload <- c(seriesid, opts)

  response <- blsAPI(payload, version)
  json <- fromJSON(response)
  if (json$status != "REQUEST_SUCCEEDED") stop(paste0("Error: ", response))
  dat <- json$Results$series
  new <- TRUE
  for (i in 1:length(dat)) {
    s <- dat[[i]]
    df <- bls_df(s$data)
    if (nrow(df) > 0) {
      names(df)[4] <- name
      df$series <- names(series)[i]
      df[,name] <- as.numeric(df[,name])
      if (new) {
        new <- FALSE
        res <- df
      }
      else res <- rbind(res, df)
    }
    else {
      warning(paste0("No data for series: ", names(series)[i]))
    }
  }
  res
}



#' @param seasonal_adj whether the data should be seasonally adjusted or not.
#' @param area the area code, see \href{http://www.bls.gov/cew/doc/titles/area/area_titles.htm}.
#' @param data_type
#' @return a data.table.
get_qcew <- function(
  seasonally_adj = c("U", "S"),
  area,
  data_type,
  size,
  ownership,
  industry,
  startyear,
  endyear) {

  series <- paste0("EN", seasonally_adj, area, data_type,
                   size, ownership, industry)
  payload <- payload <- list(
    'seriesid'=c(series),
    'startyear'=2007,
    'endyear'=2009)

  response <- blsAPI::blsAPI(series, 2)
  json <- rjson::fromJSON(response)
  bls_df(json$Results$series[[1]]$data)
}

