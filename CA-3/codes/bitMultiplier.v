    module bitMultiplier 
    #(
        parameter INP_SIZE = 4,
        parameter OUT_SIZE = 8
    )
    (
        a_inp, b_inp,
        final_out
    );
        input wire [INP_SIZE-1 : 0]a_inp;
        input wire b_inp;
        output wire [OUT_SIZE -1 : 0] final_out;

        wire [INP_SIZE -1 : 0] out ;

        genvar g;
        generate
            for (g = 0; g < INP_SIZE; g = g+1) begin : product_bits
                c1 inst_multplr(
                        .A0(1'b0), .A1(a_inp[g]), .SA(b_inp),
                        .B0(1'b0), .B1(1'b0), .SB(1'b0),
                        .S0(1'b0), .S1(1'b0),
                        .f(out[g]));
            end
        endgenerate

        assign final_out = {4'b0 , out};


    endmodule
