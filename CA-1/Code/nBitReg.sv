module nBitREG
#(
    parameter wordSize = 32
)
(
    clk, load,
    inp,
    out
);
    input logic clk, load;
    input logic [wordSize-1:0]inp;
    output logic [wordSize-1:0]out;
    always_ff @(posedge clk) begin
        if (load) begin
            out <= inp;
        end
    end
endmodule   