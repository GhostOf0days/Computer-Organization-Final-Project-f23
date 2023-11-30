// LOAD 0x2
// ADD 0x3
// STORE 0x4
// HALT

initial begin
    // Initialize signals
    clk = 0;
    reset = 1;
    AC = 16'b0;
    // Initialize main memory with the binary representation of the assembly program
    M[0] = 16'b0000_0000_0010;  // LOAD 0x2
    M[1] = 16'b0010_0000_0011;  // ADD 0x3
    M[2] = 16'b0001_0000_0100;  // STORE 0x4
    M[3] = 16'b1001_0000_0000;  // HALT
    // Initialize the rest of main memory to zero
    for (integer i = 4; i < 16384; i = i + 1) begin
        M[i] = 16'b0;
    end
end
