# constraints.tcl
#
# This file is where design timing constraints are defined for Genus and Innovus.
# Many constraints can be written directly into the Hammer config files. However, 
# you may manually define constraints here as well.
#

# TODO: add constraints here!
create_clock -name core_clk -period 10 [get_ports CLK]
