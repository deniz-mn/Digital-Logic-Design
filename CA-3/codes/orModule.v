module orModule
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
        for (g = 0; g < INP_SIZE ; g = g+1) begin : or_gen
            c1 inst_or(
                    .A0(inp3[g]), .A1(1'b1), .SA(inp2[g]),
                     .B0(1'b1), .B1(1'b1), .SB(1'b0),
                      .S0(inp0[g]), .S1(inp1[g]),
                       .f(out[g]));
        end
    endgenerate
    
endmodule