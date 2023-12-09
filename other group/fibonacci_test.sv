`timescale 1 ns / 1 ps

module test_cpu;
  parameter ADDR_WIDTH = 28;
  parameter DATA_WIDTH = 32;
  
  reg osc;
  localparam period = 10;

  wire clk; 
  assign clk = osc; 

  reg cs;
  reg we;
  reg oe;
  integer i;
  reg [ADDR_WIDTH-1:0] MAR;
  wire [DATA_WIDTH-1:0] data;
  reg [DATA_WIDTH-1:0] testbench_data;
  assign data = !oe ? testbench_data : 'hz;

  single_port_sync_ram_large  #(.DATA_WIDTH(DATA_WIDTH)) ram
  (   .clk(clk),
      .addr(MAR),
      .data(data[DATA_WIDTH-1:0]),
      .cs_input(cs),
      .we(we),
      .oe(oe)
  );
  
  reg [31:0] A;
  reg [31:0] B;
  reg [31:0] ALU_Out;
  reg [3:0] ALU_Sel;
  alu alu32(
    .A(A),
    .B(B),  // ALU 32-bit Inputs
    .ALU_Sel(ALU_Sel),// ALU Selection
    .ALU_Out(ALU_Out) // ALU 32-bit Output
  );
  
  reg [31:0] PC = 'h100;
  reg [31:0] IR = 'h0;
  reg [31:0] MBR = 'h0;
  reg [31:0] AC = 'h0;

  initial osc = 1;  //init clk = 1 for positive-edge triggered
  always begin  // Clock wave
     #period  osc = ~osc;
  end

  integer halt = 0;
  initial begin
   
     $dumpfile("dump.vcd");
    $dumpvars;
    // Fibonacci(11) Program
    // we <-- allows writes, cs <-- chip select, <-- write out
    @(posedge clk) MAR <= 'h100; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1000010D; // Load B into AC    AC = B
    @(posedge clk) MAR <= 'h101; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h5000010C; // Add AC and A      AC = AC + A
    @(posedge clk) MAR <= 'h102; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h2000010D; // Store AC into B   B = AC
    @(posedge clk) MAR <= 'h103; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h6000010C; // Subtract A from AC   AC = AC - A
    @(posedge clk) MAR <= 'h104; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h2000010C; // Store AC into A     A = AC
    @(posedge clk) MAR <= 'h105; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1000010E; // Load N into AC    AC = N
    @(posedge clk) MAR <= 'h106; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h5000010F; // Subtract One from AC = AC - 1
    @(posedge clk) MAR <= 'h107; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h2000010E; // Store AC into N  N = AC
    @(posedge clk) MAR <= 'h108; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h84000000; // Skip next if AC == 0
    @(posedge clk) MAR <= 'h109; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h90000100; // jump loop(100)
    @(posedge clk) MAR <= 'h10A; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1000010D; // Load B into AC (Answer)
    @(posedge clk) MAR <= 'h10B; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h30000000; // halt
    @(posedge clk) MAR <= 'h10C; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h00000000; // A, previous fibonacci number
    @(posedge clk) MAR <= 'h10D; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h00000001; // B, current fibonacci number
    @(posedge clk) MAR <= 'h10E; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h0000000A; // N, terms left(starts at 10 since 1 is before)
    @(posedge clk) MAR <= 'h10F; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'hFFFFFFFF; // Negative One
    

    @(posedge clk) PC <= 'h100;

    while (halt == 0) begin

          // Fetch
          @(posedge clk) MAR <= PC; we <= 0; cs <= 1; oe <= 1;
          @(posedge clk) IR <= data;
          @(posedge clk) PC <= PC + 1;
          // Decode and execute
      $display("IR=%b", IR);
      $display("IR=%b", IR[31:28]);
      case(IR[31:28])
        4'b0001: begin // Load the value from memory to the Accumulator (AC)
              @(posedge clk) MAR <= IR[27:0];
              @(posedge clk) MBR <= data;
              @(posedge clk) AC <= MBR; 
        end 
		    4'b0010: begin // Store the value from the Accumulator (AC) to memory
              @(posedge clk) MAR <= IR[27:0];
              @(posedge clk) MBR <= AC;
              @(posedge clk) we <= 1; oe <= 0; testbench_data <= MBR;      
        end
        4'b0011: begin // Halt
              halt = 1;
        end
        4'b0100: begin // Clear the Accumulator
              @(posedge clk) AC <= 0;
        end
        4'b0101: begin // ALU add operation
              @(posedge clk) MAR <= IR[27:0];
              @(posedge clk) MBR <= data;
              @(posedge clk) ALU_Sel <= 'b0000; A <= AC; B <= MBR;
              @(posedge clk) AC <= ALU_Out;
              $display("Final = %d", ALU_Out);
        end
        4'b0110: begin // ALU subtract operation
              @(posedge clk) MAR <= IR[27:0];
              @(posedge clk) MBR <= data;
              @(posedge clk) ALU_Sel <= 'b0001; A <= AC; B <= MBR;
              @(posedge clk) AC <= ALU_Out;
        end
        4'b0111: begin // Unconditional branch
              @(posedge clk) PC <= PC - 1;
        end
        4'b1000: begin // Conditional branch based on AC 
              $display("IR: %b, AC: %d", IR[27:26], AC);
              @(posedge clk)
              if(IR[27:26]==2'b01 && AC == 0) PC <= PC + 1;
              else if(IR[27:26]==2'b00 && AC < 0) PC <= PC + 1;
              else if(IR[27:26]==2'b10 && AC > 0) PC <= PC + 1;
        end
        4'b1001: begin // Direct jump to a specified address
              @(posedge clk) PC <= IR[27:0];
        end
        4'b1010: begin // ALU And instruction
              @(posedge clk) MAR <= IR[27:0];
              @(posedge clk) MBR <= data;
              @(posedge clk) ALU_Sel <= 'b0110; A <= AC; B <= MBR;
              @(posedge clk) AC <= ALU_Out;
        end
        4'b1011: begin // ALU Or instruction
              @(posedge clk) MAR <= IR[27:0];
              @(posedge clk) MBR <= data;
              @(posedge clk) ALU_Sel <= 'b1000; A <= AC; B <= MBR;
              @(posedge clk) AC <= ALU_Out;
        end
        4'b1100: begin // Not instruction
              @(posedge clk) AC <= !AC;
        end
        4'b1101: begin // Jump with linking X instruction
              @(posedge clk) MAR <= IR[27:0];
              @(posedge clk) MBR <= PC + 1;
              @(posedge clk) we <= 1; oe <= 0; testbench_data <= MBR;
              @(posedge clk) AC <= IR[27:0] + 1;
              @(posedge clk) PC <= AC;
        end
        4'b1110: begin // Return X
              @(posedge clk) MAR <= IR[27:0];
              @(posedge clk) MBR <= data;
              @(posedge clk) MAR <= MBR;
              @(posedge clk) we <= 1; oe <= 0; MBR <= testbench_data;
              @(posedge clk) PC <= MBR;
        end
          
      endcase
      
      $display("PC=0x%h, IR=0x%d, AC=0x%h, MBR=0x%h, ALU_Out=0x%b, HALT=%d", PC, IR[15:12], AC, MBR, ALU_Out, halt);
    end
    $display("Final values: AC=0x%h, MBR=0x%h, PC=0x%h", AC, MBR, PC);
    
      
    @(posedge clk) MAR <= 'h10D; we <= 0; cs <= 1; oe <= 1;
    
    @(posedge clk)
        
   #20 $finish;
  end

endmodule