`timescale 1ns / 1ps

module draw_circle_ctl
#( parameter
    RADIUS_BALL = 10,
    PLAYERS_RADIUS = 20
)
(
    input wire clk,
    input wire rst,
    input wire [11:0] mouse_xpos,
    input wire [11:0] mouse_ypos,
    input wire [11:0] xpos_ball,
    input wire [11:0] ypos_ball,
    output reg [11:0] xpos,
    output reg [11:0] ypos
    );

reg [11:0] xpos_nxt, ypos_nxt;

always@*
begin
    if( ( ( mouse_xpos + PLAYERS_RADIUS >= xpos_ball - RADIUS_BALL) && ( mouse_xpos + PLAYERS_RADIUS <= xpos_ball - RADIUS_BALL + 10) ) || ( mouse_xpos - PLAYERS_RADIUS == xpos_ball + RADIUS_BALL ) 
    || ( mouse_ypos + PLAYERS_RADIUS == ypos_ball - RADIUS_BALL) || ( mouse_ypos - PLAYERS_RADIUS == ypos_ball + RADIUS_BALL ) )
    begin
        xpos_nxt = xpos_nxt;
        ypos_nxt = ypos_nxt;
    end
    else
    begin
        xpos_nxt = mouse_xpos;
        ypos_nxt = mouse_ypos;
    end
end

always@(posedge clk)
begin
    if(rst)
    begin
        xpos <= 0;
        ypos <= 0;
    end
    else
    begin
        xpos <= xpos_nxt;
        ypos <= ypos_nxt;
    end
end



endmodule
