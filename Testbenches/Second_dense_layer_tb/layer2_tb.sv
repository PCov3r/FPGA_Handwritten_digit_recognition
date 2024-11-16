`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.12.2022 11:25:34
// Design Name: 
// Module Name: layer2_tb
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


module dense2_tb;
    
    logic signed [15:0] test_data_a [0:31] = '{ 0, 0, 0, 36, 5, 33, 63, 82, 0, 41, 0, 49, 127, 29, 25, 63, 14, 55, 27, 0, 97, 0, 71, 0, 0, 0, 104, 0, 54, 45, 5, 0 };

localparam period = 20;

reg clk, enable, reset, done;  
reg signed [15:0] in [0:31];
reg signed [15:0] out [0:9];

dense_layer2 layer2 (.clk(clk), .enable(enable), .reset(reset), .in_data(in),
                     .layer_out(out), .layer_done(done));

initial begin
clk = 0;
enable = 0;
reset = 0;
in = test_data_a;
#145
enable = 1;
#200
reset = 1;
#50
reset = 0;
end

always begin
#10 clk = ~clk;
end

endmodule
