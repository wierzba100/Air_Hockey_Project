//autor:KW

`timescale 1ns / 1ps

module clock_delay(
    input wire clk,
    input wire rst,
    input wire [11:0] xpos_in_player1,
    input wire [11:0] ypos_in_player1,
    input wire [7:0] JA,
    input wire [7:0] JB,
    input wire [7:0] JC,
    output reg [11:0] xpos_out_player1,
    output reg [11:0] ypos_out_player1,
    output reg [11:0] xpos_out_player2,
    output reg [11:0] ypos_out_player2
    );
    
    always@(posedge clk or posedge rst)
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
            xpos_out_player2 <= {JC[3:0],JB[7:0]};
            ypos_out_player2 <= {JA[7:0],JC[7:4]};
        end
    end
    
endmodule
