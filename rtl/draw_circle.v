//autor:FW

`timescale 1ns / 1ps

module draw_circle
#( parameter
    COLOR = 12'hf_f_f,
    RADIUS = 20
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
    input wire [11:0] xpos_in,
    input wire [11:0] ypos_in,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out,
    output reg [11:0] xpos_out,
    output reg [11:0] ypos_out
    );
    
    reg [11:0] rgb_nxt,rgb_nxt1;
    
    always@*
    begin
        if( ( ( hcount_in - xpos_in ) * ( hcount_in - xpos_in ) ) + ( ( vcount_in - ypos_in ) * ( vcount_in - ypos_in ) ) <= RADIUS * RADIUS )
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
            xpos_out <= 0;
            ypos_out <= 0;
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
            rgb_nxt1<= rgb_nxt;
            rgb_out <= rgb_nxt1;
            xpos_out <= xpos_in;
            ypos_out <= ypos_in;
        end
    end
           
    
    
endmodule
