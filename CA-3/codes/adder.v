module adder
#(
    parameter INP_SIZE = 8 
)
(
    inp0, inp1,
    out
);
    input wire[INP_SIZE-1:0] inp0, inp1;
    output wire[INP_SIZE-1:0] out;
    wire c[INP_SIZE-2:0];
    wire c_inv[INP_SIZE-2:0];

    
    c1 inst_carry_first(.A0(1'b0), .A1(1'B0), .SA(inp1[0]),
       .B0(1'b0), .B1(1'b1), .SB(inp1[0]),
        .S0(inp0[0]), .S1(1'b0),
         .f(c[0]));
    
    c1 inst_sum_first(.A0(1'b0), .A1(1'b1), .SA(inp1[0]),
       .B0(1'b1), .B1(1'b0), .SB(inp1[0]),
        .S0(inp0[0]), .S1(1'b0),
         .f(out[0]));
    
    genvar g;
    generate
        for (g = 1; g < INP_SIZE-1; g = g+1) begin : adder_gen
            c1 inst_carry(.A0(1'b0), .A1(c[g-1]), .SA(inp1[g]),
               .B0(c[g-1]), .B1(1'b1), .SB(inp1[g]),
                .S0(inp0[g]), .S1(1'b0),
                 .f(c[g]));

            c1 inst_carry_inv(.A0(1'b1), .A1(1'b0), .SA(c[g-1]),
               .B0(1'b0), .B1(1'b0), .SB(1'b0),
                .S0(1'b0), .S1(1'b0),
                 .f(c_inv[g-1]));

            c1 inst_sum(.A0(c[g-1]), .A1(c_inv[g-1]), .SA(inp1[g]),
               .B0(c_inv[g-1]), .B1(c[g-1]), .SB(inp1[g]),
                .S0(inp0[g]), .S1(1'b0),
                 .f(out[g]));
        end
    endgenerate
    c1 inst_carry_inv_last(.A0(1'b1), .A1(1'b0), .SA(c[INP_SIZE-2]),
       .B0(1'b0), .B1(1'b0), .SB(1'b0),
        .S0(1'b0), .S1(1'b0),
         .f(c_inv[INP_SIZE-2]));
    
    c1 inst_sum_last(.A0(c[INP_SIZE-2]), .A1(c_inv[INP_SIZE-2]), .SA(inp1[INP_SIZE-1]),
       .B0(c_inv[INP_SIZE-2]), .B1(c[INP_SIZE-2]), .SB(inp1[INP_SIZE-1]),
        .S0(inp0[INP_SIZE-1]), .S1(1'b0),
         .f(out[INP_SIZE-1]));
endmodule