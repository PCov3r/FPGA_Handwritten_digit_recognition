`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.12.2022 09:16:01
// Design Name: 
// Module Name: dense_layer2
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
* 1st dense layer implementation (output layer)
*
* Inputs: clk => clock signal, enable => enable signal, 
*         reset => active high sync reset, in_data => in vector, 
*
* Outputs: layer_out => dense layer output
*          layer_done => done signal
* 
***********/

module dense_layer2(
    input clk,
    input enable,
    input reset,
    input signed [15:0] in_data [0:31],
    output signed [15:0] layer_out [0:9],
    output layer_done
    );
    
    reg signed [31:0] dense2_res [0:9];
    reg signed [15:0] relu_res [0:9];
  
    //Biases and weights
    localparam signed [7:0] B_ARRAY_L3 [0:9] = '{ -11, 10, 14, -23, -1, 8, 0, 13, 1, -11 };
    
    localparam signed [7:0] W_ARRAY_L3 [0:9] [0:31] = '{
    { 33, -57, -6, -23, -11, -48, -53, 46, -54, -24, 4, 9, -2, -40, -29, 20, -6, 45, -85, 2, -57, 45, 40, -21, -23, -2, -105, -19, -40, 28, -7, 15 },
    { 30, 34, 29, -19, -12, -47, 50, -69, 64, -25, 38, 35, -43, 19, -17, -61, 62, -31, -30, -69, 43, -67, -60, 5, 46, -1, -50, -64, 39, -39, -28, -28 },
    { 2, -48, 30, 33, 69, -11, 28, -1, 28, 25, -22, 58, -11, -120, -6, -28, -72, -12, -33, -4, 1, 81, 21, -22, 24, -100, -59, -59, -20, 27, 37, 39 },
    { -37, 61, -6, -19, -5, 60, 14, 8, 28, -29, -106, 53, 32, -18, -27, -16, -1, -45, 43, 40, 18, -28, 25, -37, -7, -23, 52, -45, 16, -28, 6, -53 },
    { -9, 57, 20, 19, -96, -25, -47, 19, 43, -19, 8, -68, -37, 37, 28, -8, 13, -15, 17, -40, -33, 2, -100, 35, 5, -52, 12, 34, -75, -92, 30, 17 },
    { 16, -8, -127, -69, 28, -82, 29, -47, -7, -19, -11, -55, -10, 37, -46, -14, 26, -1, 39, 35, -37, -5, 10, -20, -35, 84, 55, 13, 37, 25, -5, -36 },
    { 40, 29, -74, -1, -16, 71, -91, -13, -92, 24, 32, -15, -5, -12, -73, -70, 0, -25, -85, 38, -63, 2, -53, 36, 39, 4, -93, 24, 26, 19, 12, 37 },
    { -40, -42, -10, 45, 26, 8, 25, 8, -33, -40, -32, 34, -40, -38, 32, 19, 42, -20, -18, 41, 21, -41, 24, 7, -25, 37, -93, -32, -56, -52, -48, 55 },
    { 4, -73, 17, -34, 17, 0, -34, -9, -50, 10, 29, -75, 37, 10, -19, 0, -63, -1, 12, 2, 9, -63, 7, 40, -12, -54, -17, 26, -10, -5, -7, -89 },
    { -82, -31, 23, -61, -34, 18, -52, -24, -1, 12, 29, -74, -11, 14, 34, 33, 23, -13, -21, -98, -48, 32, 26, -35, 7, 3, 68, 14, -25, -11, -86, 27 }
    };
    
    wire dense2_en = enable;
    reg dense2_done = 0;

    
  dense_layer #(.NEURON_NB(10),.IN_SIZE(32), .WIDTH(8)) dense_layer2(.clk(clk), .layer_en(dense2_en), .reset(reset),
                                                                     .in_data(in_data), .weights(W_ARRAY_L3), .biases(B_ARRAY_L3),
                                                                     .neuron_out(dense2_res), .layer_done(dense2_done)); //Dense layer

    relu relu_activation[9:0] (.data_in(dense2_res), .data_out(relu_res)); //ReLu activation
    
    assign layer_out = relu_res;               
    assign layer_done = dense2_done;

endmodule
