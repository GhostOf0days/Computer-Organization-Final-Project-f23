`include "ram-example.v"

`timescale 1 ns /1 ps

module single_port_ram_large
# (
    parameter ADDR_WIDTH = 14,
    parameter DATA_WIDTH = 16,
    parameter data_width_shift = 1
)
(
    input clk,
    input 
)