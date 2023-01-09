`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2023 23:47:02
// Design Name: 
// Module Name: dense_layer
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
* Dense layer implementation
*
* Parameters: NEURON_NB => The # of neurons
*             IN_SIZE => The input vector size
*             WIDTH => The width of the weights and biases
*
* Inputs: clk => clock signal, layer_en => enable signal, 
*         reset => active high sync reset signal, in_data => in vector, 
*         weights => neurons weights, biases => neurons biases
*
* Outputs: neuron_out => dense layer output
*          layer_done => done signal
* 
***********/

module dense_layer # (parameter NEURON_NB=32, IN_SIZE=196, WIDTH=8)(
    input clk,
    input layer_en,
    input reset,
    input signed[2*WIDTH-1:0] in_data [0:IN_SIZE-1],
    input signed[WIDTH-1:0] weights [0:NEURON_NB-1][0:IN_SIZE-1],
    input signed[WIDTH-1:0] biases [0:NEURON_NB-1],
    output signed[4*WIDTH-1:0] neuron_out [0:NEURON_NB-1],
    output layer_done
    );
    
    reg [0:NEURON_NB-1] neuron_done;
    reg done = 0;
    
    neuron #(.IN_SIZE(IN_SIZE), .WIDTH(WIDTH)) dense_neuron[0:NEURON_NB-1] 
        (.clk(clk), .en(layer_en), .reset(reset), 
        .in_data(in_data), .weight(weights), .bias(biases), 
        .neuron_out(neuron_out), .neuron_done(neuron_done)); // Neuron submodules
        
    always @(posedge clk) begin
        if(neuron_done == '1) begin //All neurons done
            done <= 1;
        end
    end
    
    assign layer_done = done;

    
endmodule
