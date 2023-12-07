`timescale 1ns / 1ps

module tb_ram;
    // Parameters
    parameter ADDR_WIDTH = 13;
    parameter DATA_WIDTH = 8;
    parameter LENGTH = (1<<ADDR_WIDTH);

    // Signals
    reg clk;
    reg [ADDR_WIDTH-1:0] addr;
  reg [DATA_WIDTH-1:0] data_in;
    reg cs; // Chip select
    reg we; // Write enable
    reg oe; // Output enable

    // Instantiate the RAM
    ram #(ADDR_WIDTH, DATA_WIDTH, LENGTH) u_ram (
        .clk(clk),
        .addr(addr),
      .data_in(data_in),
        .cs(cs),
        .we(we),
        .oe(oe)
    );

    // Clock generator
    always begin
        #5 clk = ~clk;
    end

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        addr = 0;
        data_in = 0;
        cs = 0;
        we = 0;
        oe = 0;

        // Wait for a clock period
        #10;

        // Write data to the RAM
        cs = 1;
        we = 1;
        for (addr = 0; addr < LENGTH; addr = addr + 1) begin
            data_in = addr[DATA_WIDTH-1:0];
            #10;
        end

        // Deassert write enable
        we = 0;

        // Read and check data from the RAM
        oe = 1;
        
        
        // Deassert chip select and output enable
        cs = 0;
        oe = 0;

        // End the simulation
        #10;
        $finish;
    end
endmodule