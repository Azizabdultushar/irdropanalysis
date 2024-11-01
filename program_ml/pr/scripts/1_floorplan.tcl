################################################
## Setup physical libraries and input netlist ##
################################################
set init_cpf_file $vars(cpf_file)
set init_lef_file $vars(lef_files)
set init_pwr_net {VDD}
set init_gnd_net {VSS}
set init_top_cell $vars(design)
set init_verilog $vars(netlist)

#################
## Read Design ##
#################
init_design
source ./scripts/innoGlobal.tcl

######################
## Create RC corner ##
######################
create_rc_corner -name rc125 \
 -qx_tech_file ../Library/tech/qrc/RC_QRC_gpdk045/rctyp/qrcTechFile \
 -T 125

create_rc_corner -name rc0 \
 -qx_tech_file ../Library/tech/qrc/RC_QRC_gpdk045/rctyp/qrcTechFile \
 -T 0

##########################
## Update Delay Corners ##
##########################
update_delay_corner -name AV_fast_mode_wc_rc125_setup_dc \
    -rc_corner rc125

update_delay_corner -name AV_eco_mode_wc_rc125_setup_dc \
    -rc_corner rc125

################################
## Select Active Timing Views ##
################################
set_analysis_view -setup {AV_fast_mode_wc_rc125_setup} -hold {AV_fast_mode_wc_rc125_setup}

##################### 
## Timing Derating ##
#####################
source ../DesignIn/misc/innoTimingDerate.tcl

#########################
## Adding SI Libraries ##
#########################
update_library_set -name gpdk045_wc_hi_lib -si [ list ../Library/cdb/slow.cdb ]
update_library_set -name gpdk045_wc_lo_lib -si [ list ../Library/cdb/slow.cdb ]
update_library_set -name gpdk045_bc_hi_lib -si [ list ../Library/cdb/fast.cdb ]
update_library_set -name gpdk045_bc_lo_lib -si [ list ../Library/cdb/fast.cdb ]

###########################
## Read Power Intent CPF ##
###########################
read_power_intent -cpf $vars(cpf_file)

#########################
## Commit Power Intent ##
#########################
commit_power_intent

###############################
## Floorplan initialization  ##
###############################
setPinConstraint -side {top bottom} -layer {M2}
setPinConstraint -side {right left} -layer {M3}
floorPlan -site CoreSite -r $aspect_ratio_H_W $core_utilization $coretoleft $coretoright $coretotop $coretobottom


################################
## Global VSS GRID generation ##
################################
addStripe \
 -set_to_set_distance $set2set \
 -spacing $space \
 -xleft_offset $offset \
 -direction vertical  \
 -layer $layer_vss \
 -width $width_vss \
 -nets VSS

addStripe \
 -set_to_set_distance $set2set \
 -spacing $space \
 -ybottom_offset $offset \
 -direction horizontal \
 -layer $layer_vdd \
 -width $width_vdd \
 -nets VDD 

addStripe \
-nets VSS \
-layer $layer_vss \
-direction vertical \
-width $single_stripe_width \
-spacing $single_stripe_space \
-number_of_sets 1 \
-extend_to design_boundary  \
-create_pins 1 \
-start_from left \
-start_offset $single_offset

addStripe \
-nets VDD \
-layer $layer_vdd \
-direction Horizontal \
-width $single_stripe_width \
-spacing $single_stripe_space \
-number_of_sets 1 \
-extend_to design_boundary  \
-create_pins 1 \
-start_from left \
-start_offset $single_offset

####################
### ADD ring #######
####################

addRing -nets {VDD VSS} -follow core -layer {top Metal5 bottom Metal5 left Metal6 right Metal6} -width $width_ring -spacing $space_ring -offset $offset_ring 

#############################################
## M1 power rails prerouting for Std Cells ##
#############################################
#Allow connectin M1 rail between different PD

setSrouteMode -corePinJoinLimit 6                                       
sroute -connect corePin -nets VSS -allowJogging 0 -corePinMaxViaWidth 60
sroute -connect corePin -nets VDD -powerDomains TOP -allowJogging 0 -corePinMaxViaWidth 60

###############
## Reporting ##
###############
timeDesign -prePlace -outDir $vars(rpt_dir_fp)/timingReports -prefix floorplan
report_timing -format {instance pin cell net  load slew delay arrival}

timeDesign -prePlace -expandedViews -numPaths 10 -outDir $vars(rpt_dir_fp)/timingReports -prefix floorplan
timeDesign -prePlace -hold -expandedViews -numPaths 10 -outDir $vars(rpt_dir_fp)/timingReports -prefix floorplan

reportGateCount -stdCellOnly -outfile $vars(rpt_dir_fp)/stdGateCount.rpt
analyzeFloorplan -outfile $vars(rpt_dir_fp)/AnalyzeFloorplan.rpt

##########################
## Check DRC		##
##########################
verifyGeometry

##########################
## Save Design and exit ##
##########################
clearDrc
saveDesign $vars(dbs_dir)/floorplan.enc

