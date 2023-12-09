`timescale 1ns / 1 ps 
// Again the ram module was changed here to fit the requirements of the assignment, 
// but the logic is the same for loading and writing data to the ram.
module ram 
    # (parameter ADDR_WIDTH = 13, // 2^13 = 8192 per ram part compared to 2^12 = 4096 per ram part
       parameter DATA_WIDTH = 8, // same word size
       parameter LENGTH = 8192 // 2^13 = 8192 per ram part compared to 2^12 = 4096 per ram part
)
    (
     input clk,
     input [ADDR_WIDTH-1:0] addr,
     input [DATA_WIDTH-1:0] data,
     input cs, // Chip select
     input write_enable, // Write enable
     input oe // Output enable
     
    );

    reg [DATA_WIDTH-1:0] mem[LENGTH]
  
    reg [DATA_WIDTH-1:0] tmp_data;
  	wire [DATA_WIDTH-1:0] output_data;

    always @ (posedge clk) begin
        if (cs & we)
            mem[addr] <= data; // Direct
    end

    always @ (negedge clk) begin // Negative edge, so no clock delay in reading. Not a big deal. Value that is read is on negative edge for this example.
        if (cs & !we) 
            tmp_data <= mem[addr]; // Direct addressing
    end

     assign output_data = cs && oe && !we ? tmp_data : 'hz;
     assign data = output_data;

endmodule
