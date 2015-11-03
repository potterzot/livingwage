#' Authenticate the user
#'
#' the NASS API uses a basic html API key authorization, where the key is included in the
#' html call. You can add your API key in four ways:
#'
#' (1) directly or as a variable from your R program: \code{auth = nassqs_auth(`api_key`)}
#' (2) by setting it in your system environment as 'BLS_API_KEY'.
#' (3) by setting it in your R options as 'bls_api_key' (in your .Rprofile,
#'   for example).
#' (4) by entering it into the console when asked (it will be stored for the
#'   rest of the session.)
#'
#' @param key API key. If not specified, looks for the key as either BLS_API_KEY
#'   environmental variable or bls_api_key in R options. If not available in
#'   either, asks at the console.
#' @return authentication token.
bls_auth <- function(key = bls_token()) {
  key
}

#' Get the user's API key from the environment
#'
#' First checks if bls_api_key is set either as an environmental variable or as
#' an option, and if so, returns it. Otherwise asks the console. If not an
#' interactive session, fails with error message.
#'
#' @export
#'
#' @param force a boolean to force asking in the console.
#' @return the api key.
#'
bls_token <- function(force = FALSE) {
  env <- Sys.getenv('BLS_API_KEY')
  if (identical(env, "")) env <- options('bls_api_key')
  if (!identical(env, "") && !force) return(env)

  if (!interactive()) {
    stop("Please set bls_api_key. See ?bls_auth for instructions.", call. = FALSE)
  }

  #If not yet set, then try to read it from the console
  message("Couldn't find bls_api_key. SEE ?bls_auth for more details.")
  message("Please type your BLS API Key and press enter:")
  token <- readline(": ")

  #If blank, then exit with error. No API Key present.
  if (identical(token, "")) {
    stop("No API Key entered.", call. = FALSE)
  }

  #If not blank, then set the environmental variable so future calls in this session do not need it.
  message("Setting API KEY environmental variable: BLS_API_KEY for the rest of session.")
  Sys.setenv(BLS_API_KEY = token)

  token
}
