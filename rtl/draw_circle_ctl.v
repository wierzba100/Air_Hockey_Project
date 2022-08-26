`timescale 1ns / 1ps

module draw_circle_ctl(
    input wire clk,
    input wire rst,
    input wire [11:0] mouse_xpos,
    input wire [11:0] mouse_ypos,
    output reg [11:0] xpos,
    output reg [11:0] ypos
    );

always@(posedge clk)
begin
    if(rst)
    begin
        xpos <= 0;
        ypos <= 0;
    end
    else
    begin
        xpos <= mouse_xpos;
        ypos <= mouse_ypos;
    end
end



endmodule
