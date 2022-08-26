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
    input wire [11:0] xpos,
    input wire [11:0] ypos,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out
    );
    
    reg [11:0] rgb_nxt_1, rgb_nxt_2, rgb_nxt_3;
    reg [11:0] vcount_nxt_1, hcount_nxt_1, vcount_nxt_2, hcount_nxt_2;
    reg hsync_nxt_1, vsync_nxt_1, hblnk_nxt_1, vblnk_nxt_1, hsync_nxt_2, vsync_nxt_2, hblnk_nxt_2, vblnk_nxt_2;
    
    always@*
    begin
        if( ( ( hcount_in - xpos ) * ( hcount_in - xpos ) ) + ( ( vcount_in - ypos ) * ( vcount_in - ypos ) ) <= RADIUS * RADIUS )
            rgb_nxt_1 = COLOR;
        else
            rgb_nxt_1 = rgb_in;

    end
    
    always @(posedge clk_in)
    begin
        if(rst)
        begin
            vcount_nxt_1 <= 0;
            hcount_nxt_1 <= 0;
            hsync_nxt_1 <= 0;
            vsync_nxt_1 <= 0;
            hblnk_nxt_1 <= 0;
            vblnk_nxt_1 <= 0;
            rgb_nxt_2 <= 0;
        end
        else
        begin
            hsync_nxt_1 <= hsync_in;
            vsync_nxt_1 <= vsync_in;
            hblnk_nxt_1 <= hblnk_in;
            vblnk_nxt_1 <= vblnk_in;
            hcount_nxt_1 <= hcount_in;
            vcount_nxt_1 <= vcount_in;
            rgb_nxt_2 <= rgb_nxt_1;
        end
    end
    
    always @(posedge clk_in)
    begin
        if(rst)
        begin
            vcount_nxt_2 <= 0;
            hcount_nxt_2 <= 0;
            hsync_nxt_2 <= 0;
            vsync_nxt_2 <= 0;
            hblnk_nxt_2 <= 0;
            vblnk_nxt_2 <= 0;
            rgb_nxt_3 <= 0;
        end
        else
        begin
            hsync_nxt_2 <= hsync_nxt_1;
            vsync_nxt_2 <= vsync_nxt_1;
            hblnk_nxt_2 <= hblnk_nxt_1;
            vblnk_nxt_2 <= vblnk_nxt_1;
            hcount_nxt_2 <= hcount_nxt_1;
            vcount_nxt_2 <= vcount_nxt_1;
            rgb_nxt_3 <= rgb_nxt_1;
        end
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
            hsync_out <= hsync_nxt_2;
            vsync_out <= vsync_nxt_2;
            hblnk_out <= hblnk_nxt_2;
            vblnk_out <= vblnk_nxt_2;
            hcount_out <= hcount_nxt_2;
            vcount_out <= vcount_nxt_2;
            rgb_out <= rgb_nxt_3;
        end
    end
           
    
    
endmodule
