module halfMultiplier #(
    parameter wordSize = 8
)
(
        input,
        output
);

    input logic [wordSize-1:0] input;
    output logic [wordSize-1:0] output;
    
    localparam HALF_wordSize = wordSize / 2;
    
    assign output_data = input_data[wordSize-1:HALF_wordSize] * input_data[HALF_wordSize-1:0];
    
endmodule