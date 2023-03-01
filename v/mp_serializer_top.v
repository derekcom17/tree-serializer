
module mp_serializer_top (
  input clk_i,
  input reset_i,
  input[255:0] data_i,
  output clk_o,
  output data_o
  );
    
  // Similar to OpenSERDES serializer, register inputs.
  // However, we should use the slow clock instead of the output serial clock
  logic[255:0] data_li;
  always_ff @(posedge clk_o or posedge reset_i) begin
    if(reset_i) data_li <= '0;
    else        data_li <= data_i;
  end

  mp_serializer #(.width_p(1), .els_p(256))
    serializer_inst
    (.src_clk_o(clk_o)
    ,.data_i(data_li)
    ,.v_i()
    ,.dest_clk_i(clk_i)
    ,.dest_rst_i(reset_i)
    ,.v_o()
    ,.data_o(data_o)
    );

endmodule
