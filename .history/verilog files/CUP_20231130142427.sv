module CPU (
    input wire clk,
    input wire reset,
    inout wire [15:0] AC,  // Accumulator
    inout wire [15:0] M[0:16383]  // Main memory
);

    // Declare the necessary registers
    reg [15:0] PC;  // Program Counter
    reg [15:0] IR;  // Instruction Register
    reg [15:0] MAR;  // Memory Address Register
    reg [15:0] MBR;  // Memory Buffer Register

    // Fetch instruction
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 16'b0;
        end else begin
            MAR <= PC;
            IR <= M[MAR];
            PC <= PC + 1;
        end
    end

    // Decode and execute instruction
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            AC <= 16'b0;
        end else begin
            case (IR[15:12])  // Assume the opcode is in the upper 4 bits of the instruction
                4'b0000: begin  // LOAD X
                    MAR <= IR[11:0];  // Assume the operand is in the lower 12 bits of the instruction
                    MBR <= M[MAR];
                    AC <= MBR;
                end
                4'b0001: begin  // STORE X
                    MAR <= IR[11:0];
                    M[MAR] <= AC;
                end
                4'b0010: begin  // ADD X
                    MAR <= IR[11:0];
                    MBR <= M[MAR];
                    AC <= AC + MBR;
                end
                4'b0011: begin  // SUB X
                    MAR <= IR[11:0];
                    MBR <= M[MAR];
                    AC <= AC - MBR;
                end
                4'b0100: begin  // AND X
                    MAR <= IR[11:0];
                    MBR <= M[MAR];
                    AC <= AC & MBR;
                end
                4'b0101: begin  // OR X
                    MAR <= IR[11:0];
                    MBR <= M[MAR];
                    AC <= AC | MBR;
                end
                4'b0110: begin  // NOT
                    AC <= ~AC;
                end
                4'b0111: begin  // JUMP X
                    PC <= IR[11:0];
                end
                4'b1000: begin  // JZ X
                    if (AC == 16'b0) begin
                        PC <= IR[11:0];
                    end
                end
                4'b1001: begin  // HALT
                    PC <= PC - 1;
                end
                default: begin  // NOP
                    // Do nothing
                end
            endcase
        end
    end

endmodule
