`timescale 1ns / 1ns

module tbCounter;

    localparam INP_SIZE = 8;

    reg clk;
    reg clr;
    reg en;
    wire [INP_SIZE - 1:0] out;

    counter #(
        .INP_SIZE(INP_SIZE)
    ) uut (
        .clk(clk),
        .clr(clr),
        .en(en),
        .out(out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        clr = 1;
        en = 0; 
        
        #10;
        clr = 0;
        en = 1;

        repeat(10) begin
            @(posedge clk);
            $display("Time=%0t | en=%b, Counter Value = %d", $time, en, out);
        end

        @(posedge clk);
        en = 0;
        $display("Time=%0t | Counting Disabled", $time);
        
        repeat(3) begin
            @(posedge clk);
            $display("Time=%0t | en=%b, Counter Value = %d", $time, en, out);
        end

        $stop;
    end

endmodule