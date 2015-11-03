library(rjson)
library(blsAPI)
library(livingwage)

### Get data from the BLS for analysis
#Employment series:
# Series ID    SMU19197801523800001
# Positions       Value           Field Name
# 1-2             SM              Prefix
# 3               U               Seasonal Adjustment Code
# 4-5             19              State Code
# 6-10            19780           Area Code
# 11-18           15238000        SuperSector and Industry Code
# 19-20           01             	Data Type Code

#QCEW series
# Series ID    ENU040131050A0115
# Positions       Value           Field Name
# 1-2             EN              Prefix
# 3               U               Seasonal Adjustment Code
# 4-8             04013           Area Code
# 9               1               Data Type Code
# 10              0               Size Code
# 11              5               Ownership Code
# 12-17           0A0115          Industry Code

# area codes: http://www.bls.gov/cew/doc/titles/area/area_titles.htm
areas <- read.csv("data-raw/area_titles.csv", stringsAsFactors = FALSE)
areas$name <- lapply(areas$area_title, function(x) { strsplit(x, ", ", fixed = TRUE)[[1]][1] })

types <- read.csv("data-raw/datatype_titles.csv", stringsAsFactors = FALSE)
sizes <- read.csv("data-raw/size_titles.csv", stringsAsFactors = FALSE)
ownerships <- read.csv("data-raw/ownership_titles.csv", stringsAsFactors = FALSE)
industries <- read.csv("data-raw/industry_titles.csv", stringsAsFactors = FALSE)


#Employees, all sizes, private, all industries
qcew_series <- list(
  "Albuquerque MSA"             = "ENUC107410510",
  "King County"                 = "ENU5303310510",
  "Santa Fe MSA"                = "ENUC421410510",
  "Santa Fe County"             = "ENU3504910510",
  "Seattle/Tacoma CSA"          = "ENUCS50010510",
  "Seattle-Tacoma-Bellevue MSA" = "ENUC426610510"
  )
opts <- list(
  'startyear' = 2000,
  'endyear' = 2015,
  'registrationKey' = bls_auth()
)

qcew <- get_bls(qcew_series, opts, name="employees")
bls <- qcew
devtools::use_data(bls, overwrite=TRUE, compress="gzip")
