module rndDatapath
#(
    parameter numOfIterations = 64,
    parameter numOfWords = 4
)
(
    clk,
    en_x, load_x,
    load_shift_counter, en_shift_counter, 
    it,
    shift_counter_cout,
    rnd
);
    localparam numOfIterationBits = $clog2(numOfIterations);

    input logic clk, en_x, load_x, load_shift_counter, en_shift_counter;
    input logic [numOfIterationBits-1:0] it;

    output logic shift_counter_cout;
    output logic [($clog2(numOfWords)-1):0] rnd;

    logic fb;
    logic [numOfIterationBits-1:0] x;

    integer i; 
    always@(*) begin
        fb = 1'b0;
        for (i = 1; i < numOfIterationBits; i = i + 2) begin
            fb = fb ^ x[i];
        end
    end         // we could also do 
                //fb = (numOfIterationBits > 5? x[5]: 1'b0) ^ (numOfIterationBits > 3? x[3]: 1'b0) ^ (numOfIterationBits > 1? x[1]: 1'b0);
                // but its not a rule that can be applied for other numOfIterationBits so we'll write it for all add bits of x to be xor ed.

    // Left-shift register module instance
    nBitLeftShiftReg #(
        .wordSize(numOfIterationBits)
    ) xShiftReg (
        .clk(clk),
        .load(load_x),
        .en(en_x),
        .serin(fb),
        .inp(it),
        .out(x)
    );
    nBitDownCounter #(
        .numOfBits(numOfIterationBits)
    )
        numberOfShiftsCounter
    (
        .clk(clk),
        .load(load_shift_counter), 
        .en(en_shift_counter), 
        .din(numOfIterationBits),
        .cout(shift_counter_cout),
        .dout()
    );

    assign rnd = x[numOfIterationBits-1:numOfIterationBits-$clog2(numOfWords)];

endmodule
