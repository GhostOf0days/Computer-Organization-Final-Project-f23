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

parameter CLOCK_PERIOD = 100;  // Default clock period in nanoseconds

// Clock
module Clock(output reg signal)
    local parameter HALF_PERIOD = CLOCK_PERIOD /2
    initial begin
        forever begin
            signal = 1;
            #(HALF_PERIOD);  // Wait for half the clock period
            signal = 0;
            #(HALF_PERIOD);  // Wait for half the clock period
        end
    end
endmodule

// Register
module Register (
    input wire clock,
    input wire [15:0] data_in,
    input wire write,
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
        4'b1011: result = operand1 ~| operand2;  // NOR
        4'b1100: result = operand1 ~& operand2;  // NAND
        4'b1101: result = operand1 ~^ operand2;  // XNOR
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

    // Declare a 16Ki x 8 memory array
    reg [7:0] memory [0:16383];

    always @(posedge clk) begin
        if (write_enable) begin
            // Write the lower 8 bits of data_in to the memory location specified by addr
            memory[addr] <= data_in[7:0];
            // Write the upper 8 bits of data_in to the next memory location
            memory[addr + 1'b1] <= data_in[15:8];
        end else begin
            // Read 8 bits from the memory location specified by addr and the next location
            // Combine them to form a 16-bit data_out
            data_out <= {memory[addr + 1'b1], memory[addr]};
        end
    end

endmodule

module Control(
    input wire clk,
    input wire reset,
    input wire [15:0] instruction,
    output reg [15:0] mar,
    output reg [15:0] mbr,
    output reg [15:0] acc,
    output reg [15:0] pc,
    output wire write_enable,  // Signal to write to memory
    output reg jump,           // Signal to jump (for PC)
);
    // Opcode and Operand extraction from instruction
    wire [3:0] opcode = instruction[15:12]; // Opcode is in the upper 4 bits
    wire [11:0] operand = instruction[11:0]; // Operand is in the lower 12 bits
    
    // control logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset logic
            pc <= 16'b0;
            acc <= 16'b0;
            mar <= 16'b0;
            mbr <= 16'b0;
        end else begin
            case (opcode)
                4'b0000: begin // Add
                    // Implement add logic
                end

                4'b0001: begin // Halt
                    // Implement halt logic (stop clock or enter idle state)
                end

                4'b0010: begin // Load 
                    // Implement load logic (must be little endian - see Discord)
                end

                4'b0011: begin // Store
                    // Implement store logic (must be little endian - see Discord)
                end

                4'b0100: begin // Clear
                    // Implement clear logic
                end

                4'b0101: begin // Skip
                    // Implement skip logic
                end

                4'b0110: begin // Jump
                    // Implement jump logic
                end

                default: begin
                    // Default case/undefined opcode
                end

            endcase
        end
    end

    /* Commented Out - Start
    reg [2:0] instr_step = 3'b0;
    always @(posedge clock) 
        begin
        case(instr_step)
            3'b000: begin
                write_ir <= 1;
                instr_step <= 3'b001;
                mar = X;
                mbr = M[X];
                ALU alu(.opcode(4'b0000), .operand1(acc), .operand2(mbr), .result(acc));
            end
            3'b001: begin
                
            end
            default:
            
        endcase
    end
    Commented Out - End */

endmodule

module Computer
    wire clock;

    Clock clockmodule(.signal(clock));
    Register acc();
    Register mar();
    Register mbr();
    Register ir();
    Register pc();
    MainMemory instr_mem();

endmodule