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
    output reg [11:0] ypos_ball,
    output reg [4:0] player_1_score,
    output reg [4:0] player_2_score
    );
    
    reg [11:0] xpos_ball_nxt, ypos_ball_nxt;
    reg [4:0] player_1_score_nxt, player_2_score_nxt; 
    
    always@*
    begin
        if( (  xpos_ball - RADIUS_BALL <= 44 ) && ( ypos_ball - RADIUS_BALL > 265 ) && ( ypos_ball + RADIUS_BALL < 451 ) )
        begin
            xpos_ball_nxt = 487;
            ypos_ball_nxt = 362;
            player_2_score_nxt = player_2_score + 1;
        end
        else if( ( xpos_ball + RADIUS_BALL >= 979 )  && ( ypos_ball - RADIUS_BALL > 265 ) && ( ypos_ball + RADIUS_BALL < 451 ) )
        begin
            xpos_ball_nxt = 487;
            ypos_ball_nxt = 362;
            player_1_score_nxt = player_1_score + 1;
        end
        else if(  xpos_ball - RADIUS_BALL == 44 )
        begin
            xpos_ball_nxt = xpos_ball + 1;
            ypos_ball_nxt = ypos_ball;
        end
        else if(  xpos_ball + RADIUS_BALL == 979 )
        begin
            xpos_ball_nxt = xpos_ball - 1;
            ypos_ball_nxt = ypos_ball;
        end
        else if( ypos_ball - RADIUS_BALL == 44 )
        begin
            ypos_ball_nxt = ypos_ball + 1;
            xpos_ball_nxt = xpos_ball;
        end
        else if( ypos_ball + RADIUS_BALL == 725 )
        begin
            ypos_ball_nxt = ypos_ball - 1;
            xpos_ball_nxt = xpos_ball;
        end
        else if( (xpos_ball - xpos_player_1)*(xpos_ball - xpos_player_1) + (ypos_ball - ypos_player_1)*(ypos_ball - ypos_player_1)
        < ( RADIUS_BALL + PLAYERS_RADIUS ) * ( RADIUS_BALL + PLAYERS_RADIUS ) )
        begin
            if( xpos_player_1 <= xpos_ball )
                xpos_ball_nxt = xpos_ball + 1;
            else
                xpos_ball_nxt = xpos_ball - 1;
            
            if( ypos_player_1 <= ypos_ball )
                ypos_ball_nxt = ypos_ball + 1;
            else
                ypos_ball_nxt = ypos_ball - 1;
        end
        else
        begin
            xpos_ball_nxt = xpos_ball;
            ypos_ball_nxt = ypos_ball;
            player_1_score_nxt = player_1_score;
            player_2_score_nxt = player_2_score;
        end
    end
    
    always @(posedge clk_in)
    begin
        if(rst)
        begin
            xpos_ball <= 487;
            ypos_ball <= 362;
            player_1_score <= 0;
            player_2_score <= 0;
        end
        else
        begin
            xpos_ball <= xpos_ball_nxt;
            ypos_ball <= ypos_ball_nxt;
            player_1_score <= player_1_score_nxt;
            player_2_score <= player_2_score_nxt;
        end
    end

endmodule
