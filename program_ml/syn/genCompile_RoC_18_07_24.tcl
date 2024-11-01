# Cadence Genus(TM) Synthesis Solution, Version 17.11-s014_1, built Oct  9 2017

# Date: Thu Oct 26 21:57:09 2023
# Host: item0109.item.uni-bremen.de (x86_64 w/Linux 3.10.0-1160.88.1.el7.x86_64) (4cores*16cpus*2physical cpus*Intel(R) Xeon(R) CPU L5520 @ 2.27GHz 8192KB)
# OS:   CentOS Linux release 7.9.2009 (Core)

############################
# set up variable          #
############################
set c "wc"
set m "ibex_core"

#############################
## Read libraries from CPF ##
#############################
read_power_intent -cpf  -module $m ../DesignIn/cpf/18_07_24.cpf

#############################



###########################
# Read RTL files ##########
###########################

set_db init_hdl_search_path ../../rtl/ibex
read_hdl -sv {ibex_alu.v ibex_register_file_latch.v ibex_register_file_ff.v ibex_branch_predict.v ibex_register_file_fpga.v ibex_compressed_decoder.v ibex_controller.v ibex_wb_stage.v ibex_core.v ibex_counter.v prim_badbit_ram_1p.v ibex_cs_registers.v prim_clock_gating.v ibex_csr.v prim_generic_clock_gating.v ibex_decoder.v prim_generic_ram_1p.v ibex_dummy_instr.v prim_lfsr.v ibex_ex_block.v prim_ram_1p.v ibex_fetch_fifo.v prim_secded_28_22_dec.v ibex_icache.v prim_secded_28_22_enc.v ibex_id_stage.v prim_secded_39_32_dec.v ibex_if_stage.v prim_secded_39_32_enc.v ibex_load_store_unit.v prim_secded_72_64_dec.v ibex_multdiv_fast.v prim_secded_72_64_enc.v ibex_multdiv_slow.v prim_xilinx_clock_gating.v ibex_pmp.v ibex_prefetch_buffer.v}

# Enable clock gating #
set_db lp_insert_clock_gating true

###########################################################################################
# Eleaborate the design #
#design is now translated to a technology independent RTL model. Elaboration brings all 
#the associated lower level blocks into the synthesis tool #
##############################################################################################
elaborate $m

############################################################################################################
# The command uniquify is used to make unique the instances of the same reference design during synthesis.
# If you were to now look at your schematic view, you'd notice that ha1 and ha2 have different internal
# names. They now have the names: ha_1 and ha_0. Before they both had the same name: ha...this step
# allows each half adder to be its own 'unique' module. We can now apply different 'constraints' to each
# half adder, without affecting the other instance of it in the design.
#############################################################################################################
uniquify /designs/$m 

###############################################################
# Applying design constraints using sdc or tcl file extension
###############################################################

#read_sdc ../../sdc/ibex_Design_Constraints.sdc

##############################
## Define Clock Gating cell ##
##############################


#set_attribute lp_clock_gating_cell [lindex [find / -libcell CKLNQD8HPBWP] 0] /designs/$m
#set_db design:$m .lp_clock_gating_cell CKLNQD8HPBWP

###############################
## Define switching activity ##
###############################
set_db lp_toggle_rate_unit /ns
set_db lp_power_analysis_effort medium

set_db syn_generic_effort medium
syn_generic $m

#################################
## Power Optimization settings ##
#################################
#set_db leakage_power_effort medium
#set_db lp_power_optimization_weight 0.95 /designs/$m

###############
## Apply CPF ##
###############
apply_power_intent


################
## Commit CPF ##
################
#report low_power_cells -summary
commit_power_intent -design $m


##############################
## Synthesis to GPDK045 lib ##
##############################
set_db syn_map_effort medium
syn_map $m

report timing -summary
report power -detail > reports/PowerBeforeOpt_$c.rpt
report_timing > reports/TimingBeforeOpt_$c.rpt
#report_power > reports/PowerBeforeOpt_$c.rpt


##############################
## Incremental optimization ##
##############################
report power
set_db syn_opt_effort low
syn_opt $m -incremental

report_timing > reports/TimingAfterOpt_$c.rpt
report_power -detail > reports/PowerAfterOpt_$c.rpt

###################
# Other reporting #
###################
report area > reports/compile.area_$c.rpt
report gates > reports/compile.gates_$c.rpt
report clock_gating > reports/compile.clock_gating_$c.rpt
report power > ./reports/compile.power.rpt

###############################
## Write out verilog netlist ##
###############################

write_hdl > results/netlist_$m.v
#write_sdc > results/netlist_$m.sdc
write_db $m -all_root_attributes -to_file $m.tcl

exit
