module register
#(
    parameter NUM_OF_BITS_INPUT = 34,
    parameter NUM_OF_BITS_OUTPUT = 16
)
(
    clk,load,rst,
    inp,
    out
);
    input wire clk, load , rst ;
    input wire [NUM_OF_BITS_INPUT-1:0]inp;
    output reg [NUM_OF_BITS_OUTPUT-1:0]out;

    always @(posedge clk , posedge rst) begin
        if (rst) begin
            out = {NUM_OF_BITS_OUTPUT{1'b0}};
        end

        if (load) begin
            out <= inp[NUM_OF_BITS_OUTPUT-1:0];
        end
    end
endmodule   

