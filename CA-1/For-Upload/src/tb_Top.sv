module tb_Top;

    parameter messageSize = 128;
    parameter wordSize = 32;
    parameter numOfIterations = 64;
    localparam numOfWords = messageSize / wordSize;

    logic clk, rst, start;
    logic [messageSize-1:0] message;
    logic [wordSize-1:0] initialValues [0:numOfWords-1];
    logic [wordSize-1:0] constants [0:numOfIterations-1];

    logic done;
    logic [messageSize-1:0] hashed;

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        start = 0;
        message = 128'h41a801a8e81df62b14a661b85c97bf45;
        initialValues[3] = 32'h67452301;
        initialValues[2] = 32'hefcdab89;
        initialValues[1] = 32'h98badcfe;
        initialValues[0] = 32'h10325476;

        $readmemh("constant.mem", constants);

        #20 rst = 0;
        #10 start = 1;
        #10 start = 0;
    end

    Top #(
        .messageSize(messageSize),
        .wordSize(wordSize),
        .numOfIterations(numOfIterations)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .start(start),
        .message(message),
        .constants(constants),
        .initialValues(initialValues),
        .done(done),
        .hashed(hashed)
    );

    always @(posedge clk) begin
        if (done) begin
            $display("Hash result: %h", hashed);
            $stop;
        end
    end

    always @(posedge DUT.hash_top_inst.hashDatapath_inst.it[0] or negedge DUT.hash_top_inst.hashDatapath_inst.it[0]) begin
        $display("Iteration %0d:", DUT.hash_top_inst.hashDatapath_inst.it);
        $display("    rnd = 0x%0h", DUT.hash_top_inst.hashDatapath_inst.rnd);
        $display("    LRF = 0x%0h", DUT.hash_top_inst.hashDatapath_inst.LRF);
        $display("    hash = 0x%0h", DUT.hash_top_inst.hashDatapath_inst.hashed);
    end

endmodule
