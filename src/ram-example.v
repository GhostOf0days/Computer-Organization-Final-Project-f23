`timescale 1ns / 1 ps 

module ram 
    # (parameter ADDR_WIDTH = 13,
       parameter DATA_WIDTH = 8,
       parameter LENGTH = (1<<ADDR_WIDTH)
)
    (
     input clk,
     input [ADDR_WIDTH-1:0] addr,
     input [DATA_WIDTH-1:0] data,
     input cs, // Chip select
     input we, // Write enable
     input oe // Output enable
    );

    reg [DATA_WIDTH-1:0] mem [0:LENGTH-1];
  
    reg [DATA_WIDTH-1:0] tmp_data;
  	wire [DATA_WIDTH-1:0] output_data;

    always @ (posedge clk) begin
        if (cs & we) 
            mem[addr] <= data;     
    end

    always @ (negedge clk) begin
      if (cs & !we)
            tmp_data <= mem[addr]; 
    end

     assign output_data = cs && oe && !we ? tmp_data : 'hz;
     assign data = output_data;

endmodule