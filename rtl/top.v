`timescale 1 ns / 1 ps

//top module------------------------------------------------------------------------------------------------------------------------------------------------------------------------/
module top (
  input wire clk,
  input wire rst,
  input wire [7:0] JB,
  input wire [7:0] JC,
  input wire [7:0] JA,
  output wire vs,
  output wire hs,
  output wire [3:0] r,
  output wire [3:0] g,
  output wire [3:0] b,
  output wire [3:0] an,
  output wire [7:0] sseg,
  inout PS2Clk,
  inout PS2Data
  );
 
//wires----------------------------------------------------------------------------------------------------------------------------------------------------------------------------/
  wire [11:0] vcount_out [4:0], hcount_out [4:0];
  wire [3:0] hsync_out, vsync_out;
  wire [4:0] hblnk_out, vblnk_out;
  wire clk_out_130MHz, locked, clk_out_65MHz;
  wire [11:0] rgb, rgb_out[2:0];
  wire [11:0] pixel_addr;
  wire [11:0] xpos_player1[2:0], ypos_player1[2:0], xpos_player2[2:0], ypos_player2[2:0], xpos_ball, ypos_ball;
  wire rst_delay;
  wire [3:0] player_1_score, player_2_score;
  wire pclk_mirror;
    
//local parameters---------------------------------------------------------------------------------------------------------------------------------------------------------------/
  localparam BALL_RADIUS = 10;
  localparam BALL_COLOR = 12'ha_b_c;
  localparam PLAYERS_RADIUS = 20;
  localparam PLAYER_1_COLOR = 12'hf_0_0;
  localparam PLAYER_2_COLOR = 12'h0_0_b;

//clock module------------------------------------------------------------------------------------------------------------------------------------------------------------------/  
clk_wiz_0 u_clk_wiz_0 (
  .clk_in1(clk),
  .reset(rst),
  .clk_out_130MHz(clk_out_130MHz),
  .clk_out_65MHz(clk_out_65MHz),
  .locked(locked)
  );
  
//ODDR module-------------------------------------------------------------------------------------------------------------------------------------------------------------------------/    
ODDR pclk_oddr (
  .Q(pclk_mirror),
  .C(clk_out_65MHz),
  .CE(1'b1),
  .D1(1'b1),
  .D2(1'b0),
  .R(1'b0),
  .S(1'b0)
  );

//reset-delay module------------------------------------------------------------------------------------------------------------------------------------------------------------------/  
reset_delay u_reset_delay (
  .locked(locked),
  .clk(clk_out_65MHz),
  .rst_out(rst_delay)
  );
   
//mouse control module---------------------------------------------------------------------------------------------------------------------------------------------------------------/   
MouseCtl my_MouseCtl(
  .ps2_clk(PS2Clk),
  .ps2_data(PS2Data),
  .clk(clk_out_130MHz),
  .xpos(xpos_player1[0]),
  .ypos(ypos_player1[0]),
  .rst(rst)
  );
  
//clock-delay module---------------------------------------------------------------------------------------------------------------------------------------------------------------/   
clock_delay u_clock_delay (
  .clk(clk_out_65MHz),
  .rst(rst_delay),
  .xpos_in_player1(xpos_player1[0]),
  .ypos_in_player1(ypos_player1[0]),
  .JA(JA),
  .JB(JB),
  .JC(JC),
  .xpos_out_player1(xpos_player1[1]),
  .ypos_out_player1(ypos_player1[1]),
  .xpos_out_player2(xpos_player2[1]),
  .ypos_out_player2(ypos_player2[1])
  );
  
//timing module--------------------------------------------------------------------------------------------------------------------------------------------------------------/  
vga_timing u_vga_timing (
   .clk_in(clk_out_65MHz),
   .rst(rst_delay),
   .vcount(vcount_out[0]),
   .vsync(vsync_out[0]),
   .vblnk(vblnk_out[0]),
   .hcount(hcount_out[0]),
   .hsync(hsync_out[0]),
   .hblnk(hblnk_out[0])
   );
  
//background load module-----------------------------------------------------------------------------------------------------------------------------------------------------/   
draw_background u_draw_background (
  .clk_in(clk_out_65MHz),
  .hcount_in(hcount_out[0]),
  .hsync_in(hsync_out[0]),
  .hblnk_in(hblnk_out[0]),
  .vcount_in(vcount_out[0]),
  .vsync_in(vsync_out[0]),
  .vblnk_in(vblnk_out[0]),
  .hcount_out(hcount_out[1]),
  .hsync_out(hsync_out[1]),
  .hblnk_out(hblnk_out[1]),
  .vcount_out(vcount_out[1]),
  .vsync_out(vsync_out[1]),
  .vblnk_out(vblnk_out[1]),
  .rgb_out(rgb_out[0]),
  .pixel_addr(pixel_addr),
  .rgb_pixel(rgb)
  );

//ROM module---------------------------------------------------------------------------------------------------------------------------------------------------------------/   
image_rom my_image_rom(
  .clk(clk_out_65MHz),
  .address(pixel_addr),
  .rgb(rgb)
  );

//drawing playground module------------------------------------------------------------------------------------------------------------------------------------------------/    
draw_playground u_draw_playground(
  .clk_in(clk_out_65MHz),
  .hcount_in(hcount_out[1]),
  .hsync_in(hsync_out[1]),
  .hblnk_in(hblnk_out[1]),
  .vcount_in(vcount_out[1]),
  .vsync_in(vsync_out[1]),
  .vblnk_in(vblnk_out[1]),
  
  .hcount_out(hcount_out[2]),
  .hsync_out(hsync_out[2]),
  .hblnk_out(hblnk_out[2]),
  .vcount_out(vcount_out[2]),
  .vsync_out(vsync_out[2]),
  .vblnk_out(vblnk_out [2]),
  .rgb_out(rgb_out[1]),
  .rgb_in(rgb_out[0])
  );
 
//drawing circle module--------------------------------------------------------------------------------------------------------------------------------------------------/      
draw_circle#(
  .COLOR_PLAYER1(PLAYER_1_COLOR),
  .COLOR_PLAYER2(PLAYER_2_COLOR),
  .RADIUS(PLAYERS_RADIUS)
  ) 
u_draw_players (
  .clk_in(clk_out_65MHz),
  .rst(rst_delay),
  .hcount_in(hcount_out[2]),
  .hsync_in(hsync_out[2]),
  .hblnk_in(hblnk_out[2]),
  .vcount_in(vcount_out[2]),
  .vsync_in(vsync_out[2]),
  .vblnk_in(vblnk_out[2]),
  .rgb_in(rgb_out[1]),
  .xpos_in_player1(xpos_player1[1]),
  .ypos_in_player1(ypos_player1[1]),
  .xpos_in_player2(xpos_player2[1]),
  .ypos_in_player2(ypos_player2[1]),
  .hcount_out(hcount_out[3]),
  .hsync_out(hsync_out[3]),
  .hblnk_out(hblnk_out[3]),
  .vcount_out(vcount_out[3]),
  .vsync_out(vsync_out[3]),
  .vblnk_out(vblnk_out[3]),
  .rgb_out(rgb_out[2]),
  .xpos_out_player1(xpos_player1[2]),
  .ypos_out_player1(ypos_player1[2]),
  .xpos_out_player2(xpos_player2[2]),
  .ypos_out_player2(ypos_player2[2])
  );

//drawing ball control module---------------------------------------------------------------------------------------------------------------------------------------------/         
draw_ball_ctl#(
  .RADIUS_BALL(BALL_RADIUS),
  .PLAYERS_RADIUS(PLAYERS_RADIUS)
  )
u_draw_ball_ctl (
  .clk_in(clk_out_65MHz),
  .rst(rst_delay),
  .xpos_player_1(xpos_player1[2]),
  .ypos_player_1(ypos_player1[2]),
  .xpos_player_2(xpos_player2[2]),
  .ypos_player_2(ypos_player2[2]),
  .xpos_ball(xpos_ball),
  .ypos_ball(ypos_ball),
  .player_1_score(player_1_score),
  .player_2_score(player_2_score)
  );
 
 //drawing ball  module-------------------------------------------------------------------------------------------------------------------------------------------------------/            
draw_ball#(
  .COLOR(BALL_COLOR),
  .RADIUS_BALL(BALL_RADIUS)
   )
u_draw_ball (
  .clk_in(clk_out_65MHz),
  .rst(rst_delay),
  .hcount_in(hcount_out[3]),
  .hsync_in(hsync_out[3]),
  .hblnk_in(hblnk_out[3]),
  .vcount_in(vcount_out[3]),
  .vsync_in(vsync_out[3]),
  .vblnk_in(vblnk_out[3]),
  .rgb_in(rgb_out[2]),
  .xpos_ball(xpos_ball),
  .ypos_ball(ypos_ball),
  .hcount_out(hcount_out[4]),
  .hsync_out(hs),
  .hblnk_out(hblnk_out[4]),
  .vcount_out(vcount_out[4]),
  .vsync_out(vs),
  .vblnk_out(vblnk_out[4]),
  .rgb_out({r, g, b})
  );
 
 //display score module---------------------------------------------------------------------------------------------------------------------------------------------------/               
disp_hex_mux u_disp_hex_mux (
  .clk(clk_out_65MHz),
  .reset(rst_delay),
  .hex0(player_2_score),
  .hex1(1'b0),
  .hex2(player_1_score),
  .hex3(1'b0),
  .dp_in(4'b1011),
  .an(an),
  .sseg(sseg)
  );
    
endmodule
