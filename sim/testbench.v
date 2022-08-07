// File: testbench.v
// This is a top level testbench for the
// vga_example design, which is part of
// the EE178 Lab #4 assignment.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

module testbench;

  // Declare wires to be driven by the outputs
  // of the design, and regs to drive the inputs.
  // The testbench will be in control of inputs
  // to the design, and will check the outputs.
  // Then, instantiate the design to be tested.
  reg rst;
  reg clk;
  wire pclk_mirror;
  wire vs, hs;
  wire [3:0] r, g, b;
  wire clk_94_5Mhz, locked, clk_out2, clk_out3;

  // Instantiate the vga_example module.
  
  top my_example (
    .clk(clk),
    .rst(rst),
    .vs(vs),
    .hs(hs),
    .r(r),
    .g(g),
    .b(b)
  );
   
   clk_wiz_0 u_clk_wiz_0 (
      //input
      .clk_in(clk),
      .reset(rst),
      //output
      .clk_94_5Mhz(clk_94_5Mhz),
      .clk_out2(clk_out2),
      .clk_out3(clk_out3),
      .locked(locked)
    
    );

  // Instantiate the tiff_writer module.

  tiff_writer my_writer (
    .pclk_mirror(clk_out3),
    .r({r,r}), // fabricate an 8-bit value
    .g({g,g}), // fabricate an 8-bit value
    .b({b,b}), // fabricate an 8-bit value
    .go(vs),
    .xdim(16'd1056),
    .ydim(16'd628)
  );

  // Describe a process that generates a clock
  // signal. The clock is 100 MHz.

  always
  begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
  end

  // Assign values to the input signals and
  // check the output results. This template
  // is meant to get you started, you can modify
  // it as you see fit. If you simply run it as
  // provided, you will need to visually inspect
  // the output waveforms to see if they make
  // sense...
initial
    begin
       rst = 0;
        #800 rst = 1;
        #50 rst =0;
        #2000 rst = 1;
        #50 rst =0;
        #3000 rst = 1;
               #50 rst =0;
      
    $display("If simulation ends before the testbench");
    $display("completes, use the menu option to run all.");
    $display("Prepare to wait a long time...");
    wait (vs == 1'b0);
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    // End the simulation.
    $display("Simulation is over, check the waveforms.");
  end

endmodule
