module decoder #(
  parameter ONE_HOT_LENGTH = 8
)
(
  inp,
  out
);
  input wire [$clog2(ONE_HOT_LENGTH)-1:0] inp;
  output wire [ONE_HOT_LENGTH-1:0] out;

  assign out = 1 << inp;

endmodule