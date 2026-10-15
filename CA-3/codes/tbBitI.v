`timescale 1ns / 1ns

module tbBitI;

    localparam INP_SIZE = 4;

    reg [INP_SIZE-1:0] tb_inp;
    reg [1:0] tb_num;
    wire tb_out;

    bitI #(
        .INP_SIZE(INP_SIZE)
    ) uut (
        .inp(tb_inp),
        .num(tb_num),
        .out(tb_out)
    );

    initial begin
        $display("=== bitI Module Test ===");
        
        tb_inp = 4'b1010;
        tb_num = 2'b00;
        #10;
        $display("num=%b, inp=%b, out=%b (Expected: %b)", 
                 tb_num, tb_inp, tb_out, tb_inp[0]);
        
        tb_inp = 4'b1010;
        tb_num = 2'b01;
        #10;
        $display("num=%b, inp=%b, out=%b (Expected: %b)", 
                 tb_num, tb_inp, tb_out, tb_inp[1]);
        
        tb_inp = 4'b1010;
        tb_num = 2'b10;
        #10;
        $display("num=%b, inp=%b, out=%b (Expected: %b)", 
                 tb_num, tb_inp, tb_out, tb_inp[2]);
        
        tb_inp = 4'b1010;
        tb_num = 2'b11;
        #10;
        $display("num=%b, inp=%b, out=%b (Expected: %b)", 
                 tb_num, tb_inp, tb_out, tb_inp[3]);

        $stop;
    end

endmodule