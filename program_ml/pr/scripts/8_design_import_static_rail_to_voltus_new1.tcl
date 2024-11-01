
#-----------------------------------------------------------------------
# scripts to run static rail analysis
#-----------------------------------------------------------------------

#------------------------------------------------------
# set multi CPU
# ------------------------------------------------------
set_multi_cpu_usage \
        -localCpu                       8

set lefs [list]
lappend lefs ../Library/lef/gsclib045_tech.lef
lappend lefs ../Library/lef/gsclib045_macro.lef
lappend lefs ../Library/lef/gsclib045_hvt_macro.lef
lappend lefs ../Library/lef/gsclib045_lvt_macro.lef
lappend lefs  $vars(irdrop_data_input)/postroute_IR.lef
set_message -no_limit
read_lib -lef $lefs

# read corners and analysis view data
#----------------------------------------------------------------------
read_verilog ../syn/results/netlist_$vars(design).v
set_top_module $vars(design) -ignore_undefined_cell

read_def $vars(dbs_dir)/optRoute.def.gz

#-----------------------------------------------------------------------
# Read cpf file for power domain information
#-----------------------------------------------------------------------
read_power_domain -cpf $vars(cpf_file)

#-----------------------------------------------------------------------
# Static Rail Analysis
#-----------------------------------------------------------------------
set_rail_analysis_mode \
    -method                     static \
    -accuracy                   xd \
    -analysis_view              AV_fast_mode_wc_rc125_setup \
    -power_grid_library         { \
        ../DesignIn/Library/pgv/stdcells.cl \
        ../DesignIn/Library/pgv/techonly.cl \
    } \
    -enable_rlrp_analysis       true \
    -verbosity true \
    -temperature 125

#-----------------------------------------------------------------------
#Power pad creation
#-------------------------------------------------
create_power_pads -net VDD -auto_fetch -snap_distance 100 -layer Metal5
create_power_pads -net VDD -vsrc_file $vars(power_pad_dir)/$vars(design)_VDD.pp

create_power_pads -net VDD -auto_fetch -snap_distance 100 -layer Metal6
create_power_pads -net VDD -vsrc_file $vars(power_pad_dir)/$vars(design)_VSS.pp

#-----------------------------------------------------------------------
# define voltage source location
#-----------------------------------------------------------------------

set_power_pads \
    -reset

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
set_pg_nets -net VDD -voltage 1.08 -threshold 0.972
set_pg_nets -net VSS -voltage 0 -threshold 0.108
set_rail_analysis_domain -name ALL -pwrnets { VDD} -gndnets { VSS}
set_power_data -reset


set_power_pads -reset


set_power_pads -net VDD -format xy -file $vars(power_pad_dir)/ibex_core_VDD.pp
set_power_pads -net VSS -format xy -file $vars(power_pad_dir)/ibex_core_VDD.pp

#############
#edited here#
#############

set_power_data -format current -scale 1 $vars(dbs_dir)/staticPowerResults/static_VDD.ptiavg 
set_power_data -format current -scale 1 $vars(dbs_dir)/staticPowerResults/static_VSS.ptiavg


set_package -reset
set_package -spice {} -mapping {}
set_net_group -reset
set_advanced_rail_options -reset

analyze_rail -type domain -results_directory $vars(IRDrop)/staticRailResults ALL

read_power_rail_results \
    -rail_directory		 $vars(IRDrop)/staticRailResults/ALL_125C_avg_1

#-----------------------------------------------------------------------
#what -if analysis
#-----------------------------------------------------------------------
scale_what_if_current \
    -global \
    -scale                      10

scale_what_if_resistance \
    -global \
    -net                        VDD \
    -layer                      Metal4 \
    -scale                      4 \
    -auto_scale_adjacent_via_layers                     true

analyze_rail \
    -results_directory          $vars(IRDrop)/staticRailResults \
    -type                       domain \
                                ALL

#-----------------------------------------------------------------------
# load analysis results
#-----------------------------------------------------------------------
read_power_rail_results -reset

read_power_rail_results \
    -rail_directory		 $vars(IRDrop)/staticRailResults/ALL_125C_avg_2

#-----------------------------------------------------------------------
# View the results:
#-----------------------------------------------------------------------

set_power_rail_display \
   -plot 			ir

#---------------------END----------------------------------------------





#exit
