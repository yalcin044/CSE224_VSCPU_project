// SUB and SUBi defined as 4b'0000 and 4'b0001
// Remove commands to run SUB and SUBi, take under commands ADD and ADDi 

`timescale 1ns / 1ps

module vscpu(clk, rst, write_enable, addr_to_ram, data_from_ram, data_to_ram);
    input clk, rst;
    input [31:0] data_from_ram;
    
    output reg write_enable;
    output reg [31:0] data_to_ram;
    output reg [13:0] addr_to_ram;
    
    reg [2:0] st, stN;
    reg [13:0] PC, PCN;
    reg [31:0] IW, IWN;
    reg [31:0] R1, R1N;
    
    always @ (posedge clk) begin
        st <= stN;
        PC <= PCN;
        IW <= IWN;
        R1 <= R1N;
    end
    
    always @ * begin
        if (rst) begin
            // Reset
            stN = 3'd0;
            PCN = 14'd0;
            
            addr_to_ram = 14'd0;
            write_enable = 0;
            data_to_ram = 0;
            R1N = 0;
            IWN = 0;
        end
        
        else begin
            // Default Assignment
            write_enable = 1'b0;
            PCN = PC;
            IWN = IW;
            stN = 3'dx;
            addr_to_ram = 14'hX;
            data_to_ram = 32'hX;
            R1N = R1;
            
            case (st)
                3'd0 : begin
                    addr_to_ram = PC;
                    stN = 3'd1;
                end
                
                3'd1 : begin
                    IWN = data_from_ram;          
                    addr_to_ram = data_from_ram[27:14];
                    stN = 3'd2; 
                end
                3'd2 : begin
                    case (IW[31:28])
                        /*
                        4'b0000 : begin // SUB
                            R1N = data_from_ram;    // R1 <- mem[A]
                            addr_to_ram = IW[13:0]; // B adresini oku
                            stN = 3'd3;
                        end
                        */
                        4'b0000 : begin // ADD - 0
                            R1N = data_from_ram;      
                            addr_to_ram = IW[13:0];
                            stN = 3'd3;
                        end
                        /*
                        4'b0001 : begin // SUBi
                            addr_to_ram = IW[27:14];
                            data_to_ram = data_from_ram - IW[13:0];
                            write_enable = 1'b1;
                            PCN = PC + 14'd1;
                            stN = 3'd0;
                        end
                        */
                        4'b0001 : begin // ADDi - 1
                            addr_to_ram = IW[27:14];
                            data_to_ram = data_from_ram + IW[13:0];
                            
                            write_enable = 1'b1;
                            PCN = PC + 14'd1;
                            stN = 3'd0;
                        end
                        4'b0010 : begin // NAND - 2
                            R1N = data_from_ram;      
                            addr_to_ram = IW[13:0];
                            stN = 3'd3;
                        end
                        4'b0011 : begin // NANDi - 3
                            addr_to_ram = IW[27:14];
                            data_to_ram = ~ (data_from_ram & IW[13:0]);
                            
                            write_enable = 1'b1;
                            PCN = PC + 14'd1;
                            stN = 3'd0;
                        end
                        4'b0100 : begin // SRL - 4
                            R1N = data_from_ram;
                            addr_to_ram = IW[13:0];
                            stN = 3'd3;
                        end
                        4'b0101 : begin // SRLi - 5
                            addr_to_ram = IW[27:14];
                            data_to_ram = (IW[13:0] < 14'd32) ? (data_from_ram >> IW[13:0]) : (data_from_ram << (IW[13:0] - 14'd32));
                            
                            write_enable = 1'b1;
                            PCN = PC + 14'd1;
                            stN = 3'd0;
                        end
                        4'b0110 : begin // LT - 6
                            R1N = data_from_ram;
                            addr_to_ram = IW[13:0];
                            stN = 3'd3;                                                         
                        end
                        4'b0111 : begin // LTi - 7
                            addr_to_ram = IW[27:14];
                            data_to_ram = (data_from_ram < IW[13:0]) ? 32'd1 : 32'd0;
                            
                            write_enable = 1'b1;
                            PCN = PC + 14'd1;
                            stN = 3'd0;
                        end
                        4'b1000 : begin // CP - 8
                            addr_to_ram = IW[13:0];
                            stN = 3'd3;
                        end
                        4'b1001 : begin // CPi - 9
                            addr_to_ram = IW[27:14];
                            data_to_ram = IW[13:0];
                        
                            write_enable = 1'b1;
                            PCN = PC + 14'd1;
                            stN = 3'd0;
                        end
                        4'b1010 : begin // CPI - 10
                            addr_to_ram = IW[13:0];
                            stN = 3'd3;
                        end
                        4'b1011 : begin // CPIi - 11
                            R1N = data_from_ram;
                            addr_to_ram = IW[13:0];
                            stN = 3'd3;
                        end
                        4'b1100 : begin // BZJ - 12
                            R1N = data_from_ram;
                            addr_to_ram = IW[13:0];
                            stN = 3'd3;
                        end
                        4'b1101 : begin // BZJi - 13
                            PCN = data_from_ram[13:0] + IW[13:0];
                            stN = 3'd0;
                        end
                        4'b1110 : begin // MUL - 14
                            R1N = data_from_ram;
                            addr_to_ram = IW[13:0];
                            stN = 3'd3;
                        end
                        4'b1111 : begin // MULi - 15
                            addr_to_ram = IW[27:14];
                            data_to_ram = data_from_ram * IW[13:0];
                            write_enable = 1'b1;
                            PCN = PC + 14'd1;
                            stN = 3'd0;
                        end
                    endcase
                            
                end
                3'd3 : begin
                    case (IW[31:28])
                        /*
                        4'b0000 : begin // SUB
                            addr_to_ram = IW[27:14];
                            data_to_ram = R1 - data_from_ram;
                            write_enable = 1'b1;
                            PCN = PC + 14'd1;
                            stN = 3'd0;
                        end
                        */
                        4'b0000 : begin // ADD - 0
                            addr_to_ram = IW[27:14];
                            data_to_ram = R1 + data_from_ram;
                            
                            write_enable = 1'b1;
                            PCN = PC + 14'd1;
                            stN = 3'd0;
                        end
                        4'b0010 : begin // NAND - 2
                            addr_to_ram = IW[27:14];
                            data_to_ram = ~ (R1 & data_from_ram);
                            
                            write_enable = 1'b1;
                            PCN = PC + 14'd1;
                            stN = 3'd0;
                        end
                        4'b0100 : begin // SRL - 4
                            addr_to_ram = IW[27:14];
                            data_to_ram = (data_from_ram < 32) ? (R1 >> data_from_ram) : (R1 << (data_from_ram - 32));
                        
                            write_enable = 1'b1;
                            PCN = PC + 14'd1;
                            stN = 3'd0;
                        end
                        4'b0110 : begin // LT - 6
                            addr_to_ram = IW[27:14];
                            data_to_ram = (R1 < data_from_ram) ? 32'd1 : 32'd0;
                        
                            write_enable = 1'b1;
                            PCN = PC + 14'd1;
                            stN = 3'd0;
                        end
                        4'b1000 : begin // CP - 8
                            addr_to_ram = IW[27:14];
                            data_to_ram = data_from_ram;
                        
                            write_enable = 1'b1;
                            PCN = PC + 14'd1;
                            stN = 3'd0;
                        end
                        4'b1010 : begin // CPI - 10
                            R1N = data_from_ram;
                            addr_to_ram = data_from_ram[13:0];
                            stN = 3'd4;
                        end
                        4'b1011 : begin // CPIi - 11
                            addr_to_ram  = R1[13:0];
                            data_to_ram  = data_from_ram;
                            
                            write_enable = 1'b1;
                            PCN = PC + 14'd1;
                            stN = 3'd0;
                        end
                        4'b1100 : begin // BZJ - 12
                            if (data_from_ram == 32'd0)
                                PCN = R1[13:0];
                            else
                                PCN = PC + 14'd1;
                            stN = 3'd0;
                        end
                        4'b1110 : begin // MUL - 14
                            addr_to_ram = IW[27:14];
                            data_to_ram = R1 * data_from_ram;
                            
                            write_enable = 1'b1;
                            PCN = PC + 14'd1;
                            stN = 3'd0;
                        end
                    endcase
                end
                3'd4 : begin
                    case (IW[31:28])
                        4'b1010 : begin // CPI - 10
                            addr_to_ram  = IW[27:14];
                            data_to_ram  = data_from_ram; 
                            
                            write_enable = 1'b1;
                            PCN = PC + 14'd1;
                            stN = 3'd0;
                        end
                        default: begin
                            stN = 3'd0;
                        end
                    endcase
                end              
            endcase
        end
    end             
endmodule
