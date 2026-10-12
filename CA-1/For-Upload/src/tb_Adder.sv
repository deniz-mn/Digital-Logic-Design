`timescale 1ns/1ps

module tb_Adder;

    // --- 2-input test ---
    logic [7:0] in2[1:0];
    logic [8:0] sum2;  // 8+1 bits to prevent overflow

    nBitMultiAdder #(.numOfInps(2), .inpSize(8)) adder2 (
        .inp(in2),
        .sum(sum2)
    );

    // --- 3-input test ---
    logic [7:0] in3[2:0];
    logic [9:0] sum3;

    nBitMultiAdder #(.numOfInps(3), .inpSize(8)) adder3 (
        .inp(in3),
        .sum(sum3)
    );

    // --- 4-input test ---
    logic [7:0] in4[3:0];
    logic [10:0] sum4;

    nBitMultiAdder #(.numOfInps(4), .inpSize(8)) adder4 (
        .inp(in4),
        .sum(sum4)
    );

    initial begin
        // 2-input test
        in2[0] = 10; in2[1] = 20;
        #5;
        $display("2-input test: %0d + %0d = %0d", in2[0], in2[1], sum2);

        // 3-input test
        in3[0] = 5; in3[1] = 10; in3[2] = 15;
        #5;
        $display("3-input test: %0d + %0d + %0d = %0d", in3[0], in3[1], in3[2], sum3);

        // 4-input test
        in4[0] = 1; in4[1] = 2; in4[2] = 3; in4[3] = 4;
        #5;
        $display("4-input test: %0d + %0d + %0d + %0d = %0d", in4[0], in4[1], in4[2], in4[3], sum4);

        $stop;
    end

endmodule
