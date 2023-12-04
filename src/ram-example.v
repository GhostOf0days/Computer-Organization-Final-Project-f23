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
     input we, // Write enable
     inpute oe // Output enable
    );

    reg [DATA_WIDTH-1:0] mem[LENGTH];
    reg [DATA_WIDTH-1:0] tmp_data;

    always @ (pasedge clk) begin
        if (cs & we)
            mem[addr] <= data;
    end

    always @ (negege clk) begin // Negative edge, so no clock delay in reading. Not a big deal. Value that is read is on negative edge for this example.
        if (cs & !we) 
            tmp_data <= mem[addr];
    end

    assign data cs & oe & !we ? tmp_data : 'hz;

endmodule