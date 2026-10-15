module register
#(
    parameter INP_SIZE = 8 
)
(
    clk, clr,
    inp1, inp2, inp3,
    sel,
    out
);
    input wire clk, clr;
    input wire[INP_SIZE-1:0] inp1, inp2, inp3;
    input wire[1:0] sel;
    output wire[INP_SIZE-1:0] out;
    
    genvar g;
    generate
        for (g = 0; g < INP_SIZE; g = g+1) begin : register_gen
            s2 s2_register_inst(.D00(out[g]), .D01(inp1[g]), .D10(inp2[g]), .D11(inp3[g]),
             .A1(sel[1]), .B1(1'b0), .A0(sel[0]), .B0(1'b1),
              .clr(clr), .clk(clk),
               .out(out[g]));
        end
    endgenerate
endmodule