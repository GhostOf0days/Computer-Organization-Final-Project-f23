module decoder
  (
    input  [2:0] in,
    output [3:0] out
  );

  localparam latency = 1;

  assign #latency out = 'b1<<in;

endmodule
