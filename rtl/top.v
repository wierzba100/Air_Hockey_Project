`timescale 1 ns / 1 ps

module top (
  input wire clk,
  input wire rst,
  output wire pclk_mirror,
  output reg vs,
  output reg hs,
  output reg [3:0] r,
  output reg [3:0] g,
  output reg [3:0] b
  );
    
    

  wire [11:0] vcount_in [2:0], hcount_in [2:0], vcount_out [2:0], hcount_out [2:0];
  wire [2:0] vsync_in, hsync_in, hsync_out, vsync_out;
  wire [2:0] vblnk_in, hblnk_in, hblnk_out, vblnk_out;
  wire [3:0] r_in [2:0],g_in [2:0],b_in [2:0], r_out [2:0],g_out [2:0],b_out [2:0];
  wire clk_94_5Mhz, locked, clk_out2, clk_out3;
  wire [11:0] rgb_out;
  
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
  
  ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(clk_out3),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
  );
  
  vga_timing u_vga_timing (
    .clk_in(clk_out3),
    .rst(rst),
    .vcount(vcount_out [0]),
    .vsync(vsync_out [0]),
    .vblnk(vblnk_out [0]),
    .hcount(hcount_out [0]),
    .hsync(hsync_out [0]),
    .hblnk(hblnk_out [0])
  );
  
  draw_background u_draw_background (
    //input
    .clk_in(clk_out3),
    .hcount_in(hcount_out [0]),
    .hsync_in(hsync_out [0]),
    .hblnk_in(hblnk_out [0]),
    .vcount_in(vcount_out [0]),
    .vsync_in(vsync_out [0]),
    .vblnk_in(vblnk_out [0]),
    //output
    .hcount_out(hcount_out [1]),
    .hsync_out(hsync_out[1]),
    .hblnk_out(hblnk_out [1]),
    .vcount_out(vcount_out [1]),
    .vsync_out(vsync_out[1]),
    .vblnk_out(vblnk_out [1]),
    .r_out(r_out[0]),
    .g_out(g_out[0]),
    .b_out(b_out[0])
  );

always@*
begin
    vs = vsync_out[1];
    hs = hsync_out[1];
    r = r_out[0];
    g = g_out[0];
    b = b_out[0];
end


endmodule
