`timescale 1ns / 1ns

module tbTop;

    localparam INP_SIZE = 8;
    localparam ITT_SIZE = 6;
    localparam MESSAGE_LENGTH = 4 * INP_SIZE;

    reg clk, rst, start;
    reg [MESSAGE_LENGTH-1:0] message;
    

    wire [MESSAGE_LENGTH-1:0] digest;
    wire [ITT_SIZE-1:0] itt;
    wire done;

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
    
        message = 32'hdf01f0b7; 

        #20;
        rst = 0;

        #10;
        start = 1;
        @(posedge clk);
        start = 0;
        
        wait(done);
        
        @(posedge clk);
        $display("Final Digest: %h", digest);
        $stop;
    end

endmodule