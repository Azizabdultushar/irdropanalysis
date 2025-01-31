###############################################################
#  Generated by:      Cadence Innovus 21.35-s114_1
#  OS:                Linux x86_64(Host ID item0110.item.uni-bremen.de)
#  Generated on:      Wed Oct 16 16:23:52 2024
#  Design:            ibex_core
#  Command:           create_ccopt_clock_tree_spec -views {AV_fast_mode_wc_rc125_setup AV_fast_mode_wc_rc125_setup} -file ../DesignIn/cts/ctsSpec_ccopt.tcl
###############################################################
#-------------------------------------------------------------------------------
# Clock tree setup script - dialect: Innovus
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------

if { [get_ccopt_clock_trees] != {} } {
  error {Cannot run clock tree spec: clock trees are already defined.}
}

namespace eval ::ccopt {}
namespace eval ::ccopt::ilm {}
set ::ccopt::ilm::ccoptSpecRestoreData {}
# Start by checking for unflattened ILMs.
# Will flatten if so and then check the db sync.
if { [catch {ccopt_check_and_flatten_ilms_no_restore}] } {
  return -code error
}
# cache the value of the restore command output by the ILM flattening code
set ::ccopt::ilm::ccoptSpecRestoreData $::ccopt::ilm::ccoptRestoreILMState

# The following pins are clock sources
set_ccopt_property cts_is_sdc_clock_root -pin clk_i true

# Clocks present at pin clk_i
#   clk_i (period 4.000ns) in timing_config fast_mode([../DesignIn/sdc/soc_fastmode.sdc])
create_ccopt_clock_tree -name clk_i -source clk_i -no_skew_group
set_ccopt_property target_max_trans_sdc -delay_corner AV_fast_mode_wc_rc125_setup_dc -early -clock_tree clk_i 0.040
set_ccopt_property target_max_trans_sdc -delay_corner AV_fast_mode_wc_rc125_setup_dc -late -clock_tree clk_i 0.040
set_ccopt_property source_output_max_trans -delay_corner AV_fast_mode_wc_rc125_setup_dc -early -clock_tree clk_i 0.200
set_ccopt_property source_output_max_trans -delay_corner AV_fast_mode_wc_rc125_setup_dc -late -clock_tree clk_i 0.200
# Clock period setting for source pin of clk_i
set_ccopt_property clock_period -pin clk_i 4

##############################################################################
##
## Timing connectivity based skew groups: off
##
##############################################################################
set_ccopt_property timing_connectivity_info {}

# Skew group to balance non generated clock:clk_i in timing_config:fast_mode (sdc ../DesignIn/sdc/soc_fastmode.sdc)
create_ccopt_skew_group -name clk_i/fast_mode -sources clk_i -auto_sinks
set_ccopt_property include_source_latency -skew_group clk_i/fast_mode true
set_ccopt_property extracted_from_clock_name -skew_group clk_i/fast_mode clk_i
set_ccopt_property extracted_from_constraint_mode_name -skew_group clk_i/fast_mode fast_mode
set_ccopt_property extracted_from_delay_corners -skew_group clk_i/fast_mode AV_fast_mode_wc_rc125_setup_dc


check_ccopt_clock_tree_convergence
# Restore the ILM status if possible
if { [get_ccopt_property auto_design_state_for_ilms] == 0 } {
  if {$::ccopt::ilm::ccoptSpecRestoreData != {} } {
    eval $::ccopt::ilm::ccoptSpecRestoreData
  }
}

