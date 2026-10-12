module leftRotate
#(
  parameter wordSize = 32
)
(
  clk,
  en,
  load,
  din,
  dout
);
  input logic clk, en, load;
  input logic [wordSize-1:0] din;

  output logic [wordSize-1:0] dout;
  
  logic ser_out_ser_in_connection;
  
  nBitLeftShiftReg  #(
    .wordSize(wordSize)
  ) leftShiftInst (
    .clk(clk),
    .load(load), 
    .en(en), 
    .serin(ser_out_ser_in_connection),
    .inp(din),
    .out(dout)
  );

  assign ser_out_ser_in_connection = dout[wordSize-1];

endmodule