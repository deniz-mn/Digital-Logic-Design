module calF
#(
    parameter INP_SIZE = 8,
    parameter ITT_SIZE = 6
)
(
    itt,
    B, C, D,
    F
);
    input wire [ITT_SIZE-1:0] itt;
    input wire [INP_SIZE-1:0] B, C, D;

    output wire [INP_SIZE-1:0] F;

    wire [INP_SIZE-1:0] D_inv;
    wire [INP_SIZE-1:0] F0, F1, F2, F3;

    genvar g;
    generate
        for (g = 0; g < INP_SIZE; g = g+1) begin : F_gen
        c1 inst_D_inv(.A0(1'b1), .A1(1'b0), .SA(D[g]),
               .B0(1'b0), .B1(1'b0), .SB(1'b0),
                .S0(1'b0), .S1(1'b0),
                 .f(D_inv[g]));
        
        c1 inst_F0(.A0(D[g]), .A1(C[g]), .SA(B[g]),
               .B0(1'b0), .B1(1'b0), .SB(1'b0),
                .S0(1'b0), .S1(1'b0),
                 .f(F0[g]));

        c1 inst_F1(.A0(C[g]), .A1(B[g]), .SA(D[g]),
               .B0(1'b0), .B1(1'b0), .SB(1'b0),
                .S0(1'b0), .S1(1'b0),
                 .f(F1[g]));

        c1 inst_F2(.A0(D[g]), .A1(D_inv[g]), .SA(C[g]),
               .B0(D_inv[g]), .B1(D[g]), .SB(C[g]),
                .S0(B[g]), .S1(1'b0),
                 .f(F2[g]));

        c1 inst_F3(.A0(D_inv[g]), .A1(1'b1), .SA(B[g]),
               .B0(D[g]), .B1(1'b0), .SB(B[g]),
                .S0(1'b0), .S1(C[g]),
                 .f(F3[g]));

        end
    endgenerate

    mux 
    #(
        .INP_SIZE(INP_SIZE)
    ) mux_F (
        .inp0(F0), .inp1(F1), .inp2(F2), .inp3(F3),
        .sel(itt[5:4]),
        .out(F)
    );

endmodule