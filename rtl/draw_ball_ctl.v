//autor:FW

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
    input wire [11:0] xpos_player_2,
    input wire [11:0] ypos_player_2,
    output reg [11:0] xpos_ball,
    output reg [11:0] ypos_ball,
    output reg [3:0] player_1_score,
    output reg [3:0] player_2_score
    );
    
    reg [11:0] xpos_ball_nxt, ypos_ball_nxt;
    reg [3:0] player_1_score_nxt, player_2_score_nxt;
    reg [20:0] speed, speed_nxt;
    integer accerelation, accerelation_nxt;
    reg[1:0] x_direction, y_direction, x_direction_nxt, y_direction_nxt;
    
    always@*
    begin
        if( (  xpos_ball - RADIUS_BALL == 44 ) && ( ypos_ball - RADIUS_BALL > 265 ) && ( ypos_ball + RADIUS_BALL < 451 ) )
        begin
            player_2_score_nxt = player_2_score + 1;
            xpos_ball_nxt = 487;
            ypos_ball_nxt = 362;
            accerelation_nxt = 0;
            x_direction_nxt = 3;
            y_direction_nxt = 3;
        end
        else if( ( xpos_ball + RADIUS_BALL == 979 || xpos_ball + RADIUS_BALL == 978)  && ( ypos_ball - RADIUS_BALL > 265 ) && ( ypos_ball + RADIUS_BALL < 451 ) )
        begin
            player_1_score_nxt = player_1_score + 1;
            xpos_ball_nxt = 487;
            ypos_ball_nxt = 362;
            accerelation_nxt = 0;
            x_direction_nxt = 3;
            y_direction_nxt = 3;
        end
        else if(  xpos_ball - RADIUS_BALL <= 44 )
        begin
            x_direction_nxt = 1;
        end
        else if(  xpos_ball + RADIUS_BALL >= 981 )
        begin
            x_direction_nxt = 0;
        end
        else if( ypos_ball - RADIUS_BALL <= 44 )
        begin
            y_direction_nxt = 1;
        end
        else if( ypos_ball + RADIUS_BALL >= 727 )
        begin
            y_direction_nxt = 0;
        end
        else if( (xpos_ball - xpos_player_1)*(xpos_ball - xpos_player_1) + (ypos_ball - ypos_player_1)*(ypos_ball - ypos_player_1) <= (RADIUS_BALL+PLAYERS_RADIUS)*(RADIUS_BALL+PLAYERS_RADIUS) )
        begin
            accerelation_nxt = 12;
            if( xpos_ball <= xpos_player_1)
                x_direction_nxt = 0;
            else
                x_direction_nxt = 1;
            
            if( ypos_ball <= ypos_player_1)
                y_direction_nxt = 0;
            else
                y_direction_nxt = 1;
        end
        else if( (xpos_ball - xpos_player_2)*(xpos_ball - xpos_player_2) + (ypos_ball - ypos_player_2)*(ypos_ball - ypos_player_2) <= (RADIUS_BALL+PLAYERS_RADIUS)*(RADIUS_BALL+PLAYERS_RADIUS) )
            begin
                accerelation_nxt = 12;
                if( xpos_ball <= xpos_player_2)
                    x_direction_nxt = 0;
                else
                    x_direction_nxt = 1;
                
                if( ypos_ball <= ypos_player_2)
                    y_direction_nxt = 0;
                else
                    y_direction_nxt = 1;
            end
        else
        begin
            player_1_score_nxt = player_1_score;
            player_2_score_nxt = player_2_score;
            xpos_ball_nxt = xpos_ball;
            ypos_ball_nxt = ypos_ball;
            x_direction_nxt = x_direction;
            y_direction_nxt = y_direction;
        end
        
        if( x_direction == 1)
            xpos_ball_nxt = xpos_ball + speed[20];
        else if ( x_direction == 0)
            xpos_ball_nxt = xpos_ball - speed[20];
        else
            xpos_ball_nxt = 487;
         
        if( y_direction == 1)
            ypos_ball_nxt = ypos_ball + speed[20];
        else if ( y_direction == 0)
            ypos_ball_nxt = ypos_ball - speed[20];
        else
            ypos_ball_nxt = 362;
        
        if(speed[20] == 1)
            speed_nxt = 0;
        else
            speed_nxt = speed + accerelation;
    end
    
    always @(posedge clk_in or posedge rst)
    begin
        if(rst)
        begin
            xpos_ball <= 487;
            ypos_ball <= 362;
            speed <= 0;
            accerelation <= 0;
            x_direction <= 3;
            y_direction <= 3;
            player_1_score <= 0;
            player_2_score <= 0;
        end
        else
        begin
            xpos_ball <= xpos_ball_nxt;
            ypos_ball <= ypos_ball_nxt;
            x_direction <= x_direction_nxt;
            y_direction <= y_direction_nxt;
            speed <= speed_nxt;
            accerelation <= accerelation_nxt;
            player_1_score <= player_1_score_nxt;
            player_2_score <= player_2_score_nxt;
        end
    end

endmodule
