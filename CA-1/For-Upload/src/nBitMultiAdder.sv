module nBitMultiAdder
#(
    parameter numOfInps = 2,
    parameter inpSize = 32
)
(
    inp,
    sum
);
    input logic [inpSize-1:0] inp [0:numOfInps-1];
    output logic [inpSize-1:0] sum;
    assign sum = inp[0]
                + (numOfInps > 1 ? inp[1]: '0)
                + (numOfInps > 2 ? inp[2]: '0)
                + (numOfInps > 3 ? inp[3]: '0);// max of 4 inputs as we have in the problem, the largest adder takes four inputs to generate the F2
endmodule