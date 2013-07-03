# -------------------- define paths ------------------------------ #

pathOriginalData <- "~/Documents/Datasets/HILDA10/"  # path of original panel data files, ending with "/"
pathWorking <- "data/" # path where new files will be stored

# -------------------- load functions ------------------------------ #

source(paste(pathScripts, "divorceFunctions.R", sep = ""))


# -------------------- study characteristics -------------------- #

firstYearOfStudy <- 1984
lastYearOfStudy <- 2009
startingWave <- 1
waveLabels <- letters[1:(lastYearOfStudy-firstYearOfStudy+1)]  # Wave names as letters
yearsToInclude <- seq(firstYearOfStudy,lastYearOfStudy)  # Years of Study
yearsToInclude2 <- substr(as.character(yearsToInclude), 3, 4)  # Two-digit year for some variable names
originalDataFile <- "$p.dta"
oldID <- "persnr"
id <- oldID
charsToSub <- "\\$"




