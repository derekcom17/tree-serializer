# constraints.tcl
# 

# Constraints for serial clock (Remember this is DDR so the data is twice as fast!)
set_units -time ns

create_clock [get_ports clk_i]  -name serial_clock  -period 2.0
# puts "//// CONSTRAINING SERIAL CLOCK PERIOD TO $::env(SER_CLK_PERIOD)ns"
# create_clock [get_ports clk_i]  -name serial_clock  -period $::env(SER_CLK_PERIOD)

# Give a lot more time for the async reset signal
set_false_path -from [get_ports reset_i]

# TEST:
# set mp_muxs [get_entity_instances mp_mux_2]

# # Net/pin search tests:
# # puts "all pins = [get_pins "*"]"
# puts "pin 0 = [get_property [lindex [get_pins "*"] 0] full_name]"
# puts "pin 0 name = [get_name [lindex [get_pins "*"] 0]]"
# puts ""
# # foreach p [get_pins "*"] {
# #   puts "pin name: [get_name $p]"
# # }

# foreach i [get_nets -hier *] {puts "pin name: [get_name $i]"}

# foreach i [get_nets -hier "serializer_inst.tree_inst.gen_tree.mux_loop\[0\].mux_1*"] {
#   puts "net: $i"
#   puts "net name: [get_name $i]"
#   foreach j [get_pins -of_objects $i] {
#     puts "pin: $j"
#     puts "pin name: [get_name $j]"
#   }
# }
# 
# puts [get_pins "serializer_inst/dest_clk_i"]
# puts [get_pins "serializer_inst.dest_clk_i"]
# puts [get_pins serializer_inst/dest_clk_i]
# puts [get_pins -hsc "/" "serializer_inst/dest_clk_i"]
# puts [get_pins "\\serializer_inst/dest_clk_i"]
# puts [get_pins "mp_serializer_top/serializer_inst/dest_clk_i"]
# puts [get_pins "\\mp_serializer_top/serializer_inst/dest_clk_i"]

# puts [get_pins "serializer_inst/tree_inst/clk_i"]
# puts [get_pins "serializer_inst/tree_inst/mux_loop\[0\].mux_i/clk_i"]

# Loop with each mux instance known...
# Depth of the tree
# set DEPTH 8
# for {set d 0} {$d < $DEPTH} {incr d} {
#   puts "Depth $d muxes: ///////////////////////////////////"
#   set path_start "serializer_inst/tree_inst/[string repeat {gen_tree.ser_tree_inst/} $d]gen_tree.mux_loop"
#   # TODO: calculate max
#   for {set i 0} {$i < 1} {incr i} {
#     set mux_inst $path_start\[$i\].mux_1
#     puts "Constraining clocks from Instance: $mux_inst"
#     # 0* clock
#     create_generated_clock -name "gen_clk_d$d\_i$i"  -source [get_pins $mux_inst/clk_i] -edges {1 3 5} [get_pins $mux_inst/clk_ds_phases_o\[0\] ]
#     # 90* clock
#     create_generated_clock -name "gen_clk_d$d\_i$i"  -source [get_pins $mux_inst/clk_i] -edges {2 4 6} [get_pins $mux_inst/clk_ds_phases_o\[1\] ]
#     incr i
#   }
# }

# Input clock is from depth 1
# set_input_delay 2.0 -max -clock [get_clocks gen_clk_d1_i0] [get_ports data_i]
# set_input_delay 0.0 -min -clock [get_clocks gen_clk_d1_i0] [get_ports data_i]




# puts "cells = [help get_cells ]"
# puts "ALL CELLS: ///////////////////"
# puts "cells = [get_cells -hierarchical]"

# for {set d 0} {$d < $DEPTH} {incr d} {
#   # set mux_list [get_db hinsts "serializer_inst/tree_inst/[string repeat {gen_tree.ser_tree_inst/} $d]gen_tree.mux_loop\[*\].mux_1"]
#   set mux_list [get_cells -hierarchical -regexp \
#       "serializer_inst/tree_inst/[string repeat {gen_tree.ser_tree_inst/} $d]gen_tree.mux_loop\[*\].mux_1"]
  
#   puts "Depth $d muxes: ///////////////////////////////////"
#   set i 0
#   foreach mux_inst $mux_list {
#     puts "Constraining clocks from Instance: $mux_inst"
#     # 0* clock
#     create_generated_clock -name "gen_clk_d$d\_i$i"  -source [get_pins $mux_inst/clk_i] -edges {1 3 5} [get_pins $mux_inst/clk_ds_phases_o\[0\] ]
#     # 90* clock
#     create_generated_clock -name "gen_clk_d$d\_i$i"  -source [get_pins $mux_inst/clk_i] -edges {2 4 6} [get_pins $mux_inst/clk_ds_phases_o\[1\] ]
#     incr i
#   }
# }
# 
# # Input clock is from depth 1
# set_input_delay 2.0 -max -clock [get_clocks gen_clk_d1_i0] [get_ports data_i]
# set_input_delay 0.0 -min -clock [get_clocks gen_clk_d1_i0] [get_ports data_i]
