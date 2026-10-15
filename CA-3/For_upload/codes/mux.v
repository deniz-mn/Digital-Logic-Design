module mux
#(
    parameter INP_SIZE = 1
)
(
    inp0, inp1, inp2, inp3,
    sel,
    out
);
    input wire[INP_SIZE-1:0] inp0, inp1, inp2, inp3;
    input wire[1:0] sel;
    output wire [INP_SIZE-1:0] out;

    genvar g;
    generate
        for (g = 0; g < INP_SIZE ; g = g+1) begin : mux_gen
            c1 inst_mux(
                    .A0(inp0[g]), .A1(inp1[g]), .SA(sel[0]),
                     .B0(inp2[g]), .B1(inp3[g]), .SB(sel[0]),
                      .S0(sel[1]), .S1(1'b0),
                       .f(out[g]));
        end
    endgenerate
    
endmodule