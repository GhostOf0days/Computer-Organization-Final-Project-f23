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


// Arithmetic and Logic Unit
module ALU (
    input wire [3:0] opcode, // Operation code size is 4 bits
    input wire [15:0] operand1, // Operands are 16 bits
    input wire [15:0] operand2, // Operands are 16 bits
    output reg [15:0] result // Result is 16 bits
);

always @(*) begin
    case (opcode)
        4'b0000: result = operand1 + operand2;  // Addition
        4'b0001: result = operand1 - operand2;  // Subtraction
        4'b0010: result = operand1 * operand2;  // Multiplication
        4'b0011: result = operand1 / operand2;  // Division
        4'b0100: result = operand1 << 1;        // Left shift
        4'b0101: result = operand1 >> 1;        // Right shift
        4'b0110: result = {operand1[14:0], operand1[15]};  // Rotate left
        4'b0111: result = {operand1[0], operand1[15:1]};   // Rotate right
        4'b1000: result = operand1 & operand2;  // Bitwise AND
        4'b1001: result = operand1 | operand2;  // Bitwise OR
        4'b1010: result = operand1 ^ operand2;  // Bitwise XOR
        4'b1011: result = ~(operand1 | operand2);  // NOR
        4'b1100: result = ~(operand1 & operand2);  // NAND
        4'b1101: result = ~(operand1 ^ operand2);  // XNOR
        4'b1110: result = operand1 > operand2 ? 16'd1 : 16'd0;  // Greater than
        4'b1111: result = operand1 == operand2 ? 16'd1 : 16'd0;  // Equal to
        default: result = 16'b0;  // Default case is to set the result to 0
    endcase
end

endmodule


// Main memory
module MainMemory (
    input wire clk, // Clock
    input wire [15:0] addr, // Address (16 bits)
    input wire [15:0] data_in, // Data input (16 bits)
    input wire write_enable, // Write enable (1 bit)
    output reg [15:0] data_out // Data output (16 bits)
);

    // Declare a 16Ki x 16 memory array
    reg [15:0] memory [0:16383];

    always @(posedge clk) begin
        if (write_enable) begin // Write data_in to the memory location specified by addr
            memory[addr] <= data_in;
        end else begin // Read data from the memory location specified by addr
            data_out <= memory[addr];
        end
    end

endmodule

// Add X operation
module AddX (
    input wire clk,
    input wire reset,
    input wire [15:0] X,  // The value to add
    inout wire [15:0] AC,  // Accumulator
    inout wire [15:0] M[0:16383]  // Main memory
);

    // Declare the necessary registers
    reg [15:0] MAR;  // Memory Address Register
    reg [15:0] MBR;  // Memory Buffer Register

    // Load X into MAR
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MAR <= 16'b0;
        end else begin
            MAR <= X;
        end
    end

    // Load value stored at address X into MBR
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MBR <= 16'b0;
        end else begin
            MBR <= M[MAR];
        end
    end

    // Add value in AC with MBR value and store it back into AC
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            AC <= 16'b0;
        end else begin
            AC <= AC + MBR;
        end
    end

endmodule

