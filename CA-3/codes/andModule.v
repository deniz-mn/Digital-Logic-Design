module andModule
#(
    parameter INP_SIZE = 1
)
(
    inp0, inp1, inp2, inp3,
    out
);
    input wire[INP_SIZE-1:0] inp0, inp1, inp2, inp3;
    output wire[INP_SIZE-1:0] out; 
    
    
    genvar g;
    generate
        for (g = 0; g < INP_SIZE ; g = g+1) begin : and_gen
            c2 inst_and(.D00(1'b0), .D01(1'b0), .D10(1'b0), .D11(inp0[g]),
                 .A1(1'b0), .B1(inp1[g]), .A0(inp2[g]), .B0(inp3[g]),
                  .out(out[g]));
        end
    endgenerate
    
endmodule