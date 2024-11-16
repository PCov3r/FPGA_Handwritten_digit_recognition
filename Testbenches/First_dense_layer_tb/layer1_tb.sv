`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.12.2022 11:25:34
// Design Name: 
// Module Name: test
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


module dense1_tb;
    
logic signed [15:0] test_data_a [0:195] = '{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 58,
 64, 44, 20, 6, 0, 0, 0, 0, 0, 0, 85, 103, 116, 127, 127, 127, 127, 93, 18, 0,
 0, 0, 0, 0, 58, 72, 48, 81, 93, 125, 127, 127, 69, 0, 0, 0, 0, 0, 11, 0, 1,
 29, 57, 120, 127, 104, 10, 0, 0, 0, 0, 0, 0, 0, 57, 127, 127, 127, 105, 10,
 0, 0, 0, 0, 0, 0, 0, 0, 32, 85, 106, 127, 124, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 1, 88, 127, 78, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 90, 127, 37, 0, 0, 0, 0,
 0, 77, 116, 75, 63, 67, 110, 127, 115, 27, 0, 0, 0, 0, 0, 68, 126, 127, 127,
 127, 115, 83, 35, 0, 0, 0, 0, 0, 0, 0, 46, 64, 64, 26, 10, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
   
localparam period = 20;

reg clk, enable, reset, done;  
reg signed [15:0] img [0:195];
reg signed [15:0] out [0:31];

dense_layer1 layer1 (.clk(clk), .enable(enable), .reset(reset), .pooled_img(img),
                     .layer_out(out), .layer_done(done));

initial begin
clk = 0;
enable = 0;
reset = 0;
img = test_data_a;
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
