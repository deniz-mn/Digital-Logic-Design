`timescale 1ns / 1ns

module tbRndTop;

    localparam ITT_SIZE = 6;

    reg clk;
    reg rst;
    reg start;
    reg [ITT_SIZE-1:0] tb_itt;

    wire [1:0] tb_rnd;
    wire tb_done;

    rndTop #(
        .ITT_SIZE(ITT_SIZE)
    ) uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .itt(tb_itt),
        .rnd(tb_rnd),
        .done(tb_done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        tb_itt = 0;

        #20;
        rst = 0;
        #10;

        @(posedge clk);
        tb_itt = 6'd2;
        
        start = 1;
        @(posedge clk);
        start = 0;

        @(posedge tb_done);
        @(posedge clk);
        $display("Input itt=%b | Output rnd=%b", tb_itt, tb_rnd);
        
        #20;

        @(posedge clk);
        tb_itt = 6'd7;
        
        start = 1; 
        @(posedge clk);
        start = 0;

        @(posedge tb_done);
        @(posedge clk);
        $display("Input itt=%b | Output rnd=%b", tb_itt, tb_rnd);

        #20;

        @(posedge clk);
        tb_itt = 6'd29;
        
        start = 1; 
        @(posedge clk);
        start = 0;

        @(posedge tb_done);
        @(posedge clk);
        $display("Input itt=%b | Output rnd=%b", tb_itt, tb_rnd);

        #20;

        @(posedge clk);
        tb_itt = 6'd54;
        
        start = 1; 
        @(posedge clk);
        start = 0;

        @(posedge tb_done);
        @(posedge clk);
        $display("Input itt=%b | Output rnd=%b", tb_itt, tb_rnd);

        #20;
        $stop;
    end

endmodule