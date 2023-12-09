`timescale 1ns / 1 ps 

module ram 
    # (parameter ADDR_WIDTH = 12,
       parameter DATA_WIDTH = 8,
       parameter LENGTH = (1<<ADDR_WIDTH)
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
