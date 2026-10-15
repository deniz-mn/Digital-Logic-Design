module tbTop;

    reg clk, rst, start;
    reg [31:0] message;

    wire done;
    wire [31:0] hashed;

    initial clk = 0;
    always #1 clk = ~clk;

    initial begin
        rst = 1;
        start = 0;
        message = 32'h3761eded;

        #4 rst = 0;
        #2 start = 1;
        #2 start = 0;
    end

    top DUT (
        .clk(clk),
        .rst(rst),
        .start(start),
        .message(message),
        .done(done),
        .hashed(hashed)
    );

    always @(posedge clk) begin
        if (done) begin
            $display("Hash result: %h", hashed);
            $stop;
        end
    end

endmodule