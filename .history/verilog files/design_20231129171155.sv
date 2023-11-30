`timescale 1ns / 1ps

// Accumulator
module Accumulator (
    input wire clk,
    input wire reset,
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
    input wire [2:0] opcode,
    input wire [15:0] operand1,
    input wire [15:0] operand2,
    output reg [15:0] result
);

always @(*) begin
    case (opcode)
        3'b000: result = operand1 + operand2;  // Addition
        3'b001: result = operand1 - operand2;  // Subtraction
        3'b010: result = operand1 & operand2;  // Bitwise AND
        3'b011: result = operand1 | operand2;  // Bitwise OR
        3'b100: result = operand1 ^ operand2;  // Bitwise XOR
        default: result = 16'b0;               // Default case
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
