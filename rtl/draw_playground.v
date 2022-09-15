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

    reg hsync_nxt, vsync_nxt, hblnk_nxt, vblnk_nxt;
    reg [11:0] hcount_nxt, vcount_nxt, rgb_nxt, rgb_nxt_1 ;
    
    always @(posedge clk_in)
    begin
    // Just pass these through.
      
      hcount_nxt  <= hcount_in;
      vcount_nxt  <= vcount_in;
      hsync_nxt   <= hsync_in;
      vsync_nxt   <= vsync_in;
      hblnk_nxt   <= hblnk_in;
      vblnk_nxt   <= vblnk_in;
      
      hcount_out  <= hcount_nxt;
      vcount_out  <= vcount_nxt;
      hsync_out   <= hsync_nxt;
      vsync_out   <= vsync_nxt;
      hblnk_out   <= hblnk_nxt;
      vblnk_out   <= vblnk_nxt;
      rgb_out     <= rgb_nxt;
      end 
      
      always @* begin  
      // During blanking, make it it black.
      if (vblnk_in || hblnk_in)                                                                        rgb_nxt = 12'h0_0_0; 
      else                                                                                                  
      begin                                                                                                 
        // Active display, top edge, make a yellow line.                                                   
        if (vcount_in == 0)                                                                            rgb_nxt = 12'hf_f_0;
        // Active display, bottom edge, make a red line.                                                    
        else if (vcount_in == 767)                                                                     rgb_nxt = 12'hf_0_0;
        // Active display, left edge, make a green line.                                                    
        else if (hcount_in == 0)                                                                       rgb_nxt = 12'h0_f_0;
        // Active display, right edge, make a blue line.                                                    
        else if (hcount_in == 1023)                                                                    rgb_nxt = 12'h0_0_f;
                                                                                                            
        //LINIE BOISKA                                                                                      
         if (hcount_in >= 39  && hcount_in <= 46  && vcount_in >= 39  && vcount_in <= 728 )            rgb_nxt = WHITE_COLOUR;   //vertical
        else if (hcount_in >= 977 && hcount_in <= 984 && vcount_in >= 39  && vcount_in <= 728 )        rgb_nxt = WHITE_COLOUR;   //vertical
        else if (hcount_in >= 39  && hcount_in <= 984 && vcount_in >= 39  && vcount_in <= 46 )         rgb_nxt = WHITE_COLOUR;   //horizontal
        else if (hcount_in >= 39  && hcount_in <= 984 && vcount_in >= 721 && vcount_in <= 728 )        rgb_nxt = WHITE_COLOUR;   //horizontal
        else if (hcount_in >= 483 && hcount_in <= 489 && vcount_in >= 39  && vcount_in <= 728 )        rgb_nxt = WHITE_COLOUR;   //vertical
        //else if ((((hcount_in - x_pos_circle_center)*(hcount_in - x_pos_circle_center))+((vcount_in - y_pos_circle_center)*(vcount_in - y_pos_circle_center)) >= small_circle_radius ) && (((hcount_in - x_pos_circle_center)*(hcount_in - x_pos_circle_center))+((vcount_in - y_pos_circle_center)*(vcount_in - y_pos_circle_center)) <= big_circle_radius)) rgb_nxt = WHITE_COLOUR; //circle
                                                                                                            
       //BRAMKA PO LEWEEJ                                                                                 
        else if (hcount_in >= 0 && hcount_in <= 7  && vcount_in >= 258 && vcount_in <= 458 )            rgb_nxt <= WHITE_COLOUR;        
        else if (hcount_in >= 0 && hcount_in <= 39 && vcount_in >= 258 && vcount_in <= 265 )            rgb_nxt <= WHITE_COLOUR;        
        else if (hcount_in >= 0 && hcount_in <= 39 && vcount_in >= 451 && vcount_in <= 458 )            rgb_nxt <= WHITE_COLOUR;        
        //BRAMKA PO PRAWEJ                                                                                  
        else if (hcount_in >= 1017 && hcount_in <= 1024 && vcount_in >= 258 && vcount_in <= 458 )       rgb_nxt <= WHITE_COLOUR;        
        else if (hcount_in >= 984  && hcount_in <= 1024 && vcount_in >= 258 && vcount_in <= 265 )       rgb_nxt <= WHITE_COLOUR;        
        else if (hcount_in >= 984  && hcount_in <= 1024 && vcount_in >= 451 && vcount_in <= 458 )       rgb_nxt <= WHITE_COLOUR;        
                                                                                                           
       //TLO TRAWA                                                                                        
        else                                                                                            rgb_nxt <= rgb_in;          //background  
     end 
  end     
endmodule