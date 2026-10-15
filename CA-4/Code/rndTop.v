module rndTop(
    clk, rst, start,
    it,
    done,
    rnd
);
    input wire clk, rst, start;
    input wire [5:0] it;

    output wire done;
    output wire [1:0] rnd;
    
    wire en_x, load_x;
    wire load_shift_counter, en_shift_counter;
    wire shift_counter_cout;

    rndDatapath datapath (
        .clk(clk),
        .en_x(en_x),
        .load_x(load_x),
        .load_shift_counter(load_shift_counter),
        .en_shift_counter(en_shift_counter),
        .it(it),
        .shift_counter_cout(shift_counter_cout),
        .rnd(rnd)
    );

    rndFSM fsm (
        .clk(clk),
        .rst(rst),
        .start(start),
        .en_x(en_x),
        .load_x(load_x),
        .load_shift_counter(load_shift_counter),
        .en_shift_counter(en_shift_counter),
        .shift_counter_cout(shift_counter_cout),
        .done(done)
    );
endmodule