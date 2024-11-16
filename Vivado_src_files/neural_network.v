`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.12.2022 10:34:30
// Design Name: 
// Module Name: neural_network
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
* Neural Network implementation
*
* Inputs: clk => clock signal, enable => NN enable signal, img => in vector, 
*
* Outputs: digit out => handwritten digit
*          NN_done => done signal
* 
***********/

module neural_network(
    input clk,
    input enable,
    input reset,
    input [7:0] img [0:783],
    output [7:0] digit_out,
    output NN_done
    );
    
    /* Average pooling layer */
    
    reg pool_enable;
    wire finished_pool;
    reg signed [15:0] pool [0:195];
    
    // Pixel value registers
    wire signed [7:0] pool_in1;
    wire signed [7:0] pool_in2;
    wire signed [7:0] pool_in3;
    wire signed [7:0] pool_in4;
    wire signed [7:0] pool_final;
    
    // Pixel address registers
    reg [15:0] pool_in1_addr;
    reg [15:0] pool_in2_addr;
    reg [15:0] pool_in3_addr;
    reg [15:0] pool_in4_addr;
    reg [15:0] pool_final_addr = 0;
    reg [15:0] pool_addr = 0;
    reg [15:0] pool_row = 0;
    
    // Initialize addresses
    initial
    begin
        pool_in1_addr <= 8'b0000_0000;
        pool_in2_addr <= 8'b0000_0001;
        pool_in3_addr <= 8'b0001_1100;
        pool_in4_addr <= 8'b0001_1101;
        pool_enable <= 1'b1;
    end
    
    avg_pooling AvgPooling(clk,pool_enable,pool_in1,pool_in2,pool_in3,pool_in4,pool_final,finished_pool);
    
    // Load pixel values
    assign pool_in1 = ((img[pool_in1_addr]));
    assign pool_in2 = ((img[pool_in2_addr]));
    assign pool_in3 = ((img[pool_in3_addr]));
    assign pool_in4 = ((img[pool_in4_addr]));
    
    always @(posedge clk) begin
    if(reset) begin
        pool_in1_addr <= 8'b0000_0000;
        pool_in2_addr <= 8'b0000_0001;
        pool_in3_addr <= 8'b0001_1100;
        pool_in4_addr <= 8'b0001_1101;
        pool_final_addr <= 0;
        pool_row <= 0;
        pool_addr <= 0;
        pool_enable <= 1'b1; 
    end
    else if(enable) begin
        if(finished_pool) begin // Average done
            pool[pool_final_addr] = pool_final;
            pool_addr = pool_addr + 2; // Increment address
            pool_row = pool_row + 2;
            if(pool_row == 28) begin // End of row, go down by 2 rows
                pool_addr = pool_addr + pool_row;
                pool_row = 0;
            end
            if(pool_in4_addr == 783) begin // Global averaging done
                pool_enable <= 0;
            end
            else if(pool_in4_addr != 783) begin // Update addresses
                pool_in1_addr <= pool_addr;
                pool_in2_addr <= pool_addr + 1;
                pool_in3_addr <= pool_addr + 28;
                pool_in4_addr <= pool_addr + 29;
                pool_final_addr <= pool_final_addr + 1;
            end
        end
    end       
    end
    
    /* Hidden layer */
    
    reg dense1_enable;
    wire finished_dense1;
    reg signed [15:0] dense1_res [0:31];
    initial dense1_enable <= 0;
    
    dense_layer1 layer2 (.clk(clk), .enable(dense1_enable), .reset(reset), .pooled_img(pool), .layer_out(dense1_res), .layer_done(finished_dense1));

    always @(posedge clk) begin
        if(reset) begin
            dense1_enable <= 0;
        end
        else if(enable) begin
            if(pool_enable == 0 && finished_dense1 == 0) begin // Pooling done
                dense1_enable <= 1;
            end
            else dense1_enable <= 0; // Hidden layer done
        end
    end
    
    /* Output layer */
    
    reg dense2_enable;
    wire finished_dense2;
    reg signed [15:0] dense2_res [0:9];
    initial dense2_enable <= 0;

    dense_layer2 layer3 (.clk(clk), .enable(dense2_enable), .reset(reset), .in_data(dense1_res), .layer_out(dense2_res), .layer_done(finished_dense2));

    always @(posedge clk) begin
        if(reset) begin
            dense2_enable <= 0;
        end
        else if(enable) begin
            if(pool_enable == 0 && finished_dense1 == 1 && finished_dense2 == 0) begin // Previous layers done
                dense2_enable <= 1;
            end
            else dense2_enable <= 0; // Output layer done
        end
    end
    
    /* Handwritten digit selection layer */
    
    reg max_enable;
    wire digit_recog_done;
    reg [7:0] digit;
    
    initial max_enable <= 0;
    
    select_max last_layer (.clk(clk), .enable(max_enable), .reset(reset), .in_data(dense2_res), .digit(digit), .layer_done(digit_recog_done));
        
    always @(posedge clk) begin
        if(reset) begin
            max_enable <= 0;
        end
        else if(enable) begin
            if(finished_dense2 == 1) begin // Output layer done
                max_enable <= 1;
            end
            else max_enable <= 0;
        end
    end
    
    assign digit_out = digit;
    assign NN_done = digit_recog_done;
    
endmodule
