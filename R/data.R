#' Employment data from the BLS.
#'
#' Data on the number of employees from the BLS, fetched using the BLS API and
#' the \code{blsAPI} package. The script to perform the get and processing can
#' be found at \url{http://github.com/potterzot/livingwage/data-raw/bls.R}.
#'
#' @format a data frame with X rows and Y variables:
#' \describe{
#'  \item{year}{Year.}
#'  \item{period}{Period.}
#'  \item{periodName}{Name of period.}
#'  \item{employees}{Number of employees.}
#'  \item{series}{series name, generally location.}
#' }
#'
#' @source \url{http://www.bls.gov/}
"bls"
