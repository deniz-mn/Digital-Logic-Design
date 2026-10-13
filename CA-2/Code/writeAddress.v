module writeAddress
#(
    parameter NUM_O_MATRIX_ROWS = 8,
    parameter MEMORY_LENGTH = 128
)
(
    block_num,
    write_address
);
    input wire [$clog2(NUM_O_MATRIX_ROWS+1)-1:0] block_num;

    output wire [$clog2(MEMORY_LENGTH)-1:0] write_address;
    
    assign write_address = (block_num-1) + (NUM_O_MATRIX_ROWS*(NUM_O_MATRIX_ROWS+1));
endmodule