# constraints.tcl
#
# This file is where design timing constraints are defined for Genus and Innovus.
# Many constraints can be written directly into the Hammer config files. However, 
# you may manually define constraints here as well.
#

# Single data rate
create_clock -name core_clk -period 4.0 [get_ports CLK]
# puts "//// CONSTRAINING SERIAL CLOCK PERIOD TO $::env(SER_CLK_PERIOD)ns"
# create_clock -name core_clk -period ${::env(SER_CLK_PERIOD)} [get_ports CLK]

# Assume async resest just to be "fair" when comparing performance with tree serializer
set_false_path -from [get_ports RESET]
