`timescale 1ns / 1ps // Set the timescale to 1 nanosecond / 1 picosecond

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
        if (write_enable) begin // Write data_in to the memory location specified by addr
            memory[addr] <= data_in;
        end else begin // Read data from the memory location specified by addr
            data_out <= memory[addr];
        end
    end

endmodule

module Control(
    input wire clock,
    input wire [15:0] instruction;
    output reg write_ir;
);
    // 
    reg [2:0] instr_step = 3'b0;
    always @(posedge clock) begin
        case(instr_step)
            3'b000: begin
                write_ir <= 1;
                instr_step <= 3'b001;
                mar = X;
                mbr = M[X];
                acc = acc + mbr;
            end
            3'b001: begin
                write_ir <= 1;
                instr_step <= 3'b010;
                mar = X;
                mbr = M[X];
                acc = acc + mbr;
            end
            3'b010: begin
                write_ir <= 1;
                instr_step <= 3'b011;
                mar = X;
                mbr = M[X];
                acc = acc + mbr;
            end
            3'b011: begin
                write_ir <= 1;
                instr_step <= 3'b100;
                mar = X;
                mbr = M[X];
                acc = acc + mbr;
            end
            
            end
            default:
            
        endcase
    end
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