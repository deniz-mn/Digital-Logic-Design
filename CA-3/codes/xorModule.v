module xorModule
#(
    parameter INP_SIZE = 1
)
(
    inp0, inp1, inp2,
    out
);
    input wire[INP_SIZE-1:0] inp0, inp1, inp2;
    output wire[INP_SIZE-1:0] out; 
    
    wire [INP_SIZE-1:0] inp2_inv;

    genvar g;
    generate
        for (g = 0; g < INP_SIZE ; g = g+1) begin : or_gen
            c1 inst_sum(
                .A0(inp2[g]), .A1(inp2_inv[g]), .SA(inp1[g]),
                 .B0(inp2_inv[g]), .B1(inp2[g]), .SB(inp1[g]),
                  .S0(inp0[g]), .S1(1'b0),
                   .f(out[g]));
            notModule inst_inp2_inv(inp2[g], inp2_inv[g]);
        end
    endgenerate
    
endmodule