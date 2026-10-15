module rndDatapath(
    clk,
    en_x, load_x,
    load_shift_counter, en_shift_counter, 
    it,
    shift_counter_cout,
    rnd
);
    input wire clk, en_x, load_x, load_shift_counter, en_shift_counter;
    input wire [5:0] it;

    output wire shift_counter_cout;
    output wire [1:0] rnd;

    wire fb;
    reg [5:0] x;

    assign fb = x[1] ^ x[3] ^ x[5];

    always @(posedge clk) begin
        if (load_x) begin
            x <= it;
        end
        else if (en_x) begin
            x <= {x[4:0], fb};
        end
    end

    nBitDownCounter numberOfShiftsCounter (
        .clk(clk),
        .load(load_shift_counter), 
        .en(en_shift_counter), 
        .din(6'd6),
        .cout(shift_counter_cout),
        .dout()
    );

    assign rnd = x[5:4];

endmodule