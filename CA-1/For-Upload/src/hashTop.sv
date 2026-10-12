module hashTop #(
    parameter messageSize = 128,
    parameter wordSize = 32,
    parameter numOfIterations = 64
)(
    clk,
    rst,
    start,
    done_rnd,
    rnd,
    message,
    constants,
    initialValues,
    start_rnd,
    done,
    hashed,
    it
);
    input  logic clk;
    input  logic rst;
    input  logic start;
    input  logic done_rnd;
    input  logic [$clog2(messageSize/wordSize)-1:0] rnd;
    input  logic [messageSize-1:0] message;
    input  logic [wordSize-1:0] constants [0:numOfIterations-1];
    input  logic [wordSize-1:0] initialValues [0:(messageSize/wordSize)-1];

    output logic start_rnd;
    output logic done;
    output logic [messageSize-1:0] hashed;
    output logic [$clog2(numOfIterations)-1:0] it;

    logic en_it, en_LRF, en_step, en_value;
    logic load_it, load_LRF, load_step;
    logic selValue;
    logic it_cout, step_cout;

    hashDatapath #(
        .messageSize(messageSize),
        .wordSize(wordSize),
        .numOfIterations(numOfIterations)
    ) hashDatapath_inst (
        .clk(clk),
        .selValue(selValue),
        .message(message),
        .initialValues(initialValues),
        .constants(constants),
        .rnd(rnd),
        .load_it(load_it),
        .load_step(load_step),
        .load_LRF(load_LRF),
        .en_value(en_value),
        .en_it(en_it),
        .en_LRF(en_LRF),
        .en_step(en_step),
        .it_cout(it_cout),
        .step_cout(step_cout),
        .hashed(hashed),
        .it(it)
    );

    hashFSM hashFSM_inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .it_cout(it_cout),
        .step_cout(step_cout),
        .selValue(selValue),
        .load_it(load_it),
        .load_step(load_step),
        .load_LRF(load_LRF),
        .en_value(en_value),
        .en_it(en_it),
        .en_LRF(en_LRF),
        .en_step(en_step),
        .done_rnd(done_rnd),
        .start_rnd(start_rnd)
    );

endmodule
