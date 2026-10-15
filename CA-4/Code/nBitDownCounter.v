module nBitDownCounter(
    clk, load, en, 
    din,
    cout,
    dout
);
    input wire clk, load, en;
    input wire [5:0] din;
    output wire cout;
    output reg [5:0] dout;

    always @(posedge clk) begin
        if (load) begin
            dout <= din;
        end
        else if (en) begin
            dout <= dout - 1;
        end
    end
    assign cout = (dout == 0);
endmodule