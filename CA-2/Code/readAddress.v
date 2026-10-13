module readAddress
#(
    parameter NUM_O_MATRIX_ROWS = 8,
    parameter MEMORY_LENGTH = 128
)
(
    block_itt,
    block_num,
    read_address
);
    input wire [$clog2(NUM_O_MATRIX_ROWS)-1:0] block_itt;
    input wire [$clog2(NUM_O_MATRIX_ROWS+1)-1:0] block_num;

    output wire [$clog2(MEMORY_LENGTH)-1:0] read_address;

    assign read_address = block_itt + NUM_O_MATRIX_ROWS*block_num;
endmodule