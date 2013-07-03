# -------------------- define paths ------------------------------ #

pathOriginalData <- "~/Documents/Datasets/HILDA10/"  # path of original panel data files, ending with "/"
pathWorking <- "../data/" # path where new files will be stored

# -------------------- study characteristics -------------------- #

firstYearOfStudy <- 2001
lastYearOfStudy <- 2010
startingWave <- 1

masterFile <- "Master_j100c.dta"
waveLabels <- letters[1:(lastYearOfStudy-firstYearOfStudy+1)]  # Wave names as letters
yearsToInclude <- seq(firstYearOfStudy,lastYearOfStudy)  # Years of Study
yearsToInclude2 <- substr(as.character(yearsToInclude), 3, 4)  # Two-digit year for some variable names
originalDataFile <- "Rperson_$100c.dta"
idName <- "xwaveid"
hID <- "hhrhid" # Needs wave prefix
partnerID <- "hhpxid" # Needs wave prefix; this is equivalent to the partner's cross-wave ID.
charsToSub <- "\\$"




getMasterVariable <- function(variableName, masterFileName=masterFile) {
    master <- read.dta(paste(pathOriginalData, masterFileName, sep = ""))
    return(master[,c(idName, variableName)])
}

getOneVariable <- function(variableStem, dataFileName=originalDataFile, masterFileName=masterFile,
                        wide=FALSE, waves=waveLabels) {
    master <- read.dta(paste(pathOriginalData, fileName, sep = ""))
    master <- data.frame(master[,c(idName)], stringsAsFactors=FALSE)
    names(master) <- idName
    for (i in waves) {
        newDataFileName <- paste(pathOriginalData, sub(charsToSub, i, dataFileName), sep = "")
        newVariableName <- paste(i, variableStem, sep = "")
        data <- read.dta(newDataFileName)
        data <- data[,c(idName, newVariableName)]
        master <- merge(master, data, by = idName, all.x=TRUE)
    }
    if (wide==FALSE) {
        master <- melt(master, id.vars=idName)
        master$variable <- str_replace(master$variable, variableStem, "")
        names(master)[2:3] <- c("wave",variableStem)
    }
    return(master)
}
        
