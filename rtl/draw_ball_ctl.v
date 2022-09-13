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
    reg [25:0] speed_x, speed_x_nxt, speed_y, speed_y_nxt;
    integer accerelation_x,accerelation_y, accerelation_x_nxt, accerelation_y_nxt;
    reg [1:0] x_direction, y_direction, x_direction_nxt, y_direction_nxt;
    
    always@*
    begin
        if( (  xpos_ball - RADIUS_BALL == 44 ) && ( ypos_ball - RADIUS_BALL > 265 ) && ( ypos_ball + RADIUS_BALL < 451 ) )
        begin
            xpos_ball_nxt = 487;
            ypos_ball_nxt = 362;
            accerelation_x_nxt = 0;
            accerelation_y_nxt = 0;
            x_direction_nxt = 3;
            y_direction_nxt = 3; 
            player_2_score_nxt = player_2_score + 1;
        end
        else if( ( xpos_ball + RADIUS_BALL == 979 || xpos_ball + RADIUS_BALL == 978)  && ( ypos_ball - RADIUS_BALL > 265 ) && ( ypos_ball + RADIUS_BALL < 451 ) )
        begin
            xpos_ball_nxt = 487;
            ypos_ball_nxt = 362;
            accerelation_x_nxt = 0;
            accerelation_y_nxt = 0;
            x_direction_nxt = 3;
            y_direction_nxt = 3;
            player_1_score_nxt = player_1_score + 1;
        end
        else if(  xpos_ball - RADIUS_BALL == 43 )
        begin
            xpos_ball_nxt = xpos_ball + 1;
            x_direction_nxt = 1;
        end
        else if(  xpos_ball + RADIUS_BALL == 981 )
        begin
            xpos_ball_nxt = xpos_ball - 1;
            x_direction_nxt = 0;
        end
        else if( ypos_ball - RADIUS_BALL == 43 )
        begin
            ypos_ball_nxt = ypos_ball + 1;
            y_direction_nxt = 1;
        end
        else if( ypos_ball + RADIUS_BALL == 726 )
        begin
            ypos_ball_nxt = ypos_ball - 1;
            y_direction_nxt = 0;
        end
        else if( (xpos_ball - xpos_player_2)*(xpos_ball - xpos_player_2) + (ypos_ball - ypos_player_2)*(ypos_ball - ypos_player_2)
        < ( RADIUS_BALL + PLAYERS_RADIUS ) * ( RADIUS_BALL + PLAYERS_RADIUS ) )
        begin
            if( xpos_player_2 <= xpos_ball )
                x_direction_nxt = 1;
            else
                x_direction_nxt = 0;
            accerelation_x_nxt = 40;
            
            if( ypos_player_2 <= ypos_ball )
                y_direction_nxt = 1;
            else
                y_direction_nxt = 0;
            accerelation_y_nxt = 25;
        end
        else if( (xpos_ball - xpos_player_1)*(xpos_ball - xpos_player_1) + (ypos_ball - ypos_player_1)*(ypos_ball - ypos_player_1)
        < ( RADIUS_BALL + PLAYERS_RADIUS ) * ( RADIUS_BALL + PLAYERS_RADIUS ) )
        begin
            if( xpos_player_1 <= xpos_ball )
                x_direction_nxt = 1;
            else
                x_direction_nxt = 0;
            accerelation_x_nxt = 40;
            
            if( ypos_player_1 <= ypos_ball )
                y_direction_nxt = 1;
            else
                y_direction_nxt = 0;
            accerelation_y_nxt = 25;
        end
        else
        begin
            player_1_score_nxt = player_1_score;
            player_2_score_nxt = player_2_score;
        end
        
        if( x_direction_nxt == 1)
            xpos_ball_nxt = xpos_ball + speed_x[24];
        else if( x_direction_nxt == 0)
            xpos_ball_nxt = xpos_ball - speed_x[24];
        else
            xpos_ball_nxt = 487;
        
        if( y_direction_nxt == 1)
            ypos_ball_nxt = ypos_ball + speed_y[24];
        else if( y_direction_nxt == 0)
            ypos_ball_nxt = ypos_ball - speed_y[24];
        else
            ypos_ball_nxt = 362;
        
        if(speed_x[24] == 1)
            speed_x_nxt = 0;
        else
            speed_x_nxt = speed_x + accerelation_x_nxt;
                   
        if(speed_y[24] == 1)
            speed_y_nxt = 0;
        else
            speed_y_nxt = speed_y + accerelation_y_nxt;
       
    end
    
    always @(posedge clk_in)
    begin
        if(rst)
        begin
            xpos_ball <= 487;
            ypos_ball <= 362;
            accerelation_x <= 0;
            accerelation_y <= 0;
            x_direction <= 3;
            y_direction <= 3;
            player_1_score <= 0;
            player_2_score <= 0;
            speed_x <= 0;
            speed_y <= 0;
        end
        else
        begin
            xpos_ball <= xpos_ball_nxt;
            ypos_ball <= ypos_ball_nxt;
            player_1_score <= player_1_score_nxt;
            player_2_score <= player_2_score_nxt;
            speed_x <= speed_x_nxt;
            speed_y <= speed_y_nxt;
            accerelation_x <= accerelation_x_nxt;
            accerelation_y <= accerelation_y_nxt;
            x_direction <= x_direction_nxt;
            y_direction <= y_direction_nxt;
        end
    end

endmodule
