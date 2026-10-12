module FGenerator
#(
    parameter messageSize = 128,
    parameter wordSize = 32,
    parameter numOfIterations = 64
)
(
    it,
    values,
    F
);
    localparam numOfWords = messageSize / wordSize;
    input logic [$clog2(numOfIterations)-1:0] it;
    input logic [wordSize-1:0] values [numOfWords]; 
    output logic [wordSize-1:0] F;

    
    // The hard part is to make a rul to satisfy the 4 parts of it and also work for more and less number of nomOfWords, 
    // So we will be making up some rules for it != 4 and use the rule mentioned for it != 4
    // So its basically a large assign but since we want to make sure it works for max 'it' = 63 and 4 values we will go like this:

    logic [wordSize-1:0] A, B, C, D;

    // assign safe defaults to make sure it works fine with the main rules
    assign A = (numOfWords > 3) ? values[3] : values[0];
    assign B = (numOfWords > 2) ? values[2] : values[0];
    assign C = (numOfWords > 1) ? values[1] : values[0];
    assign D = values[0]; // We will always have at least one value so no problem on D

    // main assign for F
    assign F = (it < 64) ? 
                ((numOfWords == 4) ? 
                    ((it <= 15) ? ((B & C) | ((~B) & D)) :
                     (it <= 31) ? ((D & B) | ((~D) & C)) :
                     (it <= 47) ? (B ^ C ^ D) :
                     (it <= 63) ? (C ^ (B | (~D))) : '0) // This makes sure to work for the main rules
                : 
                    ((it <= 15) ? ((B & C) | ((~B) & D)) :
                     (it <= 31) ? ((D & B) | ((~D) & C)) :
                     (it <= 47) ? (B ^ C ^ D) :
                     (it <= 63) ? (C ^ (B | (~D))) : '0) // If we have less than 64 we are good but if 
                                                         //we have more than that we need a default and its a random self-made rule
                )
              :
                // catch-all for it >= 64 since we could have more than 64 iterations
                (A ^ B ^ C ^ D);
endmodule
