#
# Reset EAVS Fips Code to a 5 length character string
#
# NOTE This leaves Wisconsin missing because Wisconsin administeres
# elections at the township level, and reports EAVS data at this level.
# Some townships cross county boundaries, so a more complex solution is
# required for that state. 
#
# Author: Paul Gronke, Reed College, November 11, 2022

library(tidyverse)

# Step 1: Download the 2020 EAVS Data
#
# The script looks for the EAVS in the working directory for the script.
#
# Change line 36 if you have the EAVS stored locally
#

if (!file.exists("eavs20.csv")) {
  download.file("https://www.eac.gov/sites/default/files/EAVS%202020/2020_EAVS_for_Public_Release_nolabel_V2.csv",
                destfile = ("eavs20.csv"))
}

#
# Step 2: Load in the EAVS data, identify all NA (missing) values 
#

eavs <- read_csv("eavs20.csv",
                 na = c("", "NA", "-88", "-99"))

#
# Step 3: Craete "fips" which contains the first 5 characters from FIPSCode

eavs <- eavs %>%
  mutate(fips = case_when(
    State_Abbr != "WI" ~ substr(FIPSCode, 1, 5),
    State_Abbr == "WI" ~ "")
  )

# 
# Step 4: Check our work. Max length should be 5
#

max(nchar(eavs$fips))

