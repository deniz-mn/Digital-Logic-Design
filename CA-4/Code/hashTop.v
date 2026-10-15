module hashTop(
    clk,
    rst,
    start,
    done_rnd,
    rnd,
    message,
    start_rnd,
    done,
    hashed,
    it
);
    input wire clk;
    input wire rst;
    input wire start;
    input wire done_rnd;
    input wire [1:0] rnd;
    input wire [31:0] message;

    output wire start_rnd;
    output wire done;
    output wire [31:0] hashed;
    output wire [5:0] it;

    wire en_it, en_value;
    wire load_it;
    wire selValue;
    wire it_cout;

    hashDatapath datapath (
        .clk(clk),
        .selValue(selValue),
        .message(message),
        .rnd(rnd),
        .load_it(load_it),
        .en_value(en_value),
        .en_it(en_it),
        .it_cout(it_cout),
        .hashed(hashed),
        .it(it)
    );

    hashFSM fsm (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .it_cout(it_cout),
        .selValue(selValue),
        .load_it(load_it),
        .en_value(en_value),
        .en_it(en_it),
        .done_rnd(done_rnd),
        .start_rnd(start_rnd)
    );
endmodule