`timescale 1ns/1ps

module tb_top;
  reg clk, rst;
  integer i;

  // Instantiate the design
  top uut(.clk(clk), .rst(rst));

  // Clock generation
  always #5 clk = ~clk;

  // Opcode Constants
  localparam ADD  = 4'h0; localparam ADDi = 4'h1;
  localparam NAND = 4'h2; localparam NANDi= 4'h3;
  localparam SRL  = 4'h4; localparam SRLi = 4'h5;
  localparam LT   = 4'h6; localparam LTi  = 4'h7;
  localparam CP   = 4'h8; localparam CPi  = 4'h9;
  localparam CPI  = 4'hA; localparam CPIi = 4'hB;
  localparam BZJ  = 4'hC; localparam BZJi = 4'hD;
  localparam MUL  = 4'hE; localparam MULi = 4'hF;

  // Encoding Helper Function
  function [31:0] ENC;
    input [3:0]  op;
    input [13:0] A;
    input [13:0] B;
    begin
      ENC = {op, A, B};
    end
  endfunction

  // Function to get Opcode Name
  function [63:0] get_instr_name; 
    input [3:0] op;
    begin
      case(op)
        ADD: get_instr_name = "ADD";   ADDi: get_instr_name = "ADDi";
        NAND: get_instr_name = "NAND"; NANDi: get_instr_name = "NANDi";
        SRL: get_instr_name = "SRL";   SRLi: get_instr_name = "SRLi";
        LT: get_instr_name = "LT";     LTi: get_instr_name = "LTi";
        CP: get_instr_name = "CP";     CPi: get_instr_name = "CPi";
        CPI: get_instr_name = "CPI";   CPIi: get_instr_name = "CPIi";
        BZJ: get_instr_name = "BZJ";   BZJi: get_instr_name = "BZJi";
        MUL: get_instr_name = "MUL";   MULi: get_instr_name = "MULi";
        default: get_instr_name = "UNKNOWN";
      endcase
    end
  endfunction

  // --------------------------------------------------------
  // MONITOR BLOCK
  // --------------------------------------------------------
  reg [31:0] current_ir;
  reg [3:0]  op_code;
  reg [13:0] addrA, addrB;
  
  initial begin
    wait(rst == 0);

    forever begin
      @(posedge clk);

      // CPU State 2: Decode/Execute Start
      if (uut.cpu.st == 2) begin
         
         // STOP CONDITION: If PC exceeds the last instruction address (55)
         if (uut.cpu.PC > 55) begin
             $display("\n====================================================");
             $display(" End of Program reached (PC > 55). Stopping.");
             $display("====================================================");
             $finish; 
         end

         current_ir = uut.cpu.IW;         
         op_code    = current_ir[31:28];  
         addrA      = current_ir[27:14];  
         addrB      = current_ir[13:0];   

         $display("\n****************************************************");
         $display("current_instruction: %s %0d %0d", get_instr_name(op_code), addrA, addrB);
         $display("program counter    : %0d", uut.cpu.PC);
         
         $display("Memory content before executing instruction");
         // Only print if address is in Data Segment range (>= 100)
         if (addrA >= 100) $display("mem[ %0d ] : %0d", addrA, uut.ram.memory[addrA]);
         if (addrB >= 100) $display("mem[ %0d ] : %0d", addrB, uut.ram.memory[addrB]);
         
         // Wait for instruction to finish (State returns to 0)
         wait(uut.cpu.st == 0);
         // Wait one extra cycle for Write-Back to complete
         @(posedge clk); 

         $display("Memory content after executing instruction");
         if (addrA >= 100) $display("mem[ %0d ] : %0d", addrA, uut.ram.memory[addrA]);
         if (addrB >= 100) $display("mem[ %0d ] : %0d", addrB, uut.ram.memory[addrB]);
         $display("****************************************************");
      end
    end
  end

  // --------------------------------------------------------
  // MAIN TEST BLOCK (Program Loader)
  // --------------------------------------------------------
  initial begin
    clk = 0;
    rst = 1;

    // Clear Memory
    for(i=0; i<16384; i=i+1) uut.ram.memory[i] = 0;

    // --- PROGRAM CODE ---
    uut.ram.memory[0]  = ENC(CPi , 14'd110, 14'd3);     
    uut.ram.memory[1]  = ENC(ADD , 14'd100, 14'd101);   
    uut.ram.memory[2]  = ENC(MUL , 14'd100, 14'd102);   
    uut.ram.memory[3]  = ENC(SRLi, 14'd102, 14'd1);     
    uut.ram.memory[4]  = ENC(CP  , 14'd104, 14'd100);   
    uut.ram.memory[5]  = ENC(ADDi, 14'd104, 14'd5);     
    uut.ram.memory[6]  = ENC(NAND, 14'd104, 14'd108);   
    uut.ram.memory[7]  = ENC(NANDi,14'd104, 14'd5);     
    uut.ram.memory[8]  = ENC(SRL , 14'd108, 14'd102);   
    uut.ram.memory[9]  = ENC(MULi, 14'd108, 14'd3);     
    uut.ram.memory[10] = ENC(ADD , 14'd110, 14'd103);   
    uut.ram.memory[11] = ENC(CP  , 14'd112, 14'd110);   
    uut.ram.memory[12] = ENC(LT  , 14'd112, 14'd111);   
    uut.ram.memory[13] = ENC(BZJ , 14'd111, 14'd112);   
    uut.ram.memory[14] = ENC(BZJi, 14'd101, 14'd11);    

    uut.ram.memory[19] = ENC(MULi, 14'd101, 14'd3);     
    uut.ram.memory[20] = ENC(CP  , 14'd105, 14'd102);   
    uut.ram.memory[21] = ENC(LTi , 14'd105, 14'd2);     
    uut.ram.memory[22] = ENC(BZJ , 14'd113, 14'd105);   

    uut.ram.memory[35] = ENC(BZJi, 14'd111, 14'd53);    

    uut.ram.memory[54] = ENC(CPIi, 14'd114, 14'd111);   
    uut.ram.memory[55] = ENC(CPI , 14'd121, 14'd102);   

    // --- DATA ---
    uut.ram.memory[100] = 32'd5;
    uut.ram.memory[101] = 32'd8;
    uut.ram.memory[102] = 32'd16;
    uut.ram.memory[103] = 32'hFFFFFFFF;
    uut.ram.memory[108] = 32'd65543;
    uut.ram.memory[111] = 32'd1;
    uut.ram.memory[113] = 32'd35;
    uut.ram.memory[114] = 32'd120;

    // Release Reset
    #20 rst = 0;
  end

endmodule