// Testbench
module Testbench;
    reg clk;
    reg reset;
    reg jump;
    reg [15:0] jump_addr;
    reg [15:0] data_in;
    wire [15:0] acc;
    wire [15:0] pc;

    // Instantiate the Accumulator and ProgramCounter
    Accumulator u1 (
        .clk(clk), 
        .reset(reset), 
        .data_in(data_in), 
        .acc(acc)
    );

    ProgramCounter u2 (
        .clk(clk), 
        .reset(reset), 
        .jump(jump),
        .jump_addr(jump_addr),
        .pc(pc)
    );

    // Clock process
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Stimulus process
    initial begin
        // Initialize inputs
        reset = 1;
        jump = 0;
        jump_addr = 0;
        data_in = 0;
        #20 reset = 0;
        #20 data_in = 16'h1234;
        #20 jump = 1; jump_addr = 16'h5678;
        #20 data_in = 16'h9abc;
        #20 jump = 0;
        #20 data_in = 16'hdef0;
        #20 jump = 1; jump_addr = 16'h1234;
        #20 $finish;
    end

    // Monitor process
    initial begin
        $monitor("At time %d, data_in = %h, acc = %h, jump = %b, jump_addr = %h, pc = %h", $time, data_in, acc, jump, jump_addr, pc);
    end

endmodule