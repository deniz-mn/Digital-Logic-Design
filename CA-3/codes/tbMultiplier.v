`timescale 1ns / 1ns

module tbMultiplier;

    localparam INP_SIZE = 8;

    reg clk;
    reg clr;
    reg en;
    reg load;
    reg [INP_SIZE-1:0] tb_inp;
    wire tb_done;
    wire [INP_SIZE-1:0] tb_out;

    multiplier #(
        .INP_SIZE(INP_SIZE)
    ) uut (
        .clr(clr),
        .clk(clk),
        .inp(tb_inp),
        .en(en),
        .load(load),
        .out(tb_out),
        .done(tb_done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        clr = 1;
        en = 0;
        load = 0;
        tb_inp = 8'b0;
        
        #20;
        clr = 0;
        #10;

        @(posedge clk);
        tb_inp = {4'd5, 4'd3};
        load = 1;
        
        @(posedge clk);
        load = 0;
        en = 1;
        
        @(posedge tb_done);
        @(posedge clk);
        @(posedge clk);
        $display("Time=%0t | Input: 3 * 5 | Output=%d", $time, tb_out);
        en = 0;
        
        #20;

        @(posedge clk);
        tb_inp = {4'd6, 4'd7};
        load = 1;
        
        @(posedge clk);
        load = 0;
        en = 1;
        
        @(posedge tb_done);
        @(posedge clk);
        @(posedge clk);
        $display("Time=%0t | Input: 7 * 6 | Output=%d", $time, tb_out);
        en = 0;
        
        #20;

        @(posedge clk);
        tb_inp = {4'd4, 4'd4};
        load = 1;
        
        @(posedge clk);
        load = 0;
        en = 1;
        
        @(posedge tb_done);
        @(posedge clk);
        @(posedge clk);
        $display("Time=%0t | Input: 4 * 4 | Output=%d", $time, tb_out);
        en = 0;

        #20;

        @(posedge clk);
        tb_inp = {4'd3, 4'd2};
        load = 1;
        
        @(posedge clk);
        load = 0;
        en = 1;
        
        @(posedge tb_done);
        @(posedge clk);
        @(posedge clk);
        $display("Time=%0t | Input: 2 * 3 | Output=%d", $time, tb_out);
        en = 0;

        #20;
        $stop;
    end

endmodule