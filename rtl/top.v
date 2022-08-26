`timescale 1 ns / 1 ps

module top (
  input wire clk,
  input wire rst,
  output wire pclk_mirror,
  output reg vs,
  output reg hs,
  output reg [3:0] r,
  output reg [3:0] g,
  output reg [3:0] b,
  inout PS2Clk,
  inout PS2Data
  );
    
    

  wire [11:0] vcount_out [3:0], hcount_out [3:0];
  wire [3:0] hsync_out, vsync_out;
  wire [3:0] hblnk_out, vblnk_out;
  wire clk_94_5Mhz, locked, clk_out2, clk_out3;
  wire [11:0] rgb_out[3:0];
  wire [11:0] xpos[2:0],ypos[2:0], ball_xpos, ball_ypos;
  wire rst_delay;
  wire [7:0] radius_player_1;
  
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
  
    reset_delay u_reset_delay (
      //input
      .locked(locked),
      .clk(clk_out3),
      //output
      .rst_out(rst_delay)
    );
  
  MouseCtl u_MouseCtl (
      //input
      .clk(clk_94_5Mhz),
      .rst(rst_delay),
      //inout
      .ps2_clk(PS2Clk),
      .ps2_data(PS2Data),
      //output
      .xpos(xpos[0]),
      .ypos(ypos[0])
  );
  
  clock_delay u_clock_delay (
      //input
      .clk(clk_out3),
      .rst(rst_delay),
      .xpos_in(xpos[0]),
      .ypos_in(ypos[0]),
      //output
      .xpos_out(xpos[1]),
      .ypos_out(ypos[1])
  );
  
  vga_timing u_vga_timing (
    .clk_in(clk_out3),
    .rst(rst_delay),
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
    .rgb_out(rgb_out [1])
  );
    
    /*draw_circle_ctl u_draw_circle_ctl (
      //input
      .clk(clk_out3),
      .rst(rst),
      .mouse_xpos(xpos[0]),
      .mouse_ypos(ypos[0]),
      //output
      .xpos(xpos[1]),
      .ypos(ypos[1])
  );*/
    
    
    draw_circle
    #(
        .COLOR(12'hf_f_f),
        .RADIUS(20)
    )
    u_draw_circle_player1 (
        //input
        .clk_in(clk_out3),
        .rst(rst_delay),
        .hcount_in(hcount_out[1]),
        .hsync_in(hsync_out[1]),
        .hblnk_in(hblnk_out[1]),
        .vcount_in(vcount_out[1]),
        .vsync_in(vsync_out[1]),
        .vblnk_in(vblnk_out[1]),
        .rgb_in(rgb_out[1]),
        .xpos(xpos[0]),
        .ypos(ypos[0]),
        //output
        .hcount_out(hcount_out[2]),
        .hsync_out(hsync_out[2]),
        .hblnk_out(hblnk_out[2]),
        .vcount_out(vcount_out[2]),
        .vsync_out(vsync_out[2]),
        .vblnk_out(vblnk_out[2]),
        .rgb_out(rgb_out[2]),
        .radius_player(radius_player_1)
      );
    
  draw_ball_ctl
  #(
      .COLOR(12'ha_b_c),
      .RADIUS(10)
  )
  u_draw_ball_ctl (
      //input
      .clk_in(clk_out3),
      .rst(rst_delay),
      .hcount_in(hcount_out[2]),
      .hsync_in(hsync_out[2]),
      .hblnk_in(hblnk_out[2]),
      .vcount_in(vcount_out[2]),
      .vsync_in(vsync_out[2]),
      .vblnk_in(vblnk_out[2]),
      .rgb_in(rgb_out[2]),
      .xpos(xpos[1]),
      .ypos(ypos[1]),
      .radius_player(radius_player_1),
      //output
      .hcount_out(hcount_out[3]),
      .hsync_out(hsync_out[3]),
      .hblnk_out(hblnk_out[3]),
      .vcount_out(vcount_out[3]),
      .vsync_out(vsync_out[3]),
      .vblnk_out(vblnk_out[3]),
      .rgb_out(rgb_out[3])
    );
    
    

always@*
begin
    vs = vsync_out[3];
    hs = hsync_out[3];
    {r, g, b} = rgb_out[3];
end


endmodule
