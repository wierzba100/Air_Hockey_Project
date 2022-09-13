//autor:KW

`timescale 1ns / 1ps


module draw_playground(
    input wire clk_in,
    input wire [11:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [11:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] rgb_in,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out

    );

    localparam x_pos_circle_center = 486;
    localparam y_pos_circle_center = 358;
    localparam small_circle_radius = 13080; 
    localparam big_circle_radius   = 15000; 
    localparam WHITE_COLOUR = 12'hf_f_f;

    reg hsync_nxt, vsync_nxt, hblnk_nxt, vblnk_nxt, rgb_nxt;
    reg [11:0] hcount_nxt, vcount_nxt;
    
    always @(posedge clk_in)
    begin
    // Just pass these through.
      hcount_out  <= hcount_in;
      vcount_out  <= vcount_in;
  
      //hsync_nxt   <= hsync_in;
      //vsync_nxt   <= vsync_in;
      //hblnk_nxt   <= hblnk_in;
      //vblnk_nxt   <= vblnk_in;
      
      hsync_out   <= hsync_in;
      vsync_out   <= vsync_in;
      hblnk_out   <= hblnk_in;
      vblnk_out   <= vblnk_in;
      //rgb_out     <= rgb_nxt;
        
      // During blanking, make it it black.
      if (vblnk_out || hblnk_out)                                                                       rgb_out <= 12'h0_0_0; 
      else                                                                                                  
      begin                                                                                                 
        // Active display, top edge, make a yellow line.                                                   
        if (vcount_out == 0)                                                                            rgb_out <= 12'hf_f_0;
        // Active display, bottom edge, make a red line.                                                    
        else if (vcount_out == 767)                                                                     rgb_out <= 12'hf_0_0;
        // Active display, left edge, make a green line.                                                    
        else if (hcount_out == 0)                                                                       rgb_out <= 12'h0_f_0;
        // Active display, right edge, make a blue line.                                                    
        else if (hcount_out == 1023)                                                                    rgb_out <= 12'h0_0_f;
                                                                                                            
        //LINIE BOISKA                                                                                      
        else if (hcount_out >= 39 && hcount_out <= 46 && vcount_out >= 39 && vcount_out <= 728 )        rgb_out <= WHITE_COLOUR;   //vertical
        else if (hcount_out >= 977 && hcount_out <= 984 && vcount_out >= 39 && vcount_out <= 728 )      rgb_out <= WHITE_COLOUR;   //vertical
        else if (hcount_out >= 39  && hcount_out <= 984 && vcount_out >= 39 && vcount_out <= 46 )       rgb_out <= WHITE_COLOUR;   //horizontal
        else if (hcount_out >= 39  && hcount_out <= 984 && vcount_out >= 721 && vcount_out <= 728 )     rgb_out <= WHITE_COLOUR;   //horizontal
        else if (hcount_out >= 483  && hcount_out <= 489 && vcount_out >= 39 && vcount_out <= 728 )     rgb_out <= WHITE_COLOUR;   //vertical
        else if ((((hcount_out - x_pos_circle_center)*(hcount_out - x_pos_circle_center))+((vcount_out - y_pos_circle_center)*(vcount_out - y_pos_circle_center)) >= small_circle_radius ) && (((hcount_out - x_pos_circle_center)*(hcount_out - x_pos_circle_center))+((vcount_out - y_pos_circle_center)*(vcount_out - y_pos_circle_center)) <= big_circle_radius)) rgb_out <= WHITE_COLOUR; //circle
                                                                                                            
       //BRAMKA PO LEWEEJ                                                                                 
        else if (hcount_out >= 0 && hcount_out <= 7 && vcount_out >= 258 && vcount_out <= 458 )         rgb_out <= WHITE_COLOUR;        
        else if (hcount_out >= 0 && hcount_out <= 39 && vcount_out >= 258 && vcount_out <= 265 )        rgb_out <= WHITE_COLOUR;        
        else if (hcount_out >= 0 && hcount_out <= 39 && vcount_out >= 451 && vcount_out <= 458 )        rgb_out <= WHITE_COLOUR;        
        //BRAMKA PO PRAWEJ                                                                                  
        else if (hcount_out >= 1017 && hcount_out <= 1024 && vcount_out >= 258 && vcount_out <= 458 )   rgb_out <= WHITE_COLOUR;        
        else if (hcount_out >= 984 && hcount_out <= 1024 && vcount_out >= 258 && vcount_out <= 265 )    rgb_out <= WHITE_COLOUR;        
        else if (hcount_out >= 984 && hcount_out <= 1024 && vcount_out >= 451 && vcount_out <= 458 )    rgb_out <= WHITE_COLOUR;        
                                                                                                           
       //TLO TRAWA                                                                                        
        else                                                                                            rgb_out <= rgb_in;          //background  
     end 
  end     
endmodule