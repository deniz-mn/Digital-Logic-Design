module rotate
#(
    parameter numOfIterations = 64,
    parameter wordSize = 32,
    parameter numOfStepBits = 5 // Although its a parameter its actually a constant since max step is 23 and
                                // and having a down counter with 5 bits is enough for any number of steps
)
(
    clk,
    en_LRF,
    load_LRF,
    en_step,
    load_step,
    step_cout,
    it,
    F_summed,
    LRF
);
    input logic clk , en_LRF , load_LRF , en_step , load_step;
    input logic [wordSize-1:0] F_summed;
    input logic [$clog2(numOfIterations)-1:0] it;
    
    output logic step_cout;
    output logic [wordSize-1:0] LRF;

    logic[numOfStepBits-1:0] step;

    leftRotate #(
        .wordSize(wordSize)
    ) F_rotator(
        .clk(clk),
        .din(F_summed),
        .en(en_LRF),
        .load(load_LRF),
        .dout(LRF)
    );

    stepGenerator #(
        .numOfIterations(numOfIterations),
        .numOfStepBits(numOfStepBits)
    ) stepGeneratorInst (
        .it(it),
        .step(step)
    );

    nBitDownCounter #(
        .numOfBits(numOfStepBits)
    ) stepCounter (
        .clk(clk),
        .load(load_step),
        .en(en_step), 
        .din(step),
        .cout(step_cout),
        .dout()
    );
    
endmodule