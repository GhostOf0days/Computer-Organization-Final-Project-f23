`timescale 1ns / 1ps // Set the timescale to 1 nanosecond / 1 picosecond

// Accumulator
module Accumulator (
    input wire clk, // Clock
    input wire reset, // Reset
    input wire [15:0] data_in, // Data input (16 bits)
    output reg [15:0] acc // Accumulator (16 bits)
);

always @(posedge clk or posedge reset) begin
    if (reset) begin // If reset is asserted, reset the accumulator
        acc <= 16'b0; 
    end else begin // Otherwise, add data_in to the accumulator
        acc <= acc + data_in;
    end
end

endmodule


// Program Counter
module ProgramCounter (
    input wire clk, // Clock
    input wire reset, // Reset
    input wire jump, // Jump enable
    input wire [15:0] jump_addr, // Jump address (16 bits)
    output reg [15:0] pc // Program counter (16 bits)
);

always @(posedge clk or posedge reset) begin
    if (reset) begin // If reset is asserted, reset the program counter
        pc <= 16'b0;
    end else if (jump) begin // If jump is asserted, jump to the address specified by jump_addr
        pc <= jump_addr;
    end else begin // Otherwise, increment the program counter
        if (pc == 16'hFFFF) begin  // If the program counter is at its maximum value, wrap around to 0
            $display("Warning: Program Counter overflow");
            pc <= 16'b0;
        end else begin // Otherwise, increment the program counter
            pc <= pc + 1;
        end
    end
end

endmodule


// Memory Access Register
module MAR (
    input wire clk, // Clock
    input wire reset, // Reset
    input wire [15:0] addr_in, // Address input (16 bits)
    output reg [15:0] addr_out // Address output (16 bits)
);

always @(posedge clk or posedge reset) begin
    if (reset) begin // If reset is asserted, reset the address output
        addr_out <= 16'b0;
    end else begin // Otherwise, set the address output to the address input
        addr_out <= addr_in;
    end
end

endmodule


// Memory Buffer Register
module MBR (
    input wire clk, // Clock
    input wire reset, // Reset
    input wire [15:0] data_in, // Data input (16 bits)
    output reg [15:0] data_out // Data output (16 bits)
);

always @(posedge clk or posedge reset) begin
    if (reset) begin // If reset is asserted, reset the data output
        data_out <= 16'b0;
    end else begin // Otherwise, set the data output to the data input
        data_out <= data_in;
    end
end

endmodule


// Instruction Register
module IR (
    input wire clk, // Clock
    input wire reset, // Reset
    input wire [15:0] instr_in, // Instruction input (16 bits)
    output reg [15:0] instr_out // Instruction output (16 bits)
);

always @(posedge clk or posedge reset) begin
    if (reset) begin // If reset is asserted, reset the instruction output
        instr_out <= 16'b0;
    end else begin // Otherwise, set the instruction output to the instruction input
        instr_out <= instr_in;
    end
end

endmodule


// Clock
module Clock (
    input wire stop,
    output reg signal
    );
    localparam CLOCK_PERIOD = 100; // Clock period is 100
    localparam HALF_PERIOD = CLOCK_PERIOD /2;
    initial begin
        forever begin
            if (~stop) begin
                signal = 1;
                #(HALF_PERIOD);  // Wait for half the clock period
                signal = 0;
                #(HALF_PERIOD);  // Wait for half the clock period
            end
        end
    end
endmodule

// Register
module Register (
    input wire clock,
    input wire write,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);

always @(posedge clock) begin
    if (write) begin
        data_out <= data_in;
    end
end

endmodule

// Arithmetic and Logic Unit
module ALU (
    input wire [3:0] opcode, // Operation code size is 4 bits
    input wire [15:0] operand1, // Operands are 16 bits
    input wire [15:0] operand2, // Operands are 16 bits
    output reg [15:0] result, // Result is 16 bits
    output reg cmp_result
);

always @(*) begin
    cmp_result = 0;
    case (opcode)
        4'b0000: result = 16'b0;                // Clear operation
        4'b0001: result = operand2;             // For easy load instruction
        4'b0010: result = operand1 + operand2;  // Addition
        4'b0011: result = operand1 - operand2;  // Subtraction
        4'b0100: result = operand1 << 1;        // Left shift
        4'b0101: result = operand1 >> 1;        // Right shift
        4'b0110: result = {operand1[14:0], operand1[15]};  // Rotate left
        4'b0111: result = {operand1[0], operand1[15:1]};   // Rotate right
        4'b1000: result = operand1 & operand2;  // Bitwise AND
        4'b1001: result = operand1 | operand2;  // Bitwise OR
        4'b1010: result = operand1 ^ operand2;  // Bitwise XOR
        4'b1011: result = operand1 ~| operand2;  // NOR
        4'b1100: result = operand1 ~& operand2;  // NAND
        4'b1101: cmp_result = operand1 < 16'd0 ? 1 : 0;  // Less than
        4'b1110: cmp_result = operand1 == 16'd0 ? 1 : 0;  // Equal to
        4'b1111: cmp_result = operand1 > 16'd0 ? 1 : 0;  // Greater than
        default: result = 16'b0;  // Default case is to set the result to 0
    endcase
end

endmodule


// Main memory
module MainMemory (
    input wire clk, // Clock
    input wire [15:0] addr, // Address (16 bits)
    input wire write_enable, // Write enable (1 bit)
    input wire [15:0] data_in, // Data input (16 bits)
    output reg [15:0] data_out // Data output (16 bits)
);

    // Declare a 16Ki x 8 memory array
    reg [7:0] memory [0:16383];

    always @(posedge clk) begin
        if (write_enable) begin
            // Write the lower 8 bits of data_in to the memory location specified by addr
            memory[addr] <= data_in[7:0];
            // Write the upper 8 bits of data_in to the next memory location
            memory[addr + 1'b1] <= data_in[15:8];
        end
    end

    always @(negedge clk) begin
        // Read 8 bits from the memory location specified by addr and the next location
        // Combine them to form a 16-bit data_out
        data_out <= {memory[addr + 1'b1], memory[addr]};
    end

endmodule

module Control(
    input wire clock,
    input wire [15:0] instruction,
    output reg write_ac,
    output reg write_mar,
    output reg write_mbr,
    output reg write_ir,
    output reg write_pc,
    output reg write_dmem,
    output reg [3:0] aluOP,
    output reg jump,
    output reg clock_stop
);
    // Opcode and Operand extraction from instruction
    wire [3:0] opcode = instruction[15:12]; // Opcode is in the upper 4 bits
    wire [11:0] operand = instruction[11:0]; // Operand is in the lower 12 bits
    // control logic
    initial begin
        clock_stop = 0;
        forever begin
            @(posedge clock);
            // Fetch instruction
            write_ac <= 0;
            write_mar <= 0;
            write_mbr <= 0;
            write_ir <= 1;
            write_pc <= 1;
            write_dmem <= 0;
            aluOP <= 4'b0000;

            @(posedge clock);
            // Instruction decode
            write_ir <= 0;
            write_pc <= 0;
            write_mar <= 1;

            @(posedge clock);
            write_mar <= 0;
            case (opcode)
                4'b0000: begin // Add
                    write_mbr <= 1;
                    @(posedge clock);
                    write_mbr <= 0;
                    aluOP <= 4'b0010;
                    write_ac <= 1;
                end

                4'b0001: begin // Halt
                    clock_stop <= 1; // Stop the clock
                end

                4'b0010: begin // Load 
                    write_mbr <= 1;
                    @(posedge clock);
                    write_mbr <= 0;
                    aluOP <= 4'b0001;
                    write_ac <= 1;
                end

                4'b0011: begin // Store
                    write_dmem <= 1;
                end

                4'b0100: begin // Clear
                    write_mbr <= 1;
                    @(posedge clock);
                    write_mbr <= 0;
                    aluOP <= 4'b0000;
                    write_ac <= 1;
                end

                4'b0101: begin // Skip
                    case (operand)
                        12'd0: aluOP <= 4'b1101;
                        12'd2: aluOP <= 4'b1110;
                        12'd4: aluOP <= 4'b1111;
                        default: $display("Error: Invalid comparison operand");
                    endcase
                end

                4'b0110: begin // Jump
                    jump <= 1;
                    write_pc <= 1;
                end
                //////////// Extra Credit//////////////
                // subtract
                4'b0111: begin
                    write_mbr <= 1;
                    @(posedge clock);
                    write_mbr <= 0;
                    aluOP <= 4'b0011;
                    write_ac <= 1;
                end
                // and x
                4'b1000: begin
                    write_mbr <= 1;
                    @(posedge clock);
                    write_mbr <= 0;
                    aluOP <= 4'b1000;
                    write_ac <= 1;
                end
                // or x
                4'b1001: begin
                    write_mbr <= 1;
                    @(posedge clock);
                    write_mbr <= 0;
                    aluOP <= 4'b1001;
                    write_ac <= 1;
                end
                // not
                4'b1010: begin
                    write_mbr <= 1;
                    @(posedge clock);
                    write_mbr <= 0;
                    aluOP <= 4'b1010;
                    write_ac <= 1;
                end
                // jump with linking
                4'b1011: begin
                    jump <= 1;
                    write_pc <= 1;
                    write_mbr <= 1;
                    @(posedge clock);
                    write_mbr <= 0;
                    aluOP <= 4'b0001;
                    write_ac <= 1;
                end
                // return x
                4'b1100: begin
                    write_mbr <= 1;
                    @(posedge clock);
                    write_mbr <= 0;
                    aluOP <= 4'b0001;
                    write_ac <= 1;
                end

                default: begin
                    // Default case/undefined opcode
                    $display("Error: Invalid opcode"); // Display an error message
                end
            endcase
        end
    end

endmodule

module Mux(
    input wire [15:0] option1, // Option 1 (16 bits)
    input wire [15:0] option2, // Option 2 (16 bits)
    input wire select,         // Select (1 bit)
    output reg [15:0] result   // Result (16 bits)
);
    // Mux logic
    always @(*) begin
        if (select) begin
            result <= option1;
        end else begin
            result <= option2;
        end
    end

endmodule

module Computer();
    wire clock; // Clock
    wire clock_stop;
    Clock clockmodule(clock_stop, clock); // Instantiate the clock module


    // Control setup
    wire [15:0] instr_bus;
    wire write_acc;
    wire write_mar;
    wire write_mbr;
    wire write_ir;
    wire write_pc;
    wire write_dmem;
    wire [3:0] aluOP;
    wire jump;
    Control control(clock, instr_bus, write_acc, write_mar, write_mbr, write_ir, write_pc, write_dmem, aluOP, jump, clock_stop);

    wire [15:0] acc_in;
    wire [15:0] acc_out;
    Register acc(clock, write_acc, acc_in, acc_out);

    wire [15:0] mar_out;

    Register mar(clock, write_mar, {4'b0000, instr_bus[11:0]}, mar_out);

    wire [15:0] mbr_in;
    wire [15:0] mbr_out;
    Register mbr(clock, write_mbr, mbr_in, mbr_out);

    wire [15:0] i_mem_out;
    Register ir(clock, write_ir, i_mem_out, instr_bus);

    wire [15:0] pc_in;
    wire [15:0] pc_out;
    Mux pc_in_mux(pc_out + 1'b1, instr_bus[15:0], jump, pc_in);
    wire skip;
    Register pc(clock, write_pc | skip, pc_in, pc_out);

    MainMemory instr_mem(clock, pc_out, 0, 16'b0, i_mem_out);

    MainMemory data_mem(clock, mar_out, write_dmem, acc_out, mbr_in);

    ALU alu(aluOP, acc_out, mbr_out, acc_in, skip);

endmodule