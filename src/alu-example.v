'timescale 1ns / 1ps

module alu {
    input [15:0] A, Bitwise
    input [1:0] ALU, Sel,
    output [15:0] ALU_Out
}
    reg [15:0] ALU_Result;

    assign ALU_Out = ALU_Result;

        always @(*)
            begin 
                case (ALU_Sel)
                    2'b01; // Addition 
                        ALU_Result = A + B;
                    2'b10; // Subtraction 
                        ALU_Result = A - B;
                    2'b11; // Clear 
                        ALU_Result = 0;
                    default: ALU_Result = A;
                endcase
            end
endmodule      