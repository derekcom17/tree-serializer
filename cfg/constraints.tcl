# constraints.tcl
# 

# Constraints for serial clock
set_units -time ns
create_clock [get_ports clk_i]  -name serial_clock  -period 2.0

TODO: does this work?
set_disable_timing -from reset_i [get_db hinsts]

# Depth of the tree
set DEPTH 8

for {set d 0} {$d < $DEPTH} {incr d} {
  set mux_list [get_db hinsts "serializer_inst/tree_inst/[string repeat {gen_tree.ser_tree_inst/} $d]gen_tree.mux_loop\[*\].mux_1"]
  puts "Depth $d muxes: ///////////////////////////////////"
  set i 0
  foreach mux_inst $mux_list {
    puts "Constraining clocks from Instance: $mux_inst"
    # 0* clock
    create_generated_clock -name "gen_clk_d$d\_i$i"  -source [get_pins [get_db $mux_inst .name]/clk_i] -edges {1 3 5} [get_pins [get_db $mux_inst .name]/clk_ds_phases_o\[0\] ]
    # 90* clock
    create_generated_clock -name "gen_clk_d$d\_i$i"  -source [get_pins [get_db $mux_inst .name]/clk_i] -edges {2 4 6} [get_pins [get_db $mux_inst .name]/clk_ds_phases_o\[1\] ]
    # Disable reset timing TODO: why doesn't this work?
    # set_disable_timing -from reset_i -to * $mux_inst
    incr i
  }
}

# Input clock is from depth 1
set_input_delay 2.0 -max -clock [get_clocks gen_clk_d1_i0] [get_ports data_i]
set_input_delay 0.0 -min -clock [get_clocks gen_clk_d1_i0] [get_ports data_i]