module top
#(
    parameter MEMORY_LENGTH = 128,
    parameter NUM_O_A_BITS = 16,
    parameter NUM_O_B_BITS = 16,
    parameter NUM_O_MATRIX_ROWS = 8,
    parameter MEM_FILE = "input_memory.txt"
)
(
    clk, rst, start, done
);
    input wire clk, rst, start;
    output wire done;

    localparam MEMORY_WIDTH = NUM_O_A_BITS + NUM_O_B_BITS + $clog2(NUM_O_MATRIX_ROWS/2);
    localparam ADDRESS_WIDTH = $clog2(MEMORY_LENGTH);

    wire [ADDRESS_WIDTH-1:0] address;
    wire write;
    wire [MEMORY_WIDTH-1:0] write_data;
    wire [MEMORY_WIDTH-1:0] read_data;

    matrixMultiplierTop #(
        .MEMORY_LENGTH(MEMORY_LENGTH),
        .NUM_O_A_BITS(NUM_O_A_BITS),
        .NUM_O_B_BITS(NUM_O_B_BITS),
        .NUM_O_MATRIX_ROWS(NUM_O_MATRIX_ROWS)
    )
    inst_mm_top (
        .clk(clk), 
        .rst(rst), 
        .start(start), 
        .done(done),
        .address(address), 
        .write(write), 
        .write_data(write_data), 
        .read_data(read_data)
    );

    memory #(
        .MEMORY_WIDTH(MEMORY_WIDTH),
        .MEMORY_LENGTH(MEMORY_LENGTH),
        .MEM_FILE(MEM_FILE)
    )
    inst_mem (
        .clk(clk),
        .rst(rst), 
        .write(write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

endmodule
