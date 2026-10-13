module matrixMultiplierTop 
#(
    parameter MEMORY_LENGTH = 128,
    parameter NUM_O_A_BITS = 16,
    parameter NUM_O_B_BITS = 16,
    parameter NUM_O_MATRIX_ROWS = 8
)
(
    clk, rst, start, done,
    address, write, write_data, read_data
);

    localparam MEMORY_WIDTH = NUM_O_A_BITS + NUM_O_B_BITS + $clog2(NUM_O_MATRIX_ROWS/2);
    localparam ADDRESS_WIDTH = $clog2(MEMORY_LENGTH);

    input wire clk, rst, start;
    output wire done;

    output wire [ADDRESS_WIDTH-1:0] address;
    output wire write;
    output wire [MEMORY_WIDTH-1:0] write_data;
    input wire [MEMORY_WIDTH-1:0] read_data;

    wire reset_vals, en_write_data_reg;
    wire i_is_msb, i_is_lsb, i_is_valid;
    wire en_a_reg_itt, en_block_itt, en_block_num;
    wire reset_a_reg_itt, reset_block_itt, reset_block_num;
    wire a_reg_en, b_reg_en;
    
    wire a_reg_itt_cout, block_itt_cout, block_num_cout;

    matrixMultiplierDatapath #(
        .MEMORY_LENGTH(MEMORY_LENGTH),
        .NUM_O_A_BITS(NUM_O_A_BITS),
        .NUM_O_B_BITS(NUM_O_B_BITS),
        .NUM_O_MATRIX_ROWS(NUM_O_MATRIX_ROWS)
    ) inst_datapath (
        .clk(clk), 
        .rst(rst),
        .reset_vals(reset_vals), 
        .write(write),
        .i_is_msb(i_is_msb), 
        .i_is_lsb(i_is_lsb), 
        .i_is_valid(i_is_valid),
        .a_reg_en(a_reg_en), 
        .b_reg_en(b_reg_en), 
        .en_a_reg_itt(en_a_reg_itt), 
        .en_block_itt(en_block_itt), 
        .en_block_num(en_block_num),
        .reset_a_reg_itt(reset_a_reg_itt), 
        .reset_block_itt(reset_block_itt), 
        .reset_block_num(reset_block_num),
        .a_reg_itt_cout(a_reg_itt_cout), 
        .block_itt_cout(block_itt_cout), 
        .block_num_cout(block_num_cout),
        .read_data(read_data), 
        .write_data(write_data),
        .address(address)
    );

    matrixMultiplierController inst_controller (
        .clk(clk), 
        .rst(rst),
        .start(start), 
        .done(done),
        .reset_vals(reset_vals),
        .write(write),
        .i_is_msb(i_is_msb), 
        .i_is_lsb(i_is_lsb), 
        .i_is_valid(i_is_valid),
        .en_a_reg_itt(en_a_reg_itt), 
        .en_block_itt(en_block_itt), 
        .en_block_num(en_block_num),
        .reset_a_reg_itt(reset_a_reg_itt), 
        .reset_block_itt(reset_block_itt), 
        .reset_block_num(reset_block_num),
        .a_reg_en(a_reg_en),
        .b_reg_en(b_reg_en),
        .a_reg_itt_cout(a_reg_itt_cout), 
        .block_itt_cout(block_itt_cout), 
        .block_num_cout(block_num_cout)
    );

endmodule
