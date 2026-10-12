module hashDatapath 
#(
    parameter messageSize = 128,
    parameter wordSize = 32,
    parameter numOfIterations = 64
)
(    
    clk,
    selValue,
    message,
    initialValues,
    constants,
    rnd,
    load_it,
    load_step,
    load_LRF,
    en_value,
    en_it,
    en_LRF,
    en_step,
    it_cout,
    step_cout,
    hashed,
    it 
);
    localparam numOfWords = messageSize / wordSize;

    input logic clk, selValue;
    input logic en_it, en_LRF, en_step, en_value;
    input logic load_it, load_LRF, load_step;
    input logic[messageSize-1:0] message;
    input logic [wordSize-1:0] constants [0:numOfIterations-1];
    input logic [wordSize-1:0] initialValues [0:numOfWords-1];
    input logic [($clog2(numOfWords)-1):0] rnd;

    output logic it_cout, step_cout;
    output logic [messageSize-1:0] hashed;
    output logic [$clog2(numOfIterations)-1:0]it;


    logic [wordSize-1:0] constant;
    logic [wordSize-1:0] value_in [0:numOfWords-1];
    logic [wordSize-1:0] value_out [0:numOfWords-1];

    logic [wordSize-1:0] F, F_summed, LRF;
    logic [wordSize-1:0] M [0:numOfWords-1];
    logic [wordSize-1:0] values [0:numOfWords-1];   // This is instead of A,B,C and D registers
                                                // since we are going parametric we will have to split a message into words

    assign values = value_out;

    assign constant = constants[it];

    logic [wordSize-1:0] adderInp [0:3];

    genvar i;
    generate
        for (i = 0; i < numOfWords; i = i + 1) begin : word_split
            assign M[i] = message[(i+1)*wordSize-1 -: wordSize];
        end
    endgenerate

    generate
        for (i = 0; i < numOfWords; i = i + 1) begin : concat_words
            assign hashed[(i+1)*wordSize - 1 : i*wordSize] = values[i];    
        end
    endgenerate // This will make hashed from concatenation of values where values[numOfWords-1] has the MSB in it so
                // hashed will be like hash = {values[numOfWords-1], values[numOfWords-2], ... ,values[0]};

    generate
        for (i = 0; i < numOfWords; i = i + 1) begin : values_mux_reg
            always@(*) begin
                if (selValue)
                    value_in[i] = initialValues[i];     // load initial a0,b0,c0,d0 for 4 words of size 32
                else if (i >= 3) // A 
                    value_in[i] = value_out[0];                         // this two parts are in a way where other than values[1] which is B
                                                                        // in case of 4 words will be loaded by on ahead of them, and 
                else if (i == 2) // B
                    value_in[i] = numOfWords > 2? value_out[2] + LRF: value_out[0]  + LRF;   // B will be updated by getting summed by LRF here     
                else if (i == 1) // C
                    value_in[i] = numOfWords > 2? value_out[2]: value_out[0];
                else if (i == 0) // D
                    value_in[i] = numOfWords > 2? value_out[1]: value_out[0];

            end

            nBitREG #(.wordSize(wordSize)) valueReg (
                .clk(clk),
                .load(en_value),
                .inp(value_in[i]),
                .out(value_out[i])
            );
        end
    endgenerate
    // We will use 2 combinational circuit to make F and F_summed; After that, F_rotated is made from F_summed (F_summed was previously named F_final)
    nBitUpCounter #(
        .numOfBits($clog2(numOfIterations)),
        .goal(numOfIterations)
        )
        it_counter
        (
            .clk(clk),
            .load(load_it), // its the same as count start and uses din = '0 as the initial value
            .en(en_it),
            .din('0),
            .cout(it_cout), // once we reach the max i this turns 1 and it means its the last iteration and we need not continue after that
            .dout(it));

    FGenerator #(
        .messageSize(messageSize),
        .wordSize(wordSize),
        .numOfIterations(numOfIterations)
    ) FGeneratorInst (
        .it(it),
        .values(values),
        .F(F)
    );
    
    assign adderInp[0] = F;
    assign adderInp[1] = values[numOfWords-1];
    assign adderInp[2] = constant;
    assign adderInp[3] = M[(numOfWords-rnd-1)%numOfWords];
    
    nBitMultiAdder #(
        .numOfInps(4),
        .inpSize(wordSize)
    ) F_summed_generator(
        .inp(adderInp),
        .sum(F_summed)
    );

    rotate #(
        .numOfIterations(numOfIterations),
        .wordSize(wordSize)
    ) LRF_handler (
        .clk(clk),
        .en_LRF(en_LRF),
        .load_LRF(load_LRF),
        .en_step(en_step),
        .load_step(load_step),
        .step_cout(step_cout),
        .it(it),
        .F_summed(F_summed),
        .LRF(LRF)
    );

endmodule