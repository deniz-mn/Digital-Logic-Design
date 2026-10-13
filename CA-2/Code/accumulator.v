module accumulator
#(
    parameter INPUT_SIZE = 34
)
(
    clk, rst, reset_values,
    en,
    inp,
    out
);
    input wire clk, rst, reset_values, en;
    input wire [INPUT_SIZE-1:0] inp;
    output reg [INPUT_SIZE-1:0] out;
    always @(posedge clk, posedge rst, posedge reset_values) begin
        if (rst) begin
            out = {INPUT_SIZE{1'b0}};
        end
        else if (reset_values) begin
            out = {INPUT_SIZE{1'b0}};
        end
        else if (clk) begin
            if (en) begin
                out = out + inp;
            end
        end
    end
    
endmodule
 