module nBitUpCounter
#(
    parameter numOfBits = 6,
    parameter goal = 64
)
(
    clk, load, en, 
    din,
    cout,
    dout
);
    input logic clk, load, en;
    input logic [numOfBits-1:0] din;
    output logic cout;
    output logic [numOfBits-1:0] dout;
    always_ff @(posedge clk) begin
        if (load) begin
            dout <= din;
        end
        else if (en) begin
            dout <= dout+1;
        end
    end
    assign cout = goal-1 == dout? 1'b1: 1'b0;
endmodule