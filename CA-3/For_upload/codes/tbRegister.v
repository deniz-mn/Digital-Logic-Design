`timescale 1ns / 1ns

module tbRegister;

    localparam INP_SIZE = 8;

    reg clk;
    reg rst;
    reg [INP_SIZE - 1:0] tb_inp1;
    reg [INP_SIZE - 1:0] tb_inp2;
    reg [INP_SIZE - 1:0] tb_inp3;
    reg [1:0]            tb_sel;

    wire [INP_SIZE - 1:0] tb_out;

    register #(
        .INP_SIZE(INP_SIZE)
    ) uut (
        .clk(clk),
        .clr(rst),
        .inp1(tb_inp1),
        .inp2(tb_inp2),
        .inp3(tb_inp3),
        .sel(tb_sel),
        .out(tb_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        tb_inp1 = 8'd10;
        tb_inp2 = 8'd20;
        tb_inp3 = 8'd30;
        tb_sel  = 2'b00;
        
        #10;
        rst = 0;
        
        @(posedge clk);
        tb_sel = 2'b01;
        tb_inp1 = 8'd15;
        $display("Time=%0t | Init / Reset Done", $time);

        @(posedge clk);
        $display("Time=%0t | Sel=1 (Load Inp1) | Inp1=%d | Out=%d", $time, tb_inp1, tb_out);
        
        tb_sel = 2'b10;
        tb_inp2 = 8'd25;

        @(posedge clk);
        $display("Time=%0t | Sel=2 (Load Inp2) | Inp2=%d | Out=%d", $time, tb_inp2, tb_out);
        
        tb_sel = 2'b11;
        tb_inp3 = 8'd35;

        @(posedge clk);
        $display("Time=%0t | Sel=3 (Load Inp3) | Inp3=%d | Out=%d", $time, tb_inp3, tb_out);
        
        tb_sel = 2'b00;
        tb_inp1 = 8'hFF; 
        tb_inp2 = 8'hFF; 
        tb_inp3 = 8'hFF;

        @(posedge clk);
        $display("Time=%0t | Sel=0 (Hold Val)  | Inps Changed to FF | Out=%d", $time, tb_out);

        @(posedge clk);
        $stop;
    end

endmodule