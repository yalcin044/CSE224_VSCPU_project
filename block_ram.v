`timescale 1ns / 1ps

module block_ram(clk, rst, write_en, addr, data_in, data_out);
    parameter SIZE = 14, DEPTH = 2**SIZE;
    
    input clk, rst;
    input write_en;
    input [SIZE-1:0] addr;
    input [31:0] data_in;
    output reg [31:0] data_out;
    
    // Memory
    reg [31:0] memory [DEPTH-1:0];
    
    always @ (posedge clk) begin
        data_out <= memory[addr[SIZE-1:0]];
        if (write_en)
            memory[addr[SIZE-1:0]] <= data_in;
    end 
endmodule
