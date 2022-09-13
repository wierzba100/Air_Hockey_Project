//autor:KW

`timescale 1ns / 1ps

module clock_delay(
    input wire clk,
    input wire rst,
    input wire [11:0] xpos_in_player1,
    input wire [11:0] ypos_in_player1,
    input wire [11:0] xpos_in_player2,
    input wire [11:0] ypos_in_player2,
    output reg [11:0] xpos_out_player1,
    output reg [11:0] ypos_out_player1,
    output reg [11:0] xpos_out_player2,
    output reg [11:0] ypos_out_player2
    );
    
    always@(posedge clk)
    begin
        if(rst)
        begin
            xpos_out_player1 <= 0;
            ypos_out_player1 <= 0;
            xpos_out_player2 <= 0;
            ypos_out_player2 <= 0;
        end
        else
        begin
            xpos_out_player1 <= xpos_in_player1;
            ypos_out_player1 <= ypos_in_player1;
            xpos_out_player2 <= 700;
            ypos_out_player2 <= 700;
        end
    end
    
endmodule
