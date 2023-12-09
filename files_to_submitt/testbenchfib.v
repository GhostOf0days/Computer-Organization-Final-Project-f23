`timescale 1 ns / 1 ps

module test_cpu;
    parameter ADDR_WIDTH = 14;
    parameter DATA_WIDTH = 16;
    
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
    
    reg [15:0] A;
    reg [15:0] B;
    reg [15:0] ALU_Out;
    reg [1:0] ALU_Sel;
    alu alu16(
         .A(A),
         .B(B),  // ALU 16-bit Inputs
         .ALU_Sel(ALU_Sel),// ALU Selection
         .ALU_Out(ALU_Out) // ALU 16-bit Output
        );
    
    reg [15:0] PC = 'h100;
    reg [15:0] IR = 'h0;
    reg [15:0] MBR = 'h0;
    reg [15:0] Accumulator = 'h0;

    initial osc = 1;  //init clk = 1 for positive-edge triggered
    always begin  // Clock wave
        #period  osc = ~osc;
    end

    initial begin
        
        $dumpfile("dump.vcd");
        $dumpvars;
         // Fibonacci Number 11 Calculator
            @(posedge clk) MAR <= 'h100; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'2128; // Load the loop counter (9)
            @(posedge clk) MAR <= 'h102; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'312A; // Store the loop counter into counter
            @(posedge clk) MAR <= 'h104; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'2122; // Load FibNum0 into AC
            @(posedge clk) MAR <= 'h106; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'3124; // Store the the first operand into the second
            @(posedge clk) MAR <= 'h108; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'2124; // Load first fibonacci operand into AC
            @(posedge clk) MAR <= 'h10A; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'0122; // Add the first operand to the second operand 
            @(posedge clk) MAR <= 'h10C; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'3126; // Store result into second (second = 0, will be updated later)
            @(posedge clk) MAR <= 'h10E; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'2124; // Load the second fibonacci operand into AC
            @(posedge clk) MAR <= 'h110; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'3122; // Store the second fibonacci operand into the first 
            @(posedge clk) MAR <= 'h112; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'2126; // Store second operand into first
            @(posedge clk) MAR <= 'h114; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'3124; // Store the second operand into the the first 
            @(posedge clk) MAR <= 'h116; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'212A; // Load  Counter into AC
            @(posedge clk) MAR <= 'h118; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'012C; // Dectement to the counter 
            @(posedge clk) MAR <= 'h11A; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'312A; // Update Counter
            @(posedge clk) MAR <= 'h11C; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'5400; // Check if loop counter is 0 and end
            @(posedge clk) MAR <= 'h11E; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'6108; // Jump back to the loop start
            @(posedge clk) MAR <= 'h120; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'1000; // End of the program
            @(posedge clk) MAR <= 'h122; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'0000; // Initial value of first fibonacci operand
            @(posedge clk) MAR <= 'h124; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'0001; // Initial value of second fibonacci operand
            @(posedge clk) MAR <= 'h126; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'0000; // Initial value for fibonacci nuber
            @(posedge clk) MAR <= 'h128; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'0009; // Counter set to 11 for F11
            @(posedge clk) MAR <= 'h12A; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'0000; // Temporary counter for loop control
            @(posedge clk) MAR <= 'h12C; we <= 1; cs <= 1; oe <= 0; testbench_data <= h'FFFF; // Used to decrement by 1

        @(posedge clk) PC <= 'h100;
    
        while (halt == 0) begin
            // Fetch
            @(posedge clk) MAR <= PC; we <= 0; cs <= 1; oe <= 1;
            @(posedge clk) IR <= data;
            @(posedge clk) PC <= PC + 2;
            // Decode and execute
    $display("IR = %h", IR);
    $display("PC = %h", PC);
    case(IR[15:12])
        4'b0001: begin
            @(posedge clk) MAR <= IR[11:0];
            @(posedge clk) MBR <= data;
            @(posedge clk) Accumulator <= MBR;
        end 
        // Load Accumulator from memory
        4'b0010: begin
            @(posedge clk) MAR <= IR[11:0];
            @(posedge clk) MBR <= Accumulator;
            @(posedge clk) we <= 1; oe <= 0; testbench_data <= MBR;      
        end
        // Store AC to memory
        4'b0011: begin
            @(posedge clk) MAR <= IR[11:0];
            @(posedge clk) MBR <= data;
            @(posedge clk) ALU_Sel <= 'b01; A <= Accumulator; B <= MBR;
            @(posedge clk) Accumulator <= ALU_Out;
        end
        // Add AC to memory
        4'b0111: begin
            @(posedge clk) PC <= PC - 2;
        end
        // Jump to address
        4'b1000: begin
        @(posedge clk)
        if(IR[11:10]==2'b01 && Accumulator == 0) PC <= PC + 2;
        else if(IR[11:10]==2'b00 && Accumulator < 0) PC <= PC + 2;
        else if(IR[11:10]==2'b10 && Accumulator > 0) PC <= PC + 2;
        end
        // Jump if AC is zero
        4'b1001: begin
            @(posedge clk) PC <= IR[11:0];
        end
        // Jump to address
        4'b1010: begin
        @(posedge clk) Accumulator <= 0;
        end
          // Clear AC
        4'b1011: begin
            @(posedge clk) Accumulator <= Accumulator + 1;
        end
        // Increment AC
        4'b1100: begin
            @(posedge clk) Accumulator <= Accumulator - 1;
        end
        // Decrement AC
        4'b1101: begin
            @(posedge clk) ALU_Sel <= 'b00; A <= Accumulator; B <= IR[11:0];
            @(posedge clk) Accumulator <= ALU_Out;
        end
        // Add immediate to AC
        4'b1110: begin
            @(posedge clk) ALU_Sel <= 'b10; A <= Accumulator; B <= IR[11:0];
            @(posedge clk) Accumulator <= ALU_Out;
        end
        // Subtract immediate from AC
        4'b1111: begin
            @(posedge clk) ALU_Sel <= 'b11; A <= Accumulator; B <= IR[11:0];
            @(posedge clk) Accumulator <= ALU_Out;
        end
        // AND immediate with ACCUMULATOR
        default: begin
            @(posedge clk) PC <= PC - 2;
        end
            
            
        endcase     
        // display PC, IR, ACCUMULATOR, MBR, MAR
        @(posedge clk) $display("PC = %h, IR = %h, Accumulator = %h, MBR = %h, MAR = %h", PC, IR, Accumulator, MBR, MAR);
        @(posedge clk) $display("ALU_Out = %h", ALU_Out);
        @(posedge clk) $display("ALU_Sel = %h", ALU_Sel);
        @(posedge clk) $display("A = %h", A);
        @(posedge clk) $display("B = %h", B);
        @(posedge clk) $display("data = %h", data);
        @(posedge clk) $display("testbench_data = %h", testbench_data);
        @(posedge clk) $display("we = %h", we);
        @(posedge clk) $display("oe = %h", oe);
        @(posedge clk) $display("cs = %h", cs);
        @(posedge clk) $display("halt = %h", halt);
        @(posedge clk) $display("osc = %h", osc);
        @(posedge clk) $display("period = %h", period);
        @(posedge clk) $display("clk = %h", clk);
        @(posedge clk) $display("i = %h", i);
        @(posedge clk) $display("ADDR_WIDTH = %h", ADDR_WIDTH);
        @(posedge clk) $display("DATA_WIDTH = %h", DATA_WIDTH);
        @(posedge clk) $display("ALU_Out = %h", ALU_Out);
        @(posedge clk) $display("ALU_Sel = %h", ALU_Sel);
    end
            @(posedge clk) MAR <= 'h10D; we <= 0; cs <= 1; oe <= 1;
            
            @(posedge clk)
                
         #20 $finish;
        end

    endmodule
