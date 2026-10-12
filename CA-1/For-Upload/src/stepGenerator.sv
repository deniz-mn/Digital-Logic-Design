module stepGenerator
#(
    parameter numOfIterations = 64,
    parameter numOfStepBits = 5,
    parameter numOfSteps = 64
)
(
    it,
    step
);
    input logic [$clog2(numOfIterations)-1:0] it;
    output logic [numOfStepBits-1:0] step;

    logic [numOfStepBits-1:0] steps [0:numOfSteps-1];
    integer i;

    // The largest number in step is 23 so 5 bits is enough for it but we will get it as parameter as well
    // Also in order to avoid making a rule for step and changing it we will use it%numOfSteps instead
    // so it becomes easier to handle
    // Now for steps:

    initial begin
        // step[0:15]
        for (i = 0; i < 16; i = i + 1) begin
            case (i % 4)
                0: steps[i] = 7;
                1: steps[i] = 12;
                2: steps[i] = 17;
                3: steps[i] = 22;
            endcase
        end
        // step[16:31]
        for (i = 16; i < 32; i = i + 1) begin
            case (i % 4)
                0: steps[i] = 5;
                1: steps[i] = 9;
                2: steps[i] = 14;
                3: steps[i] = 20;
            endcase
        end
        // step[32:47]
        for (i = 32; i < 48; i = i + 1) begin
            case (i % 4)
                0: steps[i] = 4;
                1: steps[i] = 11;
                2: steps[i] = 16;
                3: steps[i] = 23;
            endcase
        end
        // step[48:63]
        for (i = 48; i < 64; i = i + 1) begin
            case (i % 4)
                0: steps[i] = 6;
                1: steps[i] = 10;
                2: steps[i] = 15;
                3: steps[i] = 21;
            endcase
        end
    end

    assign step = steps[it % numOfSteps]-1;

endmodule
