module notModule
#(
    parameter INP_SIZE = 1
)
(
    inp,
    out
);
    input wire[INP_SIZE-1:0] inp;
    output wire[INP_SIZE-1:0] out;
    
    
    genvar g;
    generate
        for (g = 0; g < INP_SIZE ; g = g+1) begin : not_gen
            c1 inst_inv(.A0(1'b1), .A1(1'b0), .SA(inp[g]),
               .B0(1'b0), .B1(1'b0), .SB(1'b0),
                .S0(1'b0), .S1(1'b0),
                 .f(out[g]));
        end
    endgenerate
    
endmodule