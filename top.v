`timescale 1ns / 1ps

module top(clk, rst, synth_data_to_ram, synth_data_from_ram, synth_addr, synth_we);
    input wire clk;
    input wire rst;
    
    output wire [31:0] synth_data_to_ram;
    output wire [31:0] synth_data_from_ram;
    output wire [13:0] synth_addr;
    output wire synth_we;
    
    wire we;
    wire [13:0] addr;
    wire [31:0] wdata;
    wire [31:0] rdata;
    
    assign synth_data_to_ram = wdata;
    assign synth_data_from_ram = rdata;
    assign synth_addr = addr;
    assign synth_we = we;

    vscpu cpu (
        .clk(clk),
        .rst(rst),
        .write_enable(we),
        .addr_to_ram(addr),
        .data_from_ram(rdata),
        .data_to_ram(wdata)
    );

    block_ram ram (
        .clk(clk),
        .rst(rst),
        .write_en(we),
        .addr(addr),
        .data_in(wdata),
        .data_out(rdata)
    );

endmodule
