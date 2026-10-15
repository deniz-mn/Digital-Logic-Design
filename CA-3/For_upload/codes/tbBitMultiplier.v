`timescale 1ns / 1ns

module tbBitMultiplier;

    localparam INP_SIZE = 4;
    localparam OUT_SIZE = 8;

    reg [INP_SIZE-1:0] tb_a_inp;
    reg tb_b_inp;
    wire [OUT_SIZE:0] tb_out;

    bitMultiplier #(
        .INP_SIZE(INP_SIZE),
        .OUT_SIZE(OUT_SIZE)
    ) uut (
        .a_inp(tb_a_inp),
        .b_inp(tb_b_inp),
        .out(tb_out)
    );

    initial begin
        tb_a_inp = 4'b0000;
        tb_b_inp = 1'b0;
        
        #10;
        tb_a_inp = 4'b0101;
        tb_b_inp = 1'b1;
        $display("Time=%0t | a_inp=4'b%b, b_inp=%b -> out=8'b%b", 
                 $time, tb_a_inp, tb_b_inp, tb_out);
        
        #10;
        tb_a_inp = 4'b0101;
        tb_b_inp = 1'b0;
        $display("Time=%0t | a_inp=4'b%b, b_inp=%b -> out=8'b%b", 
                 $time, tb_a_inp, tb_b_inp, tb_out);
        
        #10;
        tb_a_inp = 4'b1010;
        tb_b_inp = 1'b1;
        $display("Time=%0t | a_inp=4'b%b, b_inp=%b -> out=8'b%b", 
                 $time, tb_a_inp, tb_b_inp, tb_out);
        
        #10;
        tb_a_inp = 4'b1111;
        tb_b_inp = 1'b1;
        $display("Time=%0t | a_inp=4'b%b, b_inp=%b -> out=8'b%b", 
                 $time, tb_a_inp, tb_b_inp, tb_out);
        
        #10;
        tb_a_inp = 4'b1111;
        tb_b_inp = 1'b0;
        $display("Time=%0t | a_inp=4'b%b, b_inp=%b -> out=8'b%b", 
                 $time, tb_a_inp, tb_b_inp, tb_out);

        #10;
        tb_a_inp = 4'b1001;
        tb_b_inp = 1'b1;
        $display("Time=%0t | a_inp=4'b%b, b_inp=%b -> out=8'b%b", 
                 $time, tb_a_inp, tb_b_inp, tb_out);

        #10;
        tb_a_inp = 4'b0011;
        tb_b_inp = 1'b1;
        $display("Time=%0t | a_inp=4'b%b, b_inp=%b -> out=8'b%b", 
                 $time, tb_a_inp, tb_b_inp, tb_out);

        #10;
        $display("Time=%0t | Bit Multiplier Test Completed", $time);
        $stop;
    end

endmodule