`timescale 1ns/1ns

module tbTop;

    localparam MEMORY_LENGTH = 128;
    localparam NUM_O_A_BITS = 16;
    localparam NUM_O_B_BITS = 16;
    localparam NUM_O_MATRIX_ROWS = 8;
    localparam MEM_FILE = "input_memory_(3).txt";

    reg clk, rst, start;
    wire done;

    top #(
        .MEMORY_LENGTH(MEMORY_LENGTH),
        .NUM_O_A_BITS(NUM_O_A_BITS),
        .NUM_O_B_BITS(NUM_O_B_BITS),
        .NUM_O_MATRIX_ROWS(NUM_O_MATRIX_ROWS),
        .MEM_FILE(MEM_FILE)
    ) UUT (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        start = 0;
        
        #10;
        rst = 0;
        
        #10;
        start = 1;
        
        #10;
        start = 0;

        @(posedge done);
        
        #10;
        $stop;
    end

    always @(posedge clk)
    begin
        if (UUT.inst_mm_top.write)
        begin
            $display("Address = %h | Data = %h",
                     UUT.inst_mm_top.address,
                     UUT.inst_mm_top.write_data);
        end
    end

endmodule
