###################
## Load Route dB ##
###################
#source ./scripts/innoGlobal.tcl
#source ../DesignOut/optRoute.enc

################################
## File extraction for voltus ##
################################

write_lef_abstract $vars(irdrop_data_input)/postroute_IR.lef -noCutObs -stripePin -PGpinLayers 6 -specifyTopLayer 6

set_analysis_view -setup {AV_fast_mode_wc_rc125_setup} -hold {AV_fast_mode_wc_rc125_setup}  

do_extract_model $vars(irdrop_data_input)/postRoute_IR.lib -view AV_fast_mode_wc_rc125_setup 

setExtractRCMode -engine postRoute -effortLevel medium
extractRC 
rcOut -spef $vars(irdrop_data_input)/postRoute_IR.spef 
