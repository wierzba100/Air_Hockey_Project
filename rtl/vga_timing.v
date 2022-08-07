
`timescale 1 ns / 1 ps

//timing module
//********************************************************************//
module vga_timing (
  //outputs
  output reg [11:0] vcount,
  output reg vsync,
  output reg vblnk,
  output reg [11:0] hcount,
  output reg hsync,
  output reg hblnk,

  //inputs
  input wire pclk_65MHz,
  input wire rst //added
  );
//********************************************************************//

  //local parameters
  localparam HOR_TOTAL_TIME  = 1376;
  localparam VER_TOTAL_TIME  = 809 ;
  localparam HOR_SYNC_START  = 1072;
  localparam VER_SYNC_START  = 769;
  localparam HOR_SYNC_TIME   = 96;
  localparam VER_SYNC_TIME   = 3;
  localparam HOR_BLANK_START = 1024;
  localparam VER_BLANK_START = 768;
  localparam HOR_BLANK_TIME  = 352;
  localparam VER_BLANK_TIME  = 40; 

  //registers
  reg [11:0] hcount_nxt;
  reg [11:0] vcount_nxt;
  reg hsync_nxt, vsync_nxt, hblnk_nxt, vblnk_nxt;
//********************************************************************//


//********************************************************************//
  always @(posedge pclk) begin
    if (rst) begin
      hcount <= 0;
      vcount <= 592;//szybsza symulacja 592
      hsync <= 0;
      vsync <= 0;
      hblnk <= 0;
      vblnk <= 0;
    end
    else begin
      hcount <= hcount_nxt;
      vcount <= vcount_nxt;
      hsync <= hsync_nxt;
      vsync <= vsync_nxt;
      hblnk <= hblnk_nxt;
      vblnk <= vblnk_nxt;
    end
  end
//********************************************************************//


//********************************************************************//

always @* begin
    //Horizontal counter
    if(hcount == HOR_TOTAL_TIME-1) hcount_nxt = 11'b0;
        else hcount_nxt = hcount + 1;
    //Vertical counter
    if(hcount == (HOR_TOTAL_TIME-1) && vcount == (VER_TOTAL_TIME-1)) vcount_nxt = 10'b0;
    else if (hcount == (HOR_TOTAL_TIME-1)) vcount_nxt = vcount + 1;
        else vcount_nxt = vcount;

    //Synchronization time
    if (hcount >= (HOR_SYNC_START-1) && hcount <= (HOR_SYNC_START+HOR_SYNC_TIME-2)) hsync_nxt = 1;
        else hsync_nxt = 0;
    if (vcount == (VER_SYNC_START - 1) && hcount == (HOR_TOTAL_TIME-1)) vsync_nxt = 1;
    else if (vcount >= (VER_SYNC_START) && vcount <= (VER_SYNC_START + VER_SYNC_TIME - 2)) vsync_nxt = 1;
    else if (vcount == (VER_SYNC_START + VER_SYNC_TIME - 1) && hcount <= (HOR_TOTAL_TIME - 2)) vsync_nxt = 1;
    else if (vcount == (VER_SYNC_START + VER_SYNC_TIME - 1) && hcount <= (HOR_TOTAL_TIME - 1)) vsync_nxt = 0;
        else vsync_nxt = 0;

    //Blank spaces
    if (hcount >= (HOR_BLANK_START-1) && hcount <= (HOR_BLANK_START+HOR_BLANK_TIME-2)) hblnk_nxt = 1;
        else hblnk_nxt = 0;
    if (vcount == (VER_BLANK_START - 1) && hcount == (HOR_TOTAL_TIME-1)) vblnk_nxt = 1;
    else if (vcount >= (VER_BLANK_START) && vcount <= (VER_BLANK_START + VER_BLANK_TIME - 2)) vblnk_nxt = 1;
    else if (vcount == (VER_BLANK_START + VER_BLANK_TIME - 1) && hcount <= (HOR_TOTAL_TIME - 2)) vblnk_nxt = 1;
    else if (vcount == (VER_BLANK_START + VER_BLANK_TIME - 1) && hcount <= (HOR_TOTAL_TIME - 1)) vblnk_nxt = 0;
        else vblnk_nxt = 0;
    end
//********************************************************************//

endmodule
