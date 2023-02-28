
module mp_serializer_tb;

  localparam width_p = 16;
  // localparam els_p = 4;
  localparam els_p = 256;

  logic clk;
  logic slow_clk;
  logic[15:0] data_in[els_p-1:0];
  logic[15:0] data_out;
  logic dut_v_i, dut_v_o;



  /* Dump Test Waveform To VPD File */
  initial begin
    $fsdbDumpfile("waveform.fsdb");
    $fsdbDumpvars();

    dut_v_i = 0;
    repeat (2) @(posedge slow_clk);

    @(posedge slow_clk) 
    dut_v_i = 1;
    // data_in[0] = 4'hA;
    // data_in[1] = 4'hB;
    // data_in[2] = 4'hC;
    // data_in[3] = 4'hD;
    // data_in[4] = 4'h0;
    // data_in[5] = 4'h1;
    // data_in[6] = 4'h2;
    // data_in[7] = 4'h3;
    for(int i=0; i<els_p; i++) data_in[i] = i+1000;

    @(posedge slow_clk) 
    dut_v_i = 0;
    // data_in[0] = 4'hX;
    // data_in[1] = 4'hX;
    // data_in[2] = 4'hX;
    // data_in[3] = 4'hX;
    // data_in[4] = 4'hX;
    // data_in[5] = 4'hX;
    // data_in[6] = 4'hX;
    // data_in[7] = 4'hX;
    for(int i=0; i<els_p; i++) data_in[i] = 'x;

    repeat (20) @(posedge slow_clk);
    $finish;
  end

  /* Non-synth clock generator */
  bsg_nonsynth_clock_gen #(5000) clk_gen_1 (clk);

  /* Non-synth reset generator */
  logic reset;
  bsg_nonsynth_reset_gen #(.num_clocks_p(1),.reset_cycles_lo_p(5),. reset_cycles_hi_p(20))
    reset_gen
      (.clk_i        ( clk )
      ,.async_reset_o( reset )
      );

  logic[15:0] d0, d1, d2, d3, d4, d5, d6, d7;
  assign d0 = data_in[0];
  assign d1 = data_in[1];
  assign d2 = data_in[2];
  assign d3 = data_in[3];
  assign d4 = data_in[4];
  assign d5 = data_in[5];
  assign d6 = data_in[6];
  assign d7 = data_in[7];

  logic[els_p*width_p-1:0] dut_data_li;
  for (genvar j = 0; j<els_p; j++) begin : input_array_flatten
    assign dut_data_li[((j+1)*width_p-1) : (j*width_p)] = data_in[j];
  end


  mp_serializer #(.width_p(width_p), .els_p(els_p))
    DUT
    (.src_clk_o(slow_clk)
    ,.v_i(dut_v_i)
    ,.data_i(dut_data_li)
    // ,.data_i(data_in[els_p-1:0])
    ,.dest_clk_i(clk)
    ,.dest_rst_i(reset)
    ,.v_o(dut_v_o)
    ,.data_o(data_out)
    );


endmodule
