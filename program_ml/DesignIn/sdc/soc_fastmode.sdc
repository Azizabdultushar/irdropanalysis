create_clock [get_ports clk_i]  -period 4.0  -waveform {0 2} -name clk_i
set_clock_uncertainty 0.025  -setup [get_clocks clk_i]
set_clock_uncertainty 0.050  -hold [get_clocks clk_i]
set_clock_transition -fall 0.04 [get_clocks clk_i]
set_clock_transition -rise 0.04 [get_clocks clk_i]

group_path -name "reg2reg" -critical_range 0.1 -from [ all_registers -clock_pins ] -to [ all_registers -data_pins ]
group_path -name "in2reg"  -from [remove_from_collection [all_inputs] {nrestore rclk}] -to [ all_registers -data_pins ]
group_path -name "reg2out" -from [ all_registers -clock_pins ] -to [all_outputs]

set_input_delay 0.1 -clock clk_i [remove_from_collection [all_inputs] {clock nrestore}]
set_output_delay 0.1 -clock clk_i  [remove_from_collection [all_outputs]]
#set_input_transition 1.0 [get_ports nrestore]
set_input_transition 0.2 [all_inputs]


#Avoid using LVT cells
set_dont_use [get_lib_cells *LVT] true
