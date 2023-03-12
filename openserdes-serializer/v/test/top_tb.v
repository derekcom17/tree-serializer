
module top_tb;

  logic clk;
  logic slow_clk;
  logic [255:0]data_in;
  logic data_out;
  logic dut_done, dut_v_i;



  /* Dump Test Waveform To VPD File */
  initial begin
    $fsdbDumpfile("waveform.fsdb");
    $fsdbDumpvars();

    dut_v_i = 0;
    repeat (100) @(posedge clk);

    for (int j=0; j<100; j++) begin
      @(posedge clk);
      dut_v_i = 1;
      for (int i=0; i<8; i++) data_in[32*i+:32] = $random;
      $display("Sending data %0d", j);
      @(posedge dut_done);
    end

    dut_v_i = 0;
    data_in = 'x;
    repeat (10) @(posedge clk);
    $finish;
  end

  /* Non-synth clock generator */
  bsg_nonsynth_clock_gen #(3000) clk_gen_1 (clk);

  /* Non-synth reset generator */
  logic reset;
  bsg_nonsynth_reset_gen #(.num_clocks_p(1),.reset_cycles_lo_p(5),. reset_cycles_hi_p(20))
    reset_gen
      (.clk_i        ( clk )
      ,.async_reset_o( reset )
      );

  openserdes_serializer DUT (
    .CLK(clk)
    ,.RESET(~reset) // active low reset
    ,.SERIAL_OUT(data_out)
    ,.READY(dut_v_i) // (valid input)
    ,.INTERNAL_FINISH() // ignore
    ,.COMPLETE(dut_done) // ignore
    ,.PAR_IN1(data_in[ 31:  0])
    ,.PAR_IN2(data_in[ 63: 32])
    ,.PAR_IN3(data_in[ 95: 64])
    ,.PAR_IN4(data_in[127: 96])
    ,.PAR_IN5(data_in[159:128])
    ,.PAR_IN6(data_in[191:160])
    ,.PAR_IN7(data_in[223:192])
    ,.PAR_IN8(data_in[255:224])
    ,.COUNT() // ignore
    ,.SAMPLE_COUNT() // ignore
  );

endmodule
