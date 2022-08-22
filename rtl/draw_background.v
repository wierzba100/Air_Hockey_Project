`timescale 1ns / 1ps

module draw_background(
    input wire clk_in,
    input wire [11:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [11:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out
    );
    
    always @(posedge clk_in)
    begin
    // Just pass these through.
        hsync_out <= hsync_in;
        vsync_out <= vsync_in;
        hblnk_out <= hblnk_in;
        vblnk_out <= vblnk_in;
        hcount_out <= hcount_in;
        vcount_out <= vcount_in;
        
        // During blanking, make it it black.
        if (vblnk_out || hblnk_out) rgb_out <= 12'h0_0_0; 
        else
        begin
          // Active display, top edge, make a yellow line.
          if (vcount_out == 0) rgb_out <= 12'hf_f_0;
          // Active display, bottom edge, make a red line.
          else if (vcount_out == 767) rgb_out <= 12'hf_0_0;
          // Active display, left edge, make a green line.
          else if (hcount_out == 0) rgb_out <= 12'h0_f_0;
          // Active display, right edge, make a blue line.
          else if (hcount_out == 1023) rgb_out <= 12'h0_0_f;
          // Active display, interior, fill with gray.
          else rgb_out <= 12'h8_8_8;
       end
    end
    
    
endmodule

