`timescale 1ns / 1ps

module draw_scoreboard(
    input wire clk,
    input wire hblnk_in,
    input wire vblnk_in,
    input wire hsync_in,
    input wire vsync_in,
    input wire [11:0] hcount_in,
    input wire [11:0] vcount_in,
    input wire [11:0] rgb_in,
    input wire rst,
    input wire [1:0] player_1_point,
    //input wire [1:0] player_2_point;

    output reg [11:0] hcount_out,
    output reg [11:0] vcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out
    );

reg [11:0] rgb_nxt;
reg [2:0] state_nxt, state;

localparam ZERO_POINT       = 3'b000;
localparam ONE_POINT        = 3'b001;
localparam TWO_POINT        = 3'b010;
localparam THREE_POINT      = 3'b011;
localparam PLAYER_1_WIN     = 3'b100;
localparam IDLE             = 3'b101;

localparam BLACK            = 12'h0_0_0;
localparam GREEN            = 12'h0_f_0;
localparam RED              = 12'hf_0_0;


always@* begin
    case(state)
    IDLE:           state_nxt = (player_1_point == 2'b00)         ? ZERO_POINT  : IDLE;
    ZERO_POINT:     state_nxt = (player_1_point == 2'b01)         ? ONE_POINT   : ZERO_POINT;
    ONE_POINT:      state_nxt = (player_1_point == 2'b10)         ? TWO_POINT   : ONE_POINT;
    TWO_POINT:      state_nxt = (player_1_point == 2'b11)         ? THREE_POINT : TWO_POINT;
    THREE_POINT:    state_nxt = PLAYER_1_WIN;
    PLAYER_1_WIN:   state_nxt = PLAYER_1_WIN;
    default:        state_nxt = IDLE;
    endcase
   end


always@* begin
    case(state_nxt)
    IDLE: begin
                                                                                                            rgb_nxt = rgb_nxt;
    end
    ZERO_POINT: begin
        if ((vcount_in >= 47) && (vcount_in <= 76) && (hcount_in >= 403) && (hcount_in <= 482))             rgb_nxt = BLACK;
    end
    ONE_POINT: begin
        if ((vcount_in >= 47) && (vcount_in <= 76) && (hcount_in >= 403) && (hcount_in <= 482))             rgb_nxt = BLACK;
            else if ((vcount_in >= 52) && (vcount_in <= 71) && (hcount_in >= 408) && (hcount_in <= 427))    rgb_nxt = GREEN;
            else                                                                                            rgb_nxt = rgb_in;
        end
    TWO_POINT: begin
        if ((vcount_in >= 47) && (vcount_in <= 76) && (hcount_in >= 403) && (hcount_in <= 482))             rgb_nxt = BLACK;
            else if ((vcount_in >= 52) && (vcount_in <= 71) && (hcount_in >= 408) && (hcount_in <= 427))    rgb_nxt = GREEN;
            else if ((vcount_in >= 52) && (vcount_in <= 71) && (hcount_in >= 433) && (hcount_in <= 452))    rgb_nxt = GREEN;
            else                                                                                            rgb_nxt = rgb_in;
        end
    THREE_POINT: begin
        if ((vcount_in >= 47) && (vcount_in <= 76) && (hcount_in >= 403) && (hcount_in <= 482))             rgb_nxt = BLACK;
            else if ((vcount_in >= 52) && (vcount_in <= 71) && (hcount_in >= 408) && (hcount_in <= 427))    rgb_nxt = GREEN;
            else if ((vcount_in >= 52) && (vcount_in <= 71) && (hcount_in >= 433) && (hcount_in <= 452))    rgb_nxt = GREEN;
            else if ((vcount_in >= 52) && (vcount_in <= 71) && (hcount_in >= 458) && (hcount_in <= 477))    rgb_nxt = GREEN;
            else                                                                                            rgb_nxt = rgb_in;
            end
    PLAYER_1_WIN: begin
        if ((vcount_in >= 47) && (vcount_in <= 76) && (hcount_in >= 403) && (hcount_in <= 482))             rgb_nxt = BLACK;
            else if ((vcount_in >= 52) && (vcount_in <= 71) && (hcount_in >= 408) && (hcount_in <= 427))    rgb_nxt = RED;
            else if ((vcount_in >= 52) && (vcount_in <= 71) && (hcount_in >= 433) && (hcount_in <= 452))    rgb_nxt = RED;
            else if ((vcount_in >= 52) && (vcount_in <= 71) && (hcount_in >= 458) && (hcount_in <= 477))    rgb_nxt = RED;
            else                                                                                            rgb_nxt = rgb_in;
        end
    default: begin
                                                                                                            rgb_nxt = rgb_nxt;
        end
    endcase
end
   
    always @(posedge clk) begin
        if(rst)begin
            state <= IDLE;
        end
        else begin
            state       <= state_nxt;
            rgb_out     <= rgb_in;
            hcount_out  <= hcount_in;
            vcount_out  <= vcount_in;
            hsync_out   <= hsync_in;
            vsync_out   <= vsync_in;
            vblnk_out   <= vblnk_in;
            hblnk_out   <= hblnk_in;
         end
     end
    
 endmodule