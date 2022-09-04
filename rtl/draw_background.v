`timescale 1ns / 1ps

module draw_background(
//inputs
  input wire clk_in,
  input wire [11:0] hcount_in,
  input wire hsync_in,
  input wire hblnk_in,
  input wire [11:0] vcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire [11:0] rgb_pixel,
//outputs
  output reg [11:0] hcount_out,
  output reg hsync_out,
  output reg hblnk_out,
  output reg [11:0] vcount_out,
  output reg vsync_out,
  output reg vblnk_out,
  output reg [11:0] rgb_out,
  output [11:0] pixel_addr
  );
    
//wires
  wire [5:0] addr_x, addr_y;
   
//registers
  reg hsync_nxt, vsync_nxt, hblnk_nxt, vblnk_nxt;
    
//logic
  always @(posedge clk_in)
      begin
        hsync_out <= hsync_nxt;
        vsync_out <= vsync_nxt;
        hblnk_out <= hblnk_nxt;
        vblnk_out <= vblnk_nxt;
        hcount_out <= hcount_in;
        vcount_out <= vcount_in;
        hsync_nxt  <=  hsync_in;
        vsync_nxt  <=  vsync_in;
        hblnk_nxt  <=  hblnk_in;
        vblnk_nxt  <=  vblnk_in;
        rgb_out <= rgb_pixel;  //background uploading
      end 
       
//assigns      
  assign addr_y = vcount_out;
  assign addr_x = hcount_out;
  assign pixel_addr = {addr_y[5:0],addr_x[5:0]};        
        
endmodule

