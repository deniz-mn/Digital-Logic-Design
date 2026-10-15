module bitI 
#(
    parameter INP_SIZE = 4 
)
(
    inp, num, 
    out
);


    input wire [INP_SIZE -1 : 0] inp;
    input wire [1:0]num;
    output out; 

    mux inst_bitI(.inp0(inp[0]), .inp1(inp[1]), .inp2(inp[2]), .inp3(inp[3]), .sel(num), .out(out));

endmodule