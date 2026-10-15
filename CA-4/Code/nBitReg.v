module nBitReg(
    clk, load,
    inp,
    out
);
    input wire clk, load;
    input wire [7:0] inp;
    output reg [7:0] out;

    always @(posedge clk) begin
        if (load) begin
            out <= inp;
        end
    end
endmodule