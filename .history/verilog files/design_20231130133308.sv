`timescale 1ns / 1ps

// Accumulator
module Accumulator (
    input wire clk, // Clock
    input wire reset, // Reset
    input wire [15:0] data_in,
    output reg [15:0] acc
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        acc <= 16'b0;
    end else begin
        acc <= acc + data_in;
    end
end

endmodule

// Program Counter
module ProgramCounter (
    input wire clk,
    input wire reset,
    input wire jump,
    input wire [15:0] jump_addr,
    output reg [15:0] pc
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pc <= 16'b0;
    end else if (jump) begin
        pc <= jump_addr;
    end else begin
        if (pc == 16'hFFFF) begin
            $display("Warning: Program Counter overflow");
            pc <= 16'b0;
        end else begin
            pc <= pc + 1;
        end
    end
end

endmodule

// Memory Access Register
module MAR (
    input wire clk,
    input wire reset,
    input wire [15:0] addr_in,
    output reg [15:0] addr_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        addr_out <= 16'b0;
    end else begin
        addr_out <= addr_in;
    end
end

endmodule

// Memory Buffer Register
module MBR (
    input wire clk,
    input wire reset,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 16'b0;
    end else begin
        data_out <= data_in;
    end
end

endmodule

// Instruction Register
module IR (
    input wire clk,
    input wire reset,
    input wire [15:0] instr_in,
    output reg [15:0] instr_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        instr_out <= 16'b0;
    end else begin
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
        default: result = 16'b0;  // Default case
    endcase
end

endmodule


// Main memory
module MainMemory (
    input wire clk,
    input wire [15:0] addr,
    input wire [15:0] data_in,
    input wire write_enable,
    output reg [15:0] data_out
);

    // Declare a 16Ki x 16 memory array
    reg [15:0] memory [0:16383];

    always @(posedge clk) begin
        if (write_enable) begin
            // Write data_in to the memory location specified by addr
            memory[addr] <= data_in;
        end else begin
            // Read data from the memory location specified by addr
            data_out <= memory[addr];
        end
    end

endmodule
