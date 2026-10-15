`timescale 1ns / 1ns

module tbFullTop;

    localparam INP_SIZE = 8;
    localparam ITT_SIZE = 6;
    localparam MESSAGE_LENGTH = 4 * INP_SIZE;
    localparam NUM_TESTS = 64;

    reg clk, rst, start;
    reg [MESSAGE_LENGTH-1:0] message;
    
    wire [INP_SIZE-1:0] current_const;

    wire [MESSAGE_LENGTH-1:0] digest;
    wire done;

    reg [MESSAGE_LENGTH-1:0] test_vectors [0:NUM_TESTS-1];
    reg [MESSAGE_LENGTH-1:0] expected_results [0:NUM_TESTS-1];

    integer i;
    integer correct_count;

    top #(
        .INP_SIZE(INP_SIZE),
        .ITT_SIZE(ITT_SIZE)
    ) uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .message(message),
        .digest(digest),
        .done(done)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        start = 0;
        correct_count = 0;
        $readmemh("testcase.txt", test_vectors);
        $readmemh("out_hw.txt", expected_results);

        for (i = 0; i < NUM_TESTS; i = i + 1) begin
            
            message = test_vectors[i];
            
            rst = 1;
            #10;
            rst = 0;

            #10;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);

            if (digest === expected_results[i]) begin
                correct_count = correct_count + 1;
                $display("Test %0d/%0d: SUCCESS | In: %h | Out: %h | Exp: %h", i+1, NUM_TESTS, message, digest, expected_results[i]);
            end 
            else begin
                $display("Test %0d/%0d: FAIL | In: %h | Out: %h | Exp: %h", i+1, NUM_TESTS, message, digest, expected_results[i]);
            end
        end

        $display("Total Correct: %0d / %0d", correct_count, NUM_TESTS);
        $stop;
    end

endmodule