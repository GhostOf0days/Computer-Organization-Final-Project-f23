// Adopted from https://www.chipverify.com/verilog/verilog-single-port-ram
// Based off code given from kuzmin. Any value that was given that could be hardcoded was changed to do so, 
// I hope my description can show that we have and understanding of the structure we are using.
// Tried to comment most changes and gave reason for why they were changed.
`include "ram.sv"
`include "decoder.sv"

`timescale 1 ns / 1 ps

module single_port_sync_ram_large
  # ( parameter ADDR_WIDTH = 14, // size of each u 
      parameter DATA_WIDTH = 16, // word size
      // Removed parameter DATA_WIDTH_SHIFT = 1 since I will be always be splitting data width by two
    )
  
  (   input clk, // Clock
      input [ADDR_WIDTH-1:0] addr,
      inout [DATA_WIDTH-1:0] data, 
      input cs_input,
      input we,
      input oe
  );
  
  wire [3:0] cs;
  
  // hardcoded decoder since we only need 4 chips
  decoder #() dec
  (   .in(addr[ADDR_WIDTH-1:ADDR_WIDTH-2]),
      .out(cs) 
  );

// Sub ramchip u(address)(first part of word = 0, second part of word = 1) so u00 is the first part of the first ram chip
  single_port_sync_ram  #()  u00 
  (   .clk(clk), // Clock
      .addr(addr[ADDR_WIDTH-3:0]), // indierct addressing
      .data(data[(DATA_WIDTH>>DATA_WIDTH_SHIFT)-1:0]), // First part of word
      .cs(cs[0]), // Chip select based off CS 
      .we(we), // Write enable
      .oe(oe) // Output enable
  );
  single_port_sync_ram #() u01
  (   .clk(clk), // Clock
      .addr(addr[ADDR_WIDTH-3:0]), // indierct addressing
      .data(data[DATA_WIDTH-1:DATA_WIDTH>>DATA_WIDTH_SHIFT]), // Second part of word
      .cs(cs[0]), // Chip select
      .we(we), // Write enable
      .oe(oe) // Output enable
  );

  single_port_sync_ram  #() u10
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-3:0]),
      .data(data[(DATA_WIDTH>>DATA_WIDTH_SHIFT)-1:0]),
      .cs(cs[1]),
      .we(we),
      .oe(oe)
  );
  single_port_sync_ram #() u11
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-3:0]),
      .data(data[DATA_WIDTH-1:DATA_WIDTH>>DATA_WIDTH_SHIFT]),
      .cs(cs[1]),
      .we(we),
      .oe(oe)
  );

  single_port_sync_ram  #() u20
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-3:0]),
      .data(data[(DATA_WIDTH>>DATA_WIDTH_SHIFT)-1:0]),
      .cs(cs[2]),
      .we(we),
      .oe(oe)
  );
  single_port_sync_ram #() u21
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-3:0]),
      .data(data[DATA_WIDTH-1:DATA_WIDTH>>DATA_WIDTH_SHIFT]),
      .cs(cs[2]),
      .we(we),
      .oe(oe)
  );

  single_port_sync_ram  #() u30
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-3:0]),
      .data(data[(DATA_WIDTH>>DATA_WIDTH_SHIFT)-1:0]),
      .cs(cs[3]),
      .we(we),
      .oe(oe)
  );
  single_port_sync_ram #() u31
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-3:0]),
      .data(data[DATA_WIDTH-1:DATA_WIDTH>>DATA_WIDTH_SHIFT]),
      .cs(cs[3]),
      .we(we),
      .oe(oe)
  );

endmodule
