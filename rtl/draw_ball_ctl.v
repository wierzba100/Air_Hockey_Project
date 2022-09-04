module draw_ball_ctl
#( parameter
    RADIUS_BALL = 10,
    PLAYERS_RADIUS = 20
)
(
    input wire clk_in,
    input wire rst,
    input wire [11:0] xpos_player_1,
    input wire [11:0] ypos_player_1,
    output reg [11:0] xpos_ball,
    output reg [11:0] ypos_ball
    );
    
    reg [11:0] rgb_nxt;
    reg [11:0] xpos_ball_nxt, ypos_ball_nxt;
    
    always@*
    begin
        if( ( xpos_player_1 + PLAYERS_RADIUS <= xpos_ball - RADIUS_BALL ) && ( xpos_player_1 + PLAYERS_RADIUS >= xpos_ball - RADIUS_BALL - 2) )
            xpos_ball_nxt = xpos_ball + 2;
        else if ( ( xpos_player_1 - PLAYERS_RADIUS >= xpos_ball + RADIUS_BALL ) && ( xpos_player_1 - PLAYERS_RADIUS <= xpos_ball + RADIUS_BALL + 2) )
            xpos_ball_nxt = xpos_ball - 2;
        else
            xpos_ball_nxt = xpos_ball;
        
        if( ( ypos_player_1 - PLAYERS_RADIUS >= ypos_ball + RADIUS_BALL ) && ( ypos_player_1 - PLAYERS_RADIUS <= ypos_ball + RADIUS_BALL + 2) )
            ypos_ball_nxt = ypos_ball - 2;
        else if( ( ypos_player_1 + PLAYERS_RADIUS <= ypos_ball - RADIUS_BALL ) && ( ypos_player_1 + PLAYERS_RADIUS >= ypos_ball - RADIUS_BALL - 2 ) )
            ypos_ball_nxt = ypos_ball + 2;
        else
            ypos_ball_nxt = ypos_ball;
    end
    
    always @(posedge clk_in)
    begin
        if(rst)
        begin
            xpos_ball <= 487;
            ypos_ball <= 362;
        end
        else
        begin
            xpos_ball <= xpos_ball_nxt;
            ypos_ball <= ypos_ball_nxt;
        end
    end

endmodule
