module Top #(
    parameter messageSize = 128,
    parameter wordSize = 32,
    parameter numOfIterations = 64
)(
    clk,
    rst,
    start,
    message,
    constants,
    initialValues,

    done,
    hashed
);
    localparam numOfWords = messageSize / wordSize;

    input  logic clk;
    input  logic rst;
    input  logic start;
    input  logic [messageSize-1:0] message;
    input  logic [wordSize-1:0] constants [0:numOfIterations-1];
    input  logic [wordSize-1:0] initialValues [0:(messageSize/wordSize)-1];

    output logic done;
    output logic [messageSize-1:0] hashed;


    logic start_rnd;
    logic done_rnd;
    logic [$clog2(numOfWords)-1:0] rnd;
    logic [$clog2(numOfIterations)-1:0] it;

    hashTop #(
        .messageSize(messageSize),
        .wordSize(wordSize),
        .numOfIterations(numOfIterations)
    ) hash_top_inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .done_rnd(done_rnd),
        .start_rnd(start_rnd),
        .rnd(rnd),
        .message(message),
        .constants(constants),
        .initialValues(initialValues),
        .hashed(hashed),
        .it(it)
    );

    rndTop #(
        .numOfWords(numOfWords)
    ) rnd_top_inst (
        .clk(clk),
        .rst(rst),
        .it(it),
        .start(start_rnd),
        .done(done_rnd),
        .rnd(rnd)
    );

endmodule
