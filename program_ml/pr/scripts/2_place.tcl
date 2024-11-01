##########################
## Setup Timing options ##
##########################
set_analysis_view -setup {AV_fast_mode_wc_rc125_setup} -hold {AV_eco_mode_bc_rc0_hold}
setAnalysisMode -analysisType onChipVariation -cppr both -checkType setup
set_interactive_constraint_modes [ all_constraint_modes -active ]

#####################
## Timing Derating ##
#####################
source ../DesignIn/misc/innoTimingDerate.tcl

######################
## Place the Design ##
######################
#placeDesign -inPlaceOpt
#place_opt_design
place_design
getTieHiLoMode
addTieHiLo -cell "TIEHI TIELO" -powerDomain TOP


###################
## Report Timing ##
###################
timeDesign -preCTS -outDir $vars(rpt_dir_Pl)/timingReports -prefix place


#################
## Save Design ##
#################
saveDesign $vars(dbs_dir)/place.enc

#exit
