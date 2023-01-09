`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.12.2022 22:18:50
// Design Name: 
// Module Name: avg_pooling
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


/**********
* Average pooling implementation
*
* Inputs: clk => clock signal, pool_en => enable signal, 
*         in1 => top left pixel value, 
*         in2 => top right pixel value,
*         in3 => bottom left pixel value,
*         in4 => bottom right pixel value,
*
* Outputs: out => in pixels average
*          pool_done => done signal
* 
***********/

module avg_pooling(
    input clk,
    input pool_en,
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    input [7:0] in4,
    output [7:0] out,
    output  pool_done
    );
    
    reg [15:0] pool_out;
    
    always @(posedge clk) begin
        if(pool_en == 1) begin
            pool_out <= (in1+in2+in3+in4)>> 2; //Calculate average
        end
        
    end
    
    assign out = pool_out[7:0];
    assign pool_done = (pool_out==(in1+in2+in3+in4)>> 2)? 1:0;

endmodule
