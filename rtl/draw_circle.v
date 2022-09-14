//autor:FW

`timescale 1ns / 1ps

module draw_circle
#( parameter
    COLOR_PLAYER1 = 12'hf_f_f,
    COLOR_PLAYER2 = 12'h0_f_f,
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
    input wire [11:0] xpos_in_player1,
    input wire [11:0] ypos_in_player1,
    input wire [11:0] xpos_in_player2,
    input wire [11:0] ypos_in_player2,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out,
    output reg [11:0] xpos_out_player1,
    output reg [11:0] ypos_out_player1,
    output reg [11:0] xpos_out_player2,
    output reg [11:0] ypos_out_player2
    );
    
    reg [11:0] rgb_nxt,rgb_nxt2,rgb_nxt3;
    
    always@*
    begin
        if( ( ( hcount_in - xpos_in_player1 ) * ( hcount_in - xpos_in_player1 ) ) + ( ( vcount_in - ypos_in_player1 ) * ( vcount_in - ypos_in_player1 ) ) <= RADIUS * RADIUS )
            rgb_nxt = COLOR_PLAYER1;
        else if( ( ( hcount_in - xpos_in_player2 ) * ( hcount_in - xpos_in_player2 ) ) + ( ( vcount_in - ypos_in_player2 ) * ( vcount_in - ypos_in_player2 ) ) <= RADIUS * RADIUS )
            rgb_nxt = COLOR_PLAYER2;
        else
            rgb_nxt = rgb_in;

    end
    
    always @(posedge clk_in or posedge rst)
    begin
        if(rst)
        begin
            vcount_out <= 0;
            hcount_out <= 0;
            hsync_out <= 0;
            vsync_out <= 0;
            hblnk_out <= 0;
            vblnk_out <= 0;
            xpos_out_player1 <= 0;
            ypos_out_player1 <= 0;
            xpos_out_player2 <= 0;
            ypos_out_player2 <= 0;
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
            //rgb_nxt2 <= rgb_nxt;
             
            //rgb_nxt3 <= rgb_nxt2;

            rgb_out <= rgb_nxt;
            xpos_out_player1 <= xpos_in_player1;
            ypos_out_player1 <= ypos_in_player1;
            xpos_out_player2 <= xpos_in_player2;
            ypos_out_player2 <= ypos_in_player2;
        end
    end
           
    
    
endmodule
