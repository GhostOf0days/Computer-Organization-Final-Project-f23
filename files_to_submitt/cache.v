module Cache(
    input [15:0] addr,
    input [15:0] write_data,
    input clk,
    input write,
    output reg [15:0] out,
);
    parameter block_count = 3571;
    parameter ram_size = 65536;

    reg valid [block_count:0];
    reg [3:0] tag [block_count:0];
    reg [15:0] data [block_count:0];

    reg [7:0] ram [ram_size:0];

    always @(addr, write, write_data) begin
        localparam block_num = (addr/2)%block_count;
        localparam block_tag = (addr/2)/block_count;

        if (valid[block_num] and tag[block_num] == block_tag) begin
            // Cache hit
            if (write) begin
                data[block_num] = write_data;
                ram[addr] = write_data[7:0];
                ram[addr+1] = write_data[15:8];
            end else begin
                out = data[block_num];
            end
        end else begin
            // Cache miss
            valid[block_num] = 1;
            tag[block_num] = block_tag;
            if (write) begin
                data[block_num] = write_data;
                ram[addr] = write_data[7:0];
                ram[addr+1] = write_data[15:8];
            end else begin
                data[block_num] = {ram[addr+1'b1], ram[addr]};
            end
        end

    end

endmodule