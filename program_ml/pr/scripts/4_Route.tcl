#################
## Load CTS dB ##
#################
#source ./scripts/innoGlobal.tcl
#source ../DesignOut/cts.enc

##########################
## Setup Timing options ##
##########################
set_analysis_view -setup {AV_fast_mode_wc_rc125_setup} -hold {AV_fast_mode_wc_rc125_setup}
set_interactive_constraint_modes [ all_constraint_modes -active ]
set_propagated_clock [ all_clocks ]
setAnalysisMode -analysisType onChipVariation -cppr both -checkType setup
source ../DesignIn/misc/innoTimingDerate.tcl

#############################
## Insert Std Filler Cells ##
#############################
setFillerMode -doDRC false -corePrefix FILL -core "FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1"
addFiller

#####################
## Routing options ##
#####################
setNanoRouteMode -routeWithSiDriven true
setNanoRouteMode -routeInsertAntennaDiode true
setNanoRouteMode -routeAntennaCellName "ANTENNA"

##################
## Route Design ##
##################
routeDesign

###################
## Report timing ##
###################
timeDesign -postRoute -numPaths 10 -outDir $vars(rpt_dir_rt)/timingReports/route -prefix route

########################################
## Export def file for QRC Extraction ##
########################################
defOut -floorplan -placement -netlist -routing $vars(dbs_dir)/route.def.gz

#################
## Save Design ##
#################
saveDesign $vars(dbs_dir)/route.enc

#exit
