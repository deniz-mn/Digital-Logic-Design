module top(
    clk,
    rst,
    start,
    message,
    done,
    hashed
);
    input wire clk;
    input wire rst;
    input wire start;
    input wire [31:0] message;

    output wire done;
    output wire [31:0] hashed;

    wire start_rnd;
    wire done_rnd;
    wire [1:0] rnd;
    wire [5:0] it;

    hashTop hash_top_inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .done_rnd(done_rnd),
        .start_rnd(start_rnd),
        .rnd(rnd),
        .message(message),
        .hashed(hashed),
        .it(it)
    );

    rndTop rnd_top_inst (
        .clk(clk),
        .rst(rst),
        .it(it),
        .start(start_rnd),
        .done(done_rnd),
        .rnd(rnd)
    );
endmodule