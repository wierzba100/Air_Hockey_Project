`timescale 1 ns / 1 ps

//top module***************************************************************************/
module top (
  input wire clk,
  input wire rst,
  output reg [7:0] JB,
  output reg [7:0] JC,
  output reg [7:0] JA,
  inout PS2Clk,
  inout PS2Data
  );
    
    
//wires********************************************************************************/
  wire clk_out_130MHz, locked, clk_out_65MHz;
  wire [11:0] xpos,ypos;
  

  //clock module---------------------------------------------------/  
  clk_wiz_0 u_clk_wiz_0 (
    //input
    .clk_in1(clk),
    .reset(rst),
    //output
    .clk_out_130MHz(clk_out_130MHz),
    .clk_out_65MHz(clk_out_65MHz),
    .locked(locked)
  );
  
   
//mouse control module------------------------------------------------/   
MouseCtl my_MouseCtl(
  .ps2_clk(PS2Clk),
  .ps2_data(PS2Data),
  .clk(clk_out_130MHz),
  .xpos(xpos),
  .ypos(ypos),
  .rst(rst)
  );
    

always@*
begin
    JB[0] = xpos[0];
    JB[1] = xpos[1];
    JB[2] = xpos[2];
    JB[3] = xpos[3];
    JB[4] = xpos[4];
    JB[5] = xpos[5];
    JB[6] = xpos[6];
    JB[7] = xpos[7];
    JC[0] = xpos[8];
    JC[1] = xpos[9];
    JC[2] = xpos[10];
    JC[3] = xpos[11];
    JC[4] = ypos[0];
    JC[5] = ypos[1];
    JC[6] = ypos[2];
    JC[7] = ypos[3];
    JA[0] = ypos[4];
    JA[1] = ypos[5];
    JA[2] = ypos[6];
    JA[3] = ypos[7];
    JA[4] = ypos[8];
    JA[5] = ypos[9];
    JA[6] = ypos[10];
    JA[7] = ypos[11];
end


endmodule
