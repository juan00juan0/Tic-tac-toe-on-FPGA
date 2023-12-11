`timescale 1ns / 1ps

// Two switches: Player 1 and Player 2
// Two LEDs: Player 1 and Player 2
module TicTacToe(led, rowPos, colPos, win1, win2, Player1Lin, Player2Lin, sw, btnc, btnu, btnl, btnd, btnr, CLK, reset);
    output [15:0] led;
    output reg [1:0] rowPos, colPos;
    output reg win1, win2;
    output [8:0] Player1Lin, Player2Lin;
    input [1:0] sw; // Switch 1: Player 1, Switch 0: Player 2
    input btnc, btnu, btnl, btnd, btnr, CLK;
    input reset;
    
    wire p1, p2;
    
    // columns then rows
    reg [2:0] Player1 [2:0]; // Player 1 3x3 array
    reg [2:0] Player2 [2:0]; // Player 2 3x3 array
    
    integer i, j;
    reg currP1, currP2;
    
    always @(posedge CLK) begin
        if(reset) begin // resets values, need to start a game
//            win1 <= 1'b0;
//            win2 <= 1'b0;
            rowPos <= 2'b00;
            colPos <= 2'b10;
            for(i = 0; i < 3; i = i + 1) begin
                Player1[i] <= 3'b000;
                Player2[i] <= 3'b000;
            end
        end
        if(btnu) begin
            if(rowPos == 2'b00) begin
                rowPos <= 2'b10;
            end
            else begin
                rowPos <= rowPos - 2'b01; // minus 1 because rows decrease upward
            end
        end
        else if(btnd) begin
            if(rowPos == 2'b10) begin
                rowPos <= 2'b00;
            end
            else begin
                rowPos <= rowPos + 2'b01; // plus one because rows increase going down
            end
        end
        else if(btnr) begin
            if(colPos == 2'b00) begin
                colPos <= 2'b10;
            end
            else begin
                colPos <= colPos - 2'b01; // bit order decreases rightward
            end
        end
        else if(btnl) begin
            if(colPos == 2'b10) begin
                colPos <= 2'b00;
            end
            else begin
                colPos <= colPos + 2'b01; // bit order increases leftward
            end
        end
        else if(btnc) begin // Player wants to take the current position
            //these two lines MUST be blocking to ensure the if statements work as intended 
            currP1 = Player1[rowPos][colPos];
            currP2 = Player2[rowPos][colPos];
            if(p1 & ~p2) begin // Player 1's turn
                if(~currP2) begin // make sure player 2 hasn't already taken the current spot
                    Player1[rowPos][colPos] <= 1'b1;
                end
            end
            else if(~p1 & p2) begin // Player 2's turn
                if(~currP1) begin // make sure player 1 hasn't taken this spot
                    Player2[rowPos][colPos] <= 1'b1;
                end
            end
        end
    end
    
    // checks if a player has won everytime a player takes a spot
    always @(posedge CLK) begin
        win1 <= win(Player1Lin);
        win2 <= win(Player2Lin);
    end
    
    //win function determines if a player has won based on possible winning combinations
    function win;
        input [8:0] pa; // pa: player array
        begin
            // check that player has a winning combination
            if((pa[8] & pa[5] & pa[2]) || (pa[7] & pa[4] & pa[1]) || (pa[6] & pa[3] & pa[0]) || (pa[8] & pa[7] & pa[6]) || (pa[5] & pa[4] & pa[3]) || (pa[2] & pa[1] & pa[0]) || (pa[8] & pa[4] & pa[0]) || (pa[6] & pa[4] & pa[2])) begin
                win = 1'b1;
            end
            else begin
                win = 1'b0;
            end
        end
    endfunction
     
    // Player arrays are converted to 1-D arrays so outputting them provides no issues
    assign Player1Lin = {Player1[0], Player1[1], Player1[2]};
    assign Player2Lin = {Player2[0], Player2[1], Player2[2]};
    
    // switches 1 and 0 determine which player is active; p1 and p2 are used in always block to know who is playing 
    assign p1 = sw[1];
    assign p2 = sw[0];
    // shows which player is playing; led[1]: player 1, led[0]: player 2
    assign led[1:0] = sw[1:0];
    // shows player position
    assign led[10] = (rowPos == 2'b00) && (colPos == 2'b10);
    assign led[9] = (rowPos == 2'b00) && (colPos == 2'b01);
    assign led[8] = (rowPos == 2'b00) && (colPos == 2'b00);
    assign led[7] = (rowPos == 2'b01) && (colPos == 2'b10);
    assign led[6] = (rowPos == 2'b01) && (colPos == 2'b01);
    assign led[5] = (rowPos == 2'b01) && (colPos == 2'b00);
    assign led[4] = (rowPos == 2'b10) && (colPos == 2'b10);
    assign led[3] = (rowPos == 2'b10) && (colPos == 2'b01);
    assign led[2] = (rowPos == 2'b10) && (colPos == 2'b00);
    
    assign led[14] = win1;
    assign led[13] = win2;
endmodule


