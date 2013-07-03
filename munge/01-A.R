# Example preprocessing script.

sex <- getMasterVariable("sex")
cache('sex')

satVars <- paste("losat",c("","eo","fs","ft","hl","lc","nl","sf","yh"), sep="")
satData <- getVariables(satVars)
recodeString <- "-10:-1=NA"
satData[, satVars] <- lapply (satData[, satVars], iRecode, recodeString)
cache('satData')

partnerNumbers <- getVariables("hhpxid")
cache('partnerNumbers')
