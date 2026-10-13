module upCounter
#(
    parameter NUM_OF_BITS = 6,
    parameter GOAL = 63
)
(
    clk, load, en, rst,
    din,
    cout,
    dout
);
    input wire clk, load, en, rst;
    input wire [NUM_OF_BITS-1:0] din;
    output wire cout;
    output reg [NUM_OF_BITS-1:0] dout;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            dout = {NUM_OF_BITS{1'b0}};
        end
        else if (load) begin
            dout <= din;
        end
        else if (clk) begin
            if (en) begin
                dout <= dout+1;
            end
        end
    end
    
    assign cout = (dout == GOAL);
    
endmodule