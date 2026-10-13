`timescale 1ns / 1ns

module tb_stripesPE;

    localparam B_BITS = 4;
    localparam A_BITS = 4;
    localparam ROWS = 4;
    localparam CLK_PERIOD = 10;

    localparam OUT_SIZE = 10; 

    reg clk;
    reg rst;
    reg [B_BITS * ROWS - 1:0] tb_i_vec_b;
    reg [A_BITS - 1:0]        tb_i_vec_a;
    reg                       tb_i_is_msb;
    reg                       tb_i_is_lsb;
    reg                       tb_i_is_valid;
    reg                       tb_reset_vals;
    reg [OUT_SIZE - 1:0]      tb_initial_sum;
    
    wire [OUT_SIZE - 1:0]     tb_o_dot_product;

    stripesPE #(
        .NUM_O_B_BITS(B_BITS),
        .NUM_O_A_BITS(A_BITS),
        .NUM_OF_ROWS(ROWS)
    ) uut (
        .i_vec_b(tb_i_vec_b),
        .i_vec_a(tb_i_vec_a),
        .i_is_msb(tb_i_is_msb),
        .i_is_lsb(tb_i_is_lsb),
        .i_is_valid(tb_i_is_valid),
        .rst(rst),
        .clk(clk),
        .reset_vals(tb_reset_vals),
        .initial_sum(tb_initial_sum),
        .o_dot_product(tb_o_dot_product)
    );

    always #(CLK_PERIOD / 2) clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        tb_i_vec_b = 16'hE365;
        tb_i_vec_a = 4'b0;
        tb_i_is_msb = 0;
        tb_i_is_lsb = 0;
        tb_i_is_valid = 0;
        tb_reset_vals = 0;
        tb_initial_sum = 0;
        
        #(CLK_PERIOD * 2);
        rst = 0;
        tb_reset_vals = 1;
        
        @(posedge clk);
        tb_reset_vals = 0;

        $display("Time=%0t | B_Vec = [b3:%d, b2:%d, b1:%d, b0:%d]", $time,
            $signed(tb_i_vec_b[15:12]), $signed(tb_i_vec_b[11:8]), 
            $signed(tb_i_vec_b[7:4]), $signed(tb_i_vec_b[3:0]));

        
        @(posedge clk);
        tb_i_is_valid = 1;
        tb_i_is_msb = 1;
        tb_i_is_lsb = 0;
        tb_i_vec_a = 4'b1100;
        $display("Time=%0t | Cycle 1 (MSB): A_Vec=%b | Accum_Out=%d", 
                 $time, tb_i_vec_a, $signed(tb_o_dot_product));

        @(posedge clk);
        tb_i_is_valid = 1;
        tb_i_is_msb = 0;
        tb_i_is_lsb = 0;
        tb_i_vec_a = 4'b0100;
        $display("Time=%0t | Cycle 2:       A_Vec=%b | Accum_Out=%d", 
                 $time, tb_i_vec_a, $signed(tb_o_dot_product));

        @(posedge clk);
        tb_i_is_valid = 1;
        tb_i_is_msb = 0;
        tb_i_is_lsb = 0;
        tb_i_vec_a = 4'b0001;
        $display("Time=%0t | Cycle 3:       A_Vec=%b | Accum_Out=%d", 
                 $time, tb_i_vec_a, $signed(tb_o_dot_product));

        @(posedge clk);
        tb_i_is_valid = 1;
        tb_i_is_msb = 0;
        tb_i_is_lsb = 1;
        tb_i_vec_a = 4'b1011;
        $display("Time=%0t | Cycle 4 (LSB): A_Vec=%b | Accum_Out=%d", 
                 $time, tb_i_vec_a, $signed(tb_o_dot_product));

        @(posedge clk);
        tb_i_is_valid = 0;
        tb_i_is_msb = 0;
        tb_i_is_lsb = 0;
        $display("Time=%0t | --- Test End ---", $time);
        $display("Time=%0t | Final Result = %d", $time, $signed(tb_o_dot_product));
        
        #10;
        $stop;
    end

endmodule