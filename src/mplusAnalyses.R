#require("MplusAutomation")

# When using wine, need to fix bug:
file.sources = list.files("/home/rich/Projects/MplusAutomation/R/", 
                          pattern="*.R$", full.names=TRUE, 
                          ignore.case=TRUE)
sapply(file.sources,source,.GlobalEnv)
require("gsubfn")

# Create and run Mplus models for dyadic starts model


baseModel <- mplusObject(TITLE = 'Dyadic STARTS MODEL using HILDA Data',
                  ANALYSIS = 'ESTIMATOR = ML;',
                  MODEL = '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Husband Model
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

! Fix residual observed variance to be equal

hls1*1 (herror);
hls2*1 (herror);
hls3*1 (herror);
hls4*1 (herror);
hls5*1 (herror);
hls6*1 (herror);
hls7*1 (herror);
hls8*1 (herror);
hls9*1 (herror);
hls10*1 (herror);

! Create latent stable trait factor

htrait by hls1@1;
htrait by hls2@1;
htrait by hls3@1;
htrait by hls4@1;
htrait by hls5@1;
htrait by hls6@1;
htrait by hls7@1;
htrait by hls8@1;
htrait by hls9@1;
htrait by hls10@1;

! Name stable trait variance
htrait*1 (htraitVar);

! Set up autoregressive factors
har1 by hls1@1;
har2 by hls2@1;
har3 by hls3@1;
har4 by hls4@1;
har5 by hls5@1;
har6 by hls6@1;
har7 by hls7@1;
har8 by hls8@1;
har9 by hls9@1;
har10 by hls10@1;

! Define autoregressive structure
har2 on har1*.7 (hstab);
har3 on har2*.7 (hstab);
har4 on har3*.7 (hstab);
har5 on har4*.7 (hstab);
har6 on har5*.7 (hstab);
har7 on har6*.7 (hstab);
har8 on har7*.7 (hstab);
har9 on har8*.7 (hstab);
har10 on har9*.7 (hstab);

! Set name for initial AR variance (for later constraint)
har1*1 (hArVar);

! Impose equality constraint on residual variances
har2*.3 (hNew);
har3*.3 (hNew);
har4*.3 (hNew);
har5*.3 (hNew);
har6*.3 (hNew);
har7*.3 (hNew);
har8*.3 (hNew);
har9*.3 (hNew);
har10*.3 (hNew);


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Wife Model
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

! Fix residual observed variance to be equal

wls1*1 (werror);
wls2*1 (werror);
wls3*1 (werror);
wls4*1 (werror);
wls5*1 (werror);
wls6*1 (werror);
wls7*1 (werror);
wls8*1 (werror);
wls9*1 (werror);
wls10*1 (werror);

! Create latent stable trait factor

wtrait by wls1@1;
wtrait by wls2@1;
wtrait by wls3@1;
wtrait by wls4@1;
wtrait by wls5@1;
wtrait by wls6@1;
wtrait by wls7@1;
wtrait by wls8@1;
wtrait by wls9@1;
wtrait by wls10@1;

! Name stable trait variance
wtrait*1 (wtraitVar);

! Set up autoregressive factors
war1 by wls1@1;
war2 by wls2@1;
war3 by wls3@1;
war4 by wls4@1;
war5 by wls5@1;
war6 by wls6@1;
war7 by wls7@1;
war8 by wls8@1;
war9 by wls9@1;
war10 by wls10@1;

! Define autoregressive structure
war2 on war1*.7 (wstab);
war3 on war2*.7 (wstab);
war4 on war3*.7 (wstab);
war5 on war4*.7 (wstab);
war6 on war5*.7 (wstab);
war7 on war6*.7 (wstab);
war8 on war7*.7 (wstab);
war9 on war8*.7 (wstab);
war10 on war9*.7 (wstab);

! Set name for initial AR variance (for later constraint)
war1*1 (wArVar);

! Impose equality constraint on residual variances
war2*.3 (wNew);
war3*.3 (wNew);
war4*.3 (wNew);
war5*.3 (wNew);
war6*.3 (wNew);
war7*.3 (wNew);
war8*.3 (wNew);
war9*.3 (wNew);
war10*.3 (wNew);

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Dyadic Part of Model
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

! Stable Trait Correlation
htrait with wtrait*.6 (UTSIM);

! Initial AR Correlation
har1 with war1*.5 (UISIM);

! New AR correlations
har2 with war2 (UNSIM);
har3 with war3 (UNSIM);
har4 with war4 (UNSIM);
har5 with war5 (UNSIM);
har6 with war6 (UNSIM);
har7 with war7 (UNSIM);
har8 with war8 (UNSIM);
har9 with war9 (UNSIM);
har10 with war10 (UNSIM);


! State/Error Correlations
hls1 with wls1 (UESIM);
hls2 with wls2 (UESIM);
hls3 with wls3 (UESIM);
hls4 with wls4 (UESIM);
hls5 with wls5 (UESIM);
hls6 with wls6 (UESIM);
hls7 with wls7 (UESIM);
hls8 with wls8 (UESIM);
hls9 with wls9 (UESIM);
hls10 with wls10 (UESIM);

! Make sure factors are uncorrelated
har1,war1 with htrait@0;
har1,war1 with wtrait@0;

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Model Constraints
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


MODEL CONSTRAINT:

! Nonlinear constraints for stationarity

! Husbands
hNew = hArVar - (hArVar * hstab**2);

! Wives
wNew = wArVar - (wArVar * wstab**2);

! Create new parameters
NEW (TSIM ISIM NSIM ESIM HREL WREL);

TSIM = UTSIM / sqrt (wtraitVar * htraitVar);
ISIM = UISIM / sqrt (wArVar * hArVar);
NSIM = UNSIM / sqrt (wArVar * hArVar);
ESIM = UESIM / sqrt (werror * herror);
WREL = (wtraitVar + wArVar) / (wtraitVar + wArVar + werror);
HREL = (htraitVar + hArVar) / (htraitVar + hArVar + herror);

',
                  OUTPUT = 'RESIDUAL STANDARDIZED CINTERVAL TECH3 TECH4 SAMPSTAT;')



satVars <- paste("losat",c("","eo","fs","ft","hl","lc","nl","sf","yh"), sep="")

losatVars <- paste(paste(rep(letters[1:10], each=2), c("h","w"), sep="_"), "losat", sep="")
losatData <- wideSatCouples[,losatVars]
names(losatData) <- paste(c("hls","wls"),rep(1:10, each=2), sep="")
losatModel <- update(baseModel, rdata=losatData, usevariables=names(losatData), TITLE=~'Life Satisfaction')
losat <- mplusModeler(losatModel, dataout="../data/losat.dat", modelout="losat.inp", run=0)

losateoVars <- paste(paste(rep(letters[1:10], each=2), c("h","w"), sep="_"), "losateo", sep="")
losateoData <- wideSatCouples[,losateoVars]
names(losateoData) <- paste(c("hls","wls"),rep(1:10, each=2), sep="")
losateoModel <- update(baseModel, rdata=losateoData, usevariables=names(losateoData), TITLE=~'Employment Opportunities')
losateo <- mplusModeler(losateoModel, dataout="../data/losateo.dat", modelout="losateo.inp", run=0)

losatfsVars <- paste(paste(rep(letters[1:10], each=2), c("h","w"), sep="_"), "losatfs", sep="")
losatfsData <- wideSatCouples[,losatfsVars]
names(losatfsData) <- paste(c("hls","wls"),rep(1:10, each=2), sep="")
losatfsModel <- update(baseModel, rdata=losatfsData, usevariables=names(losatfsData), TITLE=~'Financial Situation')
losatfs <- mplusModeler(losatfsModel, dataout="../data/losatfs.dat", modelout="losatfs.inp", run=0)

losatftVars <- paste(paste(rep(letters[1:10], each=2), c("h","w"), sep="_"), "losatft", sep="")
losatftData <- wideSatCouples[,losatftVars]
names(losatftData) <- paste(c("hls","wls"),rep(1:10, each=2), sep="")
losatftModel <- update(baseModel, rdata=losatftData, usevariables=names(losatftData), TITLE=~'Free Time')
losatft <- mplusModeler(losatftModel, dataout="../data/losatft.dat", modelout="losatft.inp", run=0)

losathlVars <- paste(paste(rep(letters[1:10], each=2), c("h","w"), sep="_"), "losathl", sep="")
losathlData <- wideSatCouples[,losathlVars]
names(losathlData) <- paste(c("hls","wls"),rep(1:10, each=2), sep="")
losathlModel <- update(baseModel, rdata=losathlData, usevariables=names(losathlData), TITLE=~'Home')
losathl <- mplusModeler(losathlModel, dataout="../data/losathl.dat", modelout="losathl.inp", run=0)

losatlcVars <- paste(paste(rep(letters[1:10], each=2), c("h","w"), sep="_"), "losatlc", sep="")
losatlcData <- wideSatCouples[,losatlcVars]
names(losatlcData) <- paste(c("hls","wls"),rep(1:10, each=2), sep="")
losatlcModel <- update(baseModel, rdata=losatlcData, usevariables=names(losatlcData), TITLE=~'Local Community')
losatlc <- mplusModeler(losatlcModel, dataout="../data/losatlc.dat", modelout="losatlc.inp", run=0)

losatnlVars <- paste(paste(rep(letters[1:10], each=2), c("h","w"), sep="_"), "losatnl", sep="")
losatnlData <- wideSatCouples[,losatnlVars]
names(losatnlData) <- paste(c("hls","wls"),rep(1:10, each=2), sep="")
losatnlModel <- update(baseModel, rdata=losatnlData, usevariables=names(losatnlData), TITLE=~'Neighborhood')
losatnl <- mplusModeler(losatnlModel, dataout="../data/losatnl.dat", modelout="losatnl.inp", run=0)

losatsfVars <- paste(paste(rep(letters[1:10], each=2), c("h","w"), sep="_"), "losatsf", sep="")
losatsfData <- wideSatCouples[,losatsfVars]
names(losatsfData) <- paste(c("hls","wls"),rep(1:10, each=2), sep="")
losatsfModel <- update(baseModel, rdata=losatsfData, usevariables=names(losatsfData), TITLE=~'Safety')
losatsf <- mplusModeler(losatsfModel, dataout="../data/losatsf.dat", modelout="losatsf.inp", run=0)

losatyhVars <- paste(paste(rep(letters[1:10], each=2), c("h","w"), sep="_"), "losatyh", sep="")
losatyhData <- wideSatCouples[,losatyhVars]
names(losatyhData) <- paste(c("hls","wls"),rep(1:10, each=2), sep="")
losatyhModel <- update(baseModel, rdata=losatyhData, usevariables=names(losatyhData), TITLE=~'Health')
losatyh <- mplusModeler(losatyhModel, dataout="../data/losatyh.dat", modelout="losatyh.inp", run=0)




