`timescale 1ns / 1ps

module draw_ball
#( parameter
    COLOR = 12'ha_b_c,
    RADIUS_BALL = 10
)
(
    input wire clk_in,
    input wire rst,
    input wire [11:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [11:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] rgb_in,
    input wire [11:0] xpos_ball,
    input wire [11:0] ypos_ball,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out
);
    
    reg [11:0] rgb_nxt;
    
    always@*
    begin
        if( ( ( hcount_in - xpos_ball ) * ( hcount_in - xpos_ball ) ) + ( ( vcount_in - ypos_ball ) * ( vcount_in - ypos_ball ) ) <= RADIUS_BALL * RADIUS_BALL )
            rgb_nxt = COLOR;
        else
            rgb_nxt = rgb_in;
    end
    
    always @(posedge clk_in)
    begin
        if(rst)
        begin
            vcount_out <= 0;
            hcount_out <= 0;
            hsync_out <= 0;
            vsync_out <= 0;
            hblnk_out <= 0;
            vblnk_out <= 0;
            rgb_out <= 0;
        end
        else
        begin
            hsync_out <= hsync_in;
            vsync_out <= vsync_in;
            hblnk_out <= hblnk_in;
            vblnk_out <= vblnk_in;
            hcount_out <= hcount_in;
            vcount_out <= vcount_in;
            rgb_out <= rgb_nxt;
        end
    end
    
    
endmodule
