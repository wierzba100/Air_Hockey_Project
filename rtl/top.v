`timescale 1 ns / 1 ps

//top module***************************************************************************/
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
    
    
//wires********************************************************************************/
  wire [11:0] vcount_out [4:0], hcount_out [4:0];
  wire [4:0] hsync_out, vsync_out;
  wire [4:0] hblnk_out, vblnk_out;
  wire clk_out_100MHz, locked, clk_out_65MHz;
  wire [11:0] rgb_out[4:0];
  wire [11:0] pixel_addr, rgb;
  wire [11:0] xpos[2:0],ypos[2:0], xpos_ball, ypos_ball;
  wire rst_delay;
  wire [7:0] radius_player_1;
  
  //Parameters
  localparam BALL_RADIUS = 10;
  localparam BALL_COLOR = 12'ha_b_c;
  localparam PLAYERS_RADIUS = 20;
  localparam PLAYER_1_COLOR = 12'hf_0_0;
  localparam PLAYER_2_COLOR = 12'h0_0_b;

  //clock module---------------------------------------------------/  
  clk_wiz_0 u_clk_wiz_0 (
    //input
    .clk_in(clk),
    .reset(rst),
    //output
    .clk_out_100MHz(clk_out_100MHz),
    .clk_out_65MHz(clk_out_65MHz),
    .locked(locked)
  );
  
  //ODDR module---------------------------------------------------/    
  ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(clk_out_65MHz),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
  );

//reset-delay module------------------------------------------------/  
reset_delay u_reset_delay (
    .locked(locked),
    .clk(clk_out_65MHz),
    .rst_out(rst_delay)
    );
   
//mouse control module------------------------------------------------/   
MouseCtl my_MouseCtl(
  .ps2_clk(PS2Clk),
  .ps2_data(PS2Data),
  .clk(clk_out_100MHz),
  .xpos(xpos[0]),
  .ypos(ypos[0]),
  .rst(rst)
  );
  
//clock-delay module------------------------------------------------/   
clock_delay u_clock_delay (
  .clk(clk_out_65MHz),
  .rst(rst_delay),
  .xpos_in(xpos[0]),
  .ypos_in(ypos[0]),
  .xpos_out(xpos[1]),
  .ypos_out(ypos[1])
  );
  
//timing module------------------------------------------------/  
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
  
//background load module--------------------------------------/   
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

//ROM module------------------------------------------------/   
image_rom my_image_rom(
  .clk(clk_out_65MHz),
  .address(pixel_addr),
  .rgb(rgb)
  );

//drawing playground module---------------------------------/    
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
    
    /*draw_circle_ctl u_draw_circle_ctl (
      //input
      .clk(clk_out_65MHz),
      .rst(rst),
      .mouse_xpos(xpos[0]),
      .mouse_ypos(ypos[0]),
      //output
      .xpos(xpos[1]),
      .ypos(ypos[1])
  );*/
    
    
    draw_circle
    #(
        .COLOR(PLAYER_1_COLOR),
        .RADIUS(PLAYERS_RADIUS)
    )
    u_draw_circle_player1 (
        //input
        .clk_in(clk_out_65MHz),
        .rst(rst_delay),
        .hcount_in(hcount_out[2]),
        .hsync_in(hsync_out[2]),
        .hblnk_in(hblnk_out[2]),
        .vcount_in(vcount_out[2]),
        .vsync_in(vsync_out[2]),
        .vblnk_in(vblnk_out[2]),
        .rgb_in(rgb_out[1]),
        .xpos_in(xpos[1]),
        .ypos_in(ypos[1]),
        //output
        .hcount_out(hcount_out[3]),
        .hsync_out(hsync_out[3]),
        .hblnk_out(hblnk_out[3]),
        .vcount_out(vcount_out[3]),
        .vsync_out(vsync_out[3]),
        .vblnk_out(vblnk_out[3]),
        .rgb_out(rgb_out[2]),
        .xpos_out(xpos[2]),
        .ypos_out(ypos[2])
      );
    
      draw_ball_ctl
      #(
          .RADIUS_BALL(BALL_RADIUS),
          .PLAYERS_RADIUS(PLAYERS_RADIUS)
      )
      u_draw_ball_ctl (
      //input
      .clk_in(clk_out_65MHz),
      .rst(rst_delay),
      .xpos_player_1(xpos[2]),
      .ypos_player_1(ypos[2]),
      //output
      .xpos_ball(xpos_ball),
      .ypos_ball(ypos_ball)
    );
    
      draw_ball
      #(
          .COLOR(BALL_COLOR),
          .RADIUS_BALL(BALL_RADIUS)
      )
      u_draw_ball (
      //input
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
      //output
      .hcount_out(hcount_out[4]),
      .hsync_out(hsync_out[4]),
      .hblnk_out(hblnk_out[4]),
      .vcount_out(vcount_out[4]),
      .vsync_out(vsync_out[4]),
      .vblnk_out(vblnk_out[4]),
      .rgb_out(rgb_out[3])
    );
    
    

always@*
begin
    vs = vsync_out[4];
    hs = hsync_out[4];
    {r, g, b} = rgb_out[3];
    end


endmodule
