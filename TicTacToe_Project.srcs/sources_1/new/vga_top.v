`timescale 1ns / 1ps

module vga_top(clk, vga_vsync, vga_hsync, red, green, blue, SW, LED, BTNC, BTNU, BTNL, BTND, BTNR);
    input clk, BTNC, BTNU, BTNL, BTND, BTNR;
    input wire [15:0] SW;
    output vga_vsync, vga_hsync;
    output reg [3:0] red,green,blue; //4 bits of RGB color
    output [15:0] LED;
   
    reg [3:0] State = 4'b0000;
    reg [3:0] NextState = 4'b0000;
   
    wire inDisplay, slow_clk;
    wire [9:0] x_pos; //800 = 640 + 96 + 16 + 48
    wire [9:0] y_pos; //525  = 480 + 2

wire [1:0] row, col;
    wire win1, win2;
    wire [8:0] p1, p2;
    wire tl, tc, tr, ml, mc, mr, bl, bc, br;
   
    assign tl = (x_pos > 0) && (x_pos < 213) && (y_pos > 0) && (y_pos < 160);
    assign tc = (x_pos > 213) && (x_pos < 426) && (y_pos > 0) && (y_pos < 160);
    assign tr = (x_pos > 426) && (x_pos < 640) && (y_pos > 0) && (y_pos < 160);
    assign ml = (x_pos > 0) && (x_pos < 213) && (y_pos > 160) && (y_pos < 320);
    assign mc = (x_pos > 213) && (x_pos < 426) && (y_pos > 160) && (y_pos < 320);
    assign mr = (x_pos > 426) && (x_pos < 640) && (y_pos > 160) && (y_pos < 320);
    assign bl = (x_pos > 0) && (x_pos < 213) && (y_pos > 320) && (y_pos < 480);
    assign bc = (x_pos > 213) && (x_pos < 426) && (y_pos > 320) && (y_pos < 480);
    assign br = (x_pos > 426) && (x_pos < 640) && (y_pos > 320) && (y_pos < 480);
   
    vga_sync v1(clk, vga_hsync, vga_vsync, x_pos, y_pos, inDisplay); //fill in the parameter
   
   
    clk_divider cd0(clk, clk_slow);
   
   TicTacToe T0(LED, row, col, win1, win2, p1, p2, SW[1:0], BTNC, BTNU, BTNL, BTND, BTNR, clk_slow, SW[15]);

    always @(State) begin
        NextState <= 0;
        red = 4'h0;
        blue = 4'h0;
        green = 4'h0;
       case(State)
                  4'b0000: begin /*State 0*/
               red = ((x_pos < 213) && (y_pos < 160)||(y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426)) ? 4'hF : 4'h0;
               blue = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426)) ? 4'hF : 4'h0;
               green = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;

                NextState <= 1;
            end
            4'b0001: begin/*State 1*/
                blue = ((x_pos < 213) && (160 <  y_pos) && (  y_pos < 320)||(y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426)) ? 4'hF : 4'h0;
                green = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;
                red = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;

                NextState <= 2;
          end
            4'b0010: begin/*State 2*/
                red = ((x_pos < 213) && (320 <  y_pos) && (  y_pos < 480)||(y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426)) ? 4'hF : 4'h0;
                green = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;
                blue = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;

               NextState <= 3;
            end
            4'b0011: begin/*State 3*/
                blue = ((x_pos >213) && (x_pos < 426) && (160 > y_pos)||(y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426)) ? 4'hF : 4'h0;
                green = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;
                red = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;

               NextState <= 4;
            end
              4'b0100: begin/*State 4*/
                red = ((x_pos >213) && (x_pos < 426) && (160 <  y_pos) && (  y_pos < 320)||(y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426)) ? 4'hF : 4'h0;
              green = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;
                blue = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;

               NextState <= 5;
            end
              4'b0101: begin/*State 5*/
                blue = ((x_pos >213) && (x_pos < 426) && (320 <  y_pos) && (y_pos < 480)||(y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426)) ? 4'hF : 4'h0;
                green = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;
                red = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;

               NextState <= 6;
            end
             4'b0110: begin/*State 6*/
                red = ((x_pos >426) && (x_pos < 640) && (y_pos < 160)||(y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426)) ? 4'hF : 4'h0;
             green = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;
                blue = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;

               NextState <= 7;
               end
             4'b0111: begin/*State 7*/
                blue = ((x_pos >426) && (x_pos < 640) && (160 <  y_pos) && (  y_pos < 320)||(y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426)) ? 4'hF : 4'h0;
               green = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;
                red = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;

               NextState <= 8;
               end
             4'b1000: begin/*State 8*/
                red = ((x_pos >426) && (x_pos < 640) && (320 <  y_pos) && (y_pos < 480)||(y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426)) ? 4'hF : 4'h0;
                green = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;
                blue = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;

               NextState <= 9;
            end
              4'b1001: begin/*State 9*/
              red = (/* Next State 1*/(x_pos < 213) && (y_pos < 160) || /* Next State 3*/ (x_pos < 213) && (320 <  y_pos) && (  y_pos < 480)|| /* Next State 5*/ (x_pos >213) && (x_pos < 426) && (160 <  y_pos) && (  y_pos < 320)||(x_pos >426) && (x_pos < 640) && (y_pos < 160)|| (x_pos >426) && (x_pos < 640) && (320 <  y_pos) && (y_pos < 480)||(y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426)) ? 4'hF : 4'h0;
              blue = ((x_pos < 213) && (160 <  y_pos) && (  y_pos < 320) ||(x_pos >213) && (x_pos < 426) && (160 > y_pos)||(x_pos >213) && (x_pos < 426) && (320 <  y_pos) && (y_pos < 480)||(x_pos >426) && (x_pos < 640) && (160 <  y_pos) && (  y_pos < 320)||(y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426)) ? 4'hF : 4'h0;
             green = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;

             NextState <= 10;
            end
            4'b1010: begin/*State 10, Game state*/
                red = ((tl && p1[8]) || (tc && p1[7]) || (tr && p1[6]) || (ml && p1[5]) || (mc && p1[4]) || (mr && p1[3]) || (bl && p1[2]) || (bc && p1[1]) || (br && p1[0])||(y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;
                blue = ((tl && p2[8]) || (tc && p2[7]) || (tr && p2[6]) || (ml && p2[5]) || (mc && p2[4]) || (mr && p2[3]) || (bl && p2[2]) || (bc && p2[1]) || (br && p2[0])||(y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;
                green = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;
                if(win1 == 1'b1 || win2 == 1'b1) begin
                    NextState <= 11;
                end
                else begin
                    NextState <= 10;  
                end
            end
   
             4'b1011: begin/*State 11*/
              red = (/* Next State 1*/(x_pos < 213) && (y_pos < 160) || /* Next State 3*/ (x_pos < 213) && (320 <  y_pos) && (  y_pos < 480)|| /* Next State 5*/ (x_pos >213) && (x_pos < 426) && (160 <  y_pos) && (  y_pos < 320)||(x_pos >426) && (x_pos < 640) && (y_pos < 160)|| (x_pos >426) && (x_pos < 640) && (320 <  y_pos) && (y_pos < 480)||(y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426)) ? 4'hF : 4'h0;
               green = ((y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426) ) ? 4'hF : 4'h0;
              blue = ((x_pos < 213) && (160 <  y_pos) && (  y_pos < 320) ||(x_pos >213) && (x_pos < 426) && (160 > y_pos)||(x_pos >213) && (x_pos < 426) && (320 <  y_pos) && (y_pos < 480)||(x_pos >426) && (x_pos < 640) && (160 <  y_pos) && (  y_pos < 320)||(y_pos > 140) && (y_pos < 160)||(y_pos > 300) && (y_pos < 320)||(x_pos > 193) && (x_pos < 213)||(x_pos > 406) && (x_pos < 426)) ? 4'hF : 4'h0;               
        if (SW[13]==1'b1)begin
        NextState<=0;
        end
          else begin
             NextState <= 11;              
              end
              end
          endcase
           end    
   
   
    always @(posedge clk_slow) begin
        State <= NextState;
    end
   
       
endmodule



module vga_sync( clk, hsync, vsync, xCount, yCount, inDisplay );
   
    input clk;
    output vsync, hsync;
    output inDisplay;
    wire null;
    output reg [9:0] xCount;
    output reg [9:0] yCount;  
   
   
   
    initial begin
        xCount <= 10'h000;
        yCount <= 9'h000;
    end
   
   
    wire pixel_clk;
    clk_wiz_0 clk1(pixel_clk,1'b0, null, clk);
    always @(posedge pixel_clk) begin
        xCount <= (xCount == 799) ? (10'h000) : (xCount + 1'b1);
    end
   
    always @(posedge pixel_clk) begin
        if(yCount == 524) begin
            yCount <= 9'h000;
        end else if(xCount == 799) begin
            yCount <= yCount + 1'b1;
        end else begin
            yCount <= yCount;
        end
    end
   
        assign hsync = ~((xCount >= 656) && (xCount < 751));
        assign vsync = ~((yCount >= 489) && (yCount < 491));
        assign inDisplay = (xCount < 640) && (yCount < 480);
       

endmodule

module clk_divider(
    input clk,
    output reg clk_slow);
   
    parameter slow_divisor = 40000000; // 1 Hz clock cycle
   
    reg [31:0] counter_slow;
    initial begin
        counter_slow = 0;
        clk_slow = 1'b0;
    end
   
    always @(posedge clk) begin
        counter_slow <= counter_slow + 1;
        if(counter_slow > slow_divisor) begin
            counter_slow <= 0;
            clk_slow <= ~clk_slow;
        end
    end
endmodule

















