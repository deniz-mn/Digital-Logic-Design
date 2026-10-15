`timescale 1ns / 1ns

module tbAdder;

    localparam INP_SIZE = 8;

    reg [INP_SIZE - 1:0] tb_inp0;
    reg [INP_SIZE - 1:0] tb_inp1;
    
    reg clk; 

    wire [INP_SIZE - 1:0] tb_out;
    wire [INP_SIZE - 1:0] expected_sum;

    assign expected_sum = tb_inp0 + tb_inp1;

    adder #(
        .INP_SIZE(INP_SIZE)
    ) uut (
        .inp0(tb_inp0),
        .inp1(tb_inp1),
        .out(tb_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        tb_inp0 = 0;
        tb_inp1 = 0;
        
        #20;
        
        @(posedge clk);
        tb_inp0 = 8'd1;
        tb_inp1 = 8'd1;
        
        @(posedge clk);
        $display("Time=%0t | %d + %d = %d | Expected: %d", 
                $time, $signed(tb_inp0), $signed(tb_inp1), $signed(tb_out), $signed(expected_sum));

        @(posedge clk);
        tb_inp0 = 8'd0;
        tb_inp1 = 8'd55;
        
        @(posedge clk);
        $display("Time=%0t | %d + %d = %d | Expected: %d", 
                $time, $signed(tb_inp0), $signed(tb_inp1), $signed(tb_out), $signed(expected_sum));

        @(posedge clk);
        tb_inp0 = 8'd250;
        tb_inp1 = 8'd10;
        
        @(posedge clk);
        $display("Time=%0t | %d + %d = %d | Expected: %d", 
                $time, $signed(tb_inp0), $signed(tb_inp1), $signed(tb_out), $signed(expected_sum));

        @(posedge clk);
        tb_inp0 = -8'd20;
        tb_inp1 = 8'd5;
        
        @(posedge clk);
        $display("Time=%0t | %d + %d = %d | Expected: %d", 
                $time, $signed(tb_inp0), $signed(tb_inp1), $signed(tb_out), $signed(expected_sum));

        @(posedge clk);
        tb_inp0 = -8'd10;
        tb_inp1 = -8'd10;
        
        @(posedge clk);
        $display("Time=%0t | %d + %d = %d | Expected: %d", 
                $time, $signed(tb_inp0), $signed(tb_inp1), $signed(tb_out), $signed(expected_sum));
        
        @(posedge clk);
        tb_inp0 = 8'd127;
        tb_inp1 = 8'd127;

        @(posedge clk);
        $display("Time=%0t | %d + %d = %d | Expected: %d", 
                $time, $signed(tb_inp0), $signed(tb_inp1), $signed(tb_out), $signed(expected_sum));

        @(posedge clk);
        #10;
        $stop;
    end

endmodule