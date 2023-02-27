`include "bsg_defines.v"

module mp_mux_2 #(parameter width_p=16) (
   input  logic clk_i
  ,input  logic reset_i
  ,input  logic[2*width_p-1:0] data_i
  ,output logic[1:0] clk_ds_phases_o
  ,output logic [width_p-1:0] data_o
);
  
  // 0* phase clock 
  always_ff @(posedge clk_i or posedge reset_i) 
    if (reset_i) clk_ds_phases_o[0] <= 1'b0;
    else clk_ds_phases_o[0] <= ~clk_ds_phases_o[0];

  // 90* phase clock
  always_ff @(negedge clk_i or posedge reset_i) 
    if (reset_i) clk_ds_phases_o[1] <= 1'b0;
    else clk_ds_phases_o[1] <= ~clk_ds_phases_o[1];
  
  assign data_o = clk_i ? data_i[width_p-1:0] : data_i[2*width_p-1:width_p];

endmodule

module ser_tree #(parameter width_p=16
                 ,parameter els_p=1
                 )
  (input logic clk_i
  ,input logic reset_i
  ,input logic[(width_p*els_p)-1:0] data_i
  ,output logic[els_p-1:0] phase_clk_o
  ,output logic short_clk_o
  ,output logic[width_p-1:0] data_o
);

  // Recursion base case: send input to output
  if (els_p==1) begin : gen_1

    assign data_o = data_i;
    assign phase_clk_o = clk_i;
    assign short_clk_o = 1'b0;

  // Recursive case: generate els_p/2 2-to-1 muxes and pass the results 
  // to a tree of size els_p/2
  end else begin : gen_tree
    logic[(width_p*els_p/2)-1:0] tree_li;
    logic[els_p/2-1:0] tree_clks_lo;

    genvar i;
    for (i = 0; i<(els_p/2); i++) begin : mux_loop
      mp_mux_2 #(.width_p(width_p))
        mux_1
        (.clk_i(tree_clks_lo[i])
        ,.reset_i(reset_i)
        ,.data_i(data_i[ (2*(i+1)*width_p)-1 : (2*i*width_p) ])
        ,.clk_ds_phases_o(phase_clk_o[2*i+1 : 2*i])
        ,.data_o(tree_li[(i+1)*width_p-1 : i*width_p])
        );      
    end
      
    // Recurse!
    ser_tree #(.width_p(width_p), .els_p(els_p/2) )
      ser_tree_inst
      (.clk_i(clk_i)
      ,.reset_i(reset_i)
      ,.data_i(tree_li)
      ,.phase_clk_o(tree_clks_lo)
      ,.short_clk_o() // Unused
      ,.data_o(data_o)
      );

    // Forward the 0* clock from the level before
    // (only used at the top level)
    assign short_clk_o = tree_clks_lo[0];

  end
  

endmodule

function integer bit_rev(integer i, integer numbits); begin
  // integer bit_rev;
  int idx;
  for (idx=0; idx<numbits; idx++) begin
    bit_rev = (bit_rev << 1) | (i & 1);
    i = i >> 1;
  end
  // return bit_rev; // Invalid is '05 Verilog
end endfunction

module mp_serializer #(parameter width_p=16
                      ,parameter els_p=4
                      ) 
  (
   output logic src_clk_o // Slow parallel clock
  ,input logic[(width_p*els_p)-1:0] data_i
  ,input logic v_i
  
  ,input logic dest_clk_i // Fast serial clock
  ,input logic dest_rst_i
  ,output logic v_o
  ,output logic[width_p-1:0] data_o // Double comes out with dest_clk_i (DDR)
);
  logic[els_p-1:0] phase_clk_lo;
  logic[(width_p*els_p)-1:0] data_li;

  for(genvar j=0; j<els_p; j++) begin : input_bit_rev_gen
    wire[`BSG_SAFE_CLOG2(els_p)-1:0] index = bit_rev(j, `BSG_SAFE_CLOG2(els_p));
    assign data_li[(j+1)*width_p-1 : j*width_p] = data_i[index*width_p +: width_p];
  end
  
  ser_tree #(.width_p(width_p), .els_p(els_p))
    tree_inst
    (.clk_i(dest_clk_i)
    ,.reset_i(dest_rst_i)
    ,.data_i(data_li)
    ,.phase_clk_o(phase_clk_lo)
    ,.short_clk_o(src_clk_o)
    ,.data_o(data_o)
    );
  
  assign v_o = v_i;

endmodule
