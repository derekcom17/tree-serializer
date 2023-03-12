
module top_tb;

  logic clk;
  logic slow_clk;
  logic [255:0]data_in;
  logic data_out;
  logic dut_v_i, dut_v_o;



  /* Dump Test Waveform To VPD File */
  initial begin
    $fsdbDumpfile("waveform.fsdb");
    $fsdbDumpvars();

    dut_v_i = 0;
    repeat (2) @(posedge slow_clk);

    for (int j=0; j<100; j++) begin
      @(posedge slow_clk);
      dut_v_i = 1;
      for (int i=0; i<8; i++) data_in[32*i+:32] = $random;
      $display("Sending data %0d", j);
    end

    dut_v_i = 0;
    data_in = 'x;
    repeat (10) @(posedge slow_clk);
    $finish;
  end

  /* Non-synth clock generator */
  bsg_nonsynth_clock_gen #(6000) clk_gen_1 (clk);

  /* Non-synth reset generator */
  logic reset;
  bsg_nonsynth_reset_gen #(.num_clocks_p(1),.reset_cycles_lo_p(5),. reset_cycles_hi_p(20))
    reset_gen
      (.clk_i        ( clk )
      ,.async_reset_o( reset )
      );

  mp_serializer_top DUT (
    .clk_i(clk)
    ,.reset_i(reset)
    ,.data_i(data_in)
    ,.clk_o(slow_clk)
    ,.data_o(data_out)
  );


endmodule
