module nBitLeftShiftReg
#(
    parameter wordSize = 32
)
(
    clk, load, en, serin,
    inp,
    out
);
    input logic clk, load, en, serin;
    input logic [wordSize-1:0]inp;
    output logic [wordSize-1:0]out;
    always_ff @(posedge clk) begin
        if (load) begin
            out <= inp;
        end
        else if (en) begin
            out <= {out[wordSize-2:0], serin}; 
        end
    end
endmodule