###################
## Load Place dB ##
###################
#source ./scripts/innoGlobal.tcl
#source ../DesignOut/place.enc

##########################
## Setup Timing options ##
##########################
set_analysis_view -setup {AV_fast_mode_wc_rc125_setup} -hold {AV_fast_mode_wc_rc125_setup}
setAnalysisMode -analysisType onChipVariation -cppr both -checkType setup
source ../DesignIn/misc/innoTimingDerate.tcl


#########################
## ClockTree Synthesis ##
#########################
cleanupSpecifyClockTree
source ../DesignIn/cts/my_ctsSpec_ccopt.tcl
create_ccopt_clock_tree_spec -views {AV_fast_mode_wc_rc125_setup AV_fast_mode_wc_rc125_setup} -file ../DesignIn/cts/ctsSpec_ccopt.tcl
source ../DesignIn/cts/ctsSpec_ccopt.tcl
ccopt_design

###################
## Report Timing ##
###################
timeDesign -postCTS -numPaths 10 -outDir $vars(rpt_dir_cts)/timingReports/cts 
timeDesign -postCTS -hold -numPaths 10 -outDir $vars(rpt_dir_cts)/timingReports/cts

#################
## Save Design ##
#################
clearDrc
saveDesign $vars(dbs_dir)/cts.enc

#exit