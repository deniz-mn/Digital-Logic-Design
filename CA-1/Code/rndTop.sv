module rndTop
#(
    parameter numOfIterations = 64,
    parameter numOfWords = 4
)
(
    clk, rst, start,
    it,
    done,
    rnd
);

    localparam numOfIterationBits = $clog2(numOfIterations);

    input logic clk, rst, start;
    input logic [numOfIterationBits-1:0] it;

    output logic done;
    output logic [($clog2(numOfWords)-1):0] rnd;

    logic en_x, load_x;
    logic load_shift_counter, en_shift_counter;
    logic shift_counter_cout;

    rndDatapath #(
        .numOfIterations(numOfIterations),
        .numOfWords(numOfWords)
    ) datapath (
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
