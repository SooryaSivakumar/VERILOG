`timescale 1ns / 1ps
//__________________________________________________________________________________________________________________________________________________________________//
//traffic signal for a intersection of highway and country road where highway signal is green by default and nly turns red in case of any traffic from country road //
//__________________________________________________________________________________________________________________________________________________________________//
`define TRUE 1'b1      //true and false defined for output of traffic detection sensor 'X' from country road  
`define FALSE 1'b0
`define Y2RDELAY 3     //delays for signal transition
`define R2GDELAY 2     //delays for signal transition
 
module signalop(
output reg [1:0] hwy, cntry,    //outputs gives the state of signal status in higway road and country road
input X,clock,clear
    );

//signal values
parameter RED = 2'd0,
          YELLOW = 2'd1,
          GREEN = 2'd2;

//states present for the full operation of signal total:5
parameter S0 = 3'd0,
          S1 = 3'd1,
          S2 = 3'd2,
          S3 = 3'd3,
          S4 = 3'd4;
          
reg [2:0] state;
reg [2:0] next_state;

//FIRST always block to chck if there is a clear input triggered else state is set
always @(posedge clock)
    if(clear)
        state <= S0;
    else
        state <= next_state;

//SECOND always block to give outputs for set state according to this state the outputs are set
always @(state)
begin
    hwy = GREEN;
    cntry = RED;
    case(state)
        S0: begin
            hwy = GREEN;
            cntry = RED;
            end
        S1: hwy = YELLOW;
        S2: hwy = RED;
        S3: begin
            hwy = RED;
            cntry = GREEN;
            end
        S4: begin
            hwy = RED;
            cntry = YELLOW;
            end
    endcase
end

//THIRD always block chcks for condition triggering state transition and set the next_state acoordingly
always @(state or X)
begin
    case(state)
        S0: if(X)
            next_state = S1;
            else
            next_state = S0;
        S1: begin
            repeat (`Y2RDELAY) @(posedge clock);
            next_state = S2;
            end
        S2: begin
            repeat (`R2GDELAY) @(posedge clock);
            next_state = S3;
            end
        S3: if(X)
            next_state = S3;
            else
            next_state =S4;
        S4: begin
            repeat (`Y2RDELAY) @(posedge clock);
            next_state = S0;
            end
        default: next_state =S0;
     endcase
end

endmodule
