# Create and run Mplus models for dyadic starts model

lsModel <- mplusObject(TITLE = 'Dyadic STARTS MODEL using HILDA Data',
                  ANALYSIS = 'ESTIMATOR = ML;',
                  MODEL = '
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Husband Model
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

! Fix residual observed variance to be equal

hls1-hls10*1 (herror);

! Create latent stable trait factor

htrait by hls1-hls10@1;

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
har2-har10*.3 (hNew);


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Wife Model
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

! Fix residual observed variance to be equal

wls1-wls10*1 (werror);

! Create latent stable trait factor

wtrait by wls1-wls10@1;

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
har2-har10 pwith war2-war10*3 (UNSIM);

! State/Error Correlations
hls1-hls10 pwith wls1-wls10 (UESIM);

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
                  OUTPUT = 'RESIDUAL STANDARDIZED CINTERVAL TECH3 TECH4 SAMPSTAT;',
                  usevariables = names(finalLS[2:21]),
                  rdata = finalLS)