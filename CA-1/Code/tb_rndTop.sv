`timescale 1ns/1ps

module tb_rndTop;

    localparam numOfIterations = 64;
    localparam numOfWords = 4;
    localparam numOfIterationBits = $clog2(numOfIterations);

    logic clk, rst, start;
    logic [numOfIterationBits-1:0] it;
    logic done;
    logic [($clog2(numOfWords)-1):0] rnd;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    rndTop #(
        .numOfIterations(numOfIterations),
        .numOfWords(numOfWords)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .it(it),
        .done(done),
        .rnd(rnd)
    );

    initial begin
        rst = 1;
        start = 0;
        it = 0;

        #15;
        rst = 0;

        it = 6'b100100;

        #10;
        start = 1;
        #10;
        start = 0;

        wait(done == 1);
        #5;

        $display("DONE! rnd output = %0d (time=%0t)", rnd, $time);

        #20;
        $stop;
    end

endmodule
