    module matrixMultiplierDatapath 
    #(
        parameter MEMORY_LENGTH = 128,
        parameter NUM_O_A_BITS = 16,
        parameter NUM_O_B_BITS = 16,
        parameter NUM_O_MATRIX_ROWS = 8
    )
    (
        clk, rst,
        reset_vals, write,
        i_is_msb, i_is_lsb, i_is_valid,
        a_reg_en, b_reg_en,
        en_a_reg_itt, en_block_itt, en_block_num,
        reset_a_reg_itt, reset_block_itt, reset_block_num,
        a_reg_itt_cout, block_itt_cout, block_num_cout,
        read_data, write_data, address
        
    );
        localparam NUM_O_SPE_ROWS = NUM_O_MATRIX_ROWS/2;
        localparam MEMORY_WIDTH = NUM_O_A_BITS + NUM_O_B_BITS + $clog2(NUM_O_SPE_ROWS);

        input wire clk, rst;    
        input wire reset_vals;
        input wire write;
        input wire i_is_msb, i_is_lsb, i_is_valid;

        input wire en_a_reg_itt, en_block_itt, en_block_num;
        input wire reset_a_reg_itt, reset_block_itt, reset_block_num;
        output wire a_reg_itt_cout, block_itt_cout, block_num_cout;

        input wire [MEMORY_WIDTH-1:0] read_data;
        output wire [MEMORY_WIDTH-1:0] write_data;

        wire [MEMORY_WIDTH-1:0] write_data_reg_input;

        wire [MEMORY_WIDTH-1:0] spe_connector;

        wire [$clog2(MEMORY_LENGTH)-1:0] read_address, write_address;
        output wire [$clog2(MEMORY_LENGTH)-1:0] address;

        wire [NUM_O_A_BITS*NUM_O_MATRIX_ROWS-1:0] a_out;
        wire [NUM_O_B_BITS*NUM_O_MATRIX_ROWS-1:0] b_out;

        wire [NUM_O_MATRIX_ROWS-1:0] a_vec;

        wire [$clog2(NUM_O_MATRIX_ROWS)-1:0] block_itt;
        wire [$clog2(NUM_O_MATRIX_ROWS+1)-1:0] block_num;
        wire [$clog2(NUM_O_A_BITS)-1:0] a_reg_itt;

        input wire a_reg_en;
        input wire b_reg_en;

        wire [NUM_O_MATRIX_ROWS-1:0] a_en;
        wire [NUM_O_MATRIX_ROWS-1:0] b_en;
        
        wire [NUM_O_MATRIX_ROWS-1:0] block_itt_decoded;

        decoder #(
            .ONE_HOT_LENGTH(NUM_O_MATRIX_ROWS)
        ) itt_decoder (
            block_itt,
            block_itt_decoded
        );

        genvar i;

        generate
            for (i = 0; i < NUM_O_MATRIX_ROWS; i = i+1) begin
                assign a_vec[i] = a_out[(i*NUM_O_A_BITS)+a_reg_itt];
                assign a_en[i] = a_reg_en && block_itt_decoded[i];
                assign b_en[i] = b_reg_en && block_itt_decoded[i];
                register #(
                    .NUM_OF_BITS_INPUT(MEMORY_WIDTH),
                    .NUM_OF_BITS_OUTPUT(NUM_O_A_BITS)
                ) a_reg (
                    .clk(clk),
                    .load(a_en[i]),
                    .rst(rst),
                    .inp(read_data),
                    .out(a_out[(i+1)*NUM_O_A_BITS-1 -: NUM_O_A_BITS])
                );
                register #(
                    .NUM_OF_BITS_INPUT(MEMORY_WIDTH),
                    .NUM_OF_BITS_OUTPUT(NUM_O_B_BITS)
                ) b_reg (
                    .clk(clk),
                    .load(b_en[i]),
                    .rst(rst),
                    .inp(read_data),
                    .out(b_out[(i+1)*NUM_O_B_BITS-1 -: NUM_O_B_BITS])
                );

            end
        endgenerate

        upCounter
        #(
            .NUM_OF_BITS($clog2(NUM_O_MATRIX_ROWS)),
            .GOAL(NUM_O_MATRIX_ROWS-1)
        ) block_itt_counter (
            .clk(clk),
            .rst(rst),
            .load(reset_block_itt),
            .en(en_block_itt), 
            .din(0),
            .cout(block_itt_cout),
            .dout(block_itt)
        );

        upCounter
        #(
            .NUM_OF_BITS($clog2(NUM_O_MATRIX_ROWS+1)),
            .GOAL(NUM_O_MATRIX_ROWS)
        ) block_num_counter (
            .clk(clk),
            .rst(rst),
            .load(reset_block_num),
            .en(en_block_num), 
            .din(0),
            .cout(block_num_cout),
            .dout(block_num)
        );

        downCounter
        #(
            .NUM_OF_BITS($clog2(NUM_O_A_BITS)),
            .GOAL(0)
        ) a_reg_itt_counter (
            .clk(clk),
            .rst(rst),
            .load(reset_a_reg_itt),
            .en(en_a_reg_itt), 
            .din(NUM_O_A_BITS-1),
            .cout(a_reg_itt_cout),
            .dout(a_reg_itt)
        );

        readAddress
        #(
            .NUM_O_MATRIX_ROWS(NUM_O_MATRIX_ROWS),
            .MEMORY_LENGTH(MEMORY_LENGTH)
        ) read_address_calculator (
            .block_itt(block_itt),
            .block_num(block_num),
            .read_address(read_address)
        );

        writeAddress
        #(
            .NUM_O_MATRIX_ROWS(NUM_O_MATRIX_ROWS),
            .MEMORY_LENGTH(MEMORY_LENGTH)
        ) write_address_calculator (
            .block_num(block_num),
            .write_address(write_address)
        );

        assign address = write? write_address: read_address;

        stripesPE
        #(
            .NUM_O_B_BITS(NUM_O_B_BITS),
            .NUM_O_A_BITS(NUM_O_A_BITS),
            .NUM_OF_ROWS(NUM_O_SPE_ROWS)
        ) stripes_pe_inst1(
            .rst(rst),
            .clk(clk),
            .i_vec_b(b_out[(NUM_O_B_BITS*NUM_O_MATRIX_ROWS/2)-1:0]),
            .i_vec_a(a_vec[NUM_O_MATRIX_ROWS/2-1:0]),
            .i_is_msb(i_is_msb),
            .i_is_lsb(i_is_lsb),
            .i_is_valid(i_is_valid),
            .reset_vals(reset_vals),
            .initial_sum({MEMORY_LENGTH{1'b0}}),
            .o_dot_product(spe_connector)
        );

        stripesPE
        #(
            .NUM_O_B_BITS(NUM_O_B_BITS),
            .NUM_O_A_BITS(NUM_O_A_BITS),
            .NUM_OF_ROWS(NUM_O_SPE_ROWS)
        ) stripes_pe_inst2(
            .rst(rst),
            .clk(clk),
            .i_vec_b(b_out[(NUM_O_B_BITS*NUM_O_MATRIX_ROWS)-1:NUM_O_B_BITS*NUM_O_MATRIX_ROWS/2]),
            .i_vec_a(a_vec[NUM_O_MATRIX_ROWS-1:NUM_O_MATRIX_ROWS/2]),
            .i_is_msb(i_is_msb),
            .i_is_lsb(i_is_lsb),
            .i_is_valid(i_is_valid),
            .reset_vals(reset_vals),
            .initial_sum(spe_connector),
            .o_dot_product(write_data)
        );

    endmodule