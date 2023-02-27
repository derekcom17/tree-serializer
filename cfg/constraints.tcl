# constraints.tcl
#
# This file is where design timing constraints are defined for Genus and Innovus.
# Many constraints can be written directly into the Hammer config files. However, 
# you may manually define constraints here as well.
#

# TODO: add constraints here!
create_clock -name clk -period 5.6 [get_ports clk_i]
set_clock_uncertainty 0.100 [get_clocks clk]
set_input_delay  2.0 -clock [get_clocks clk] [all_inputs] 
set_output_delay 2.0 -clock [get_clocks clk] [all_outputs] 
