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
    
    reg [11:0] xpos_ball_nxt, ypos_ball_nxt;
    reg [20:0] xm, ym, distance, abs_xm, abs_ym;
    reg [3:0] x_adder, y_adder;
    
    reg [15:0] sqr;
    
    //Verilog function to find square root of a 32 bit number.
    //The output is 16 bit.
    function [15:0] sqrt;
        input [31:0] num;  //declare input
        //intermediate signals.
        reg [31:0] a;
        reg [15:0] q;
        reg [17:0] left,right,r;    
        integer i;
    begin
        //initialize all the variables.
        a = num;
        q = 0;
        i = 0;
        left = 0;   //input to adder/sub
        right = 0;  //input to adder/sub
        r = 0;  //remainder
        //run the calculations for 16 iterations.
        for(i=0;i<16;i=i+1) begin 
            right = {q,r[17],1'b1};
            left = {r[15:0],a[31:30]};
            a = {a[29:0],2'b00};    //left shift by 2 bits.
            if (r[17] == 1) //add if r is negative
                r = left + right;
            else    //subtract if r is positive
                r = left - right;
            q = {q[14:0],!r[17]};       
        end
        sqrt = q;   //final assignment of output.
    end
    endfunction //end of Function
    
    always@*
    begin
        if( xpos_ball - RADIUS_BALL == 44 )
        begin
            xpos_ball_nxt = xpos_ball + 1;
            ypos_ball_nxt = ypos_ball;
        end
        else if( xpos_ball + RADIUS_BALL == 979 )
        begin
            xpos_ball_nxt = xpos_ball - 1;
            ypos_ball_nxt = ypos_ball;
        end
        else if( (xpos_ball - xpos_player_1)*(xpos_ball - xpos_player_1) + (ypos_ball - ypos_player_1)*(ypos_ball - ypos_player_1)
        < ( RADIUS_BALL + PLAYERS_RADIUS ) * ( RADIUS_BALL + PLAYERS_RADIUS ) )
        begin
            xm = xpos_player_1 - xpos_ball;
            ym = ypos_player_1 - ypos_ball;
            if( xpos_player_1 - xpos_ball >= 0 )
                xpos_ball_nxt = xpos_ball - 1;
            else
                xpos_ball_nxt = xpos_ball + 1;
            if( ypos_player_1 - ypos_ball >= 0 )
                ypos_ball_nxt = ypos_ball - 1;
            else
                ypos_ball_nxt = ypos_ball + 1;
        end
        else
        begin
            xpos_ball_nxt = xpos_ball;
            ypos_ball_nxt = ypos_ball;
        end
        
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
