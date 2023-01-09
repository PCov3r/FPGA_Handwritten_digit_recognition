`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.12.2022 10:34:30
// Design Name: 
// Module Name: avg_pooling_layer
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


module avg_pooling_layer(
    input clk,
    input enable,
    input reset,
    input [7:0] img [0:783]
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
  
endmodule
