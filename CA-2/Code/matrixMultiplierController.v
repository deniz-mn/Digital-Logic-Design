`define BITS(x) $rtoi($ceil($clog2(x)))

`define IDLE                4'd0
`define WAIT                4'd1
`define LOAD_A              4'd2
`define NEW_ROW             4'd3
`define LOAD_ROW            4'd4
`define PASS_MSB            4'd5
`define PASS_BITS           4'd6
`define WRITE_DATA          4'd7
`define DONE                4'd8


module matrixMultiplierController (
    clk, rst,
    start, done,
    reset_vals,
    write,
    i_is_msb, i_is_lsb, i_is_valid,
    en_a_reg_itt, en_block_itt, en_block_num,
    reset_a_reg_itt, reset_block_itt, reset_block_num,
    a_reg_en, b_reg_en,
    a_reg_itt_cout, block_itt_cout, block_num_cout
);
    input wire clk, rst, start;
    output reg done;
    

    output reg reset_vals;
    output reg write;
    output reg i_is_msb, i_is_lsb, i_is_valid;

    output reg en_a_reg_itt, en_block_itt, en_block_num;
    output reg reset_a_reg_itt, reset_block_itt, reset_block_num;
    
    output reg a_reg_en;
    output reg b_reg_en;

    
    input wire a_reg_itt_cout, block_itt_cout, block_num_cout;

    localparam numOfStates = 9;


    reg [`BITS(numOfStates)-1:0] pstate, nstate;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pstate <= `IDLE;
        end
        else begin
            pstate <= nstate;
        end
    end

    always @(*) begin

        reset_vals = 1'b0;
        write = 1'b0;
        i_is_msb = 1'b0;
        i_is_lsb = 1'b0;
        i_is_valid = 1'b0;
        en_a_reg_itt = 1'b0;
        en_block_itt = 1'b0;
        en_block_num = 1'b0;
        reset_a_reg_itt = 1'b0;
        reset_block_itt = 1'b0;
        reset_block_num = 1'b0;
        a_reg_en = 1'b0;
        b_reg_en = 1'b0;
        done = 1'b0;
        case (pstate)
            `IDLE: begin
            end

            `WAIT: begin
                reset_block_itt = 1'b1;
                reset_block_num = 1'b1;
                reset_a_reg_itt = 1'b1;
                reset_vals      = 1'b1;
            end

            `LOAD_A: begin
                en_block_itt    = 1'b1;
                a_reg_en        = 1'b1;
            end

            `NEW_ROW: begin
                reset_block_itt = 1'b1;
                reset_a_reg_itt = 1'b1;
                en_block_num    = 1'b1;
                reset_vals      = 1'b1;
            end

            `LOAD_ROW: begin
                en_block_itt     = 1'b1;
                b_reg_en         = 1'b1;
            end
            
            `PASS_MSB: begin
                i_is_msb        = 1'b1;
                i_is_valid      = 1'b1;
                en_a_reg_itt    = 1'b1;
            end

            `PASS_BITS: begin
                i_is_valid          = 1'b1;
                en_a_reg_itt        = 1'b1;
                i_is_lsb            = 1'b1;
            end

            `WRITE_DATA: begin
                i_is_lsb = 1'b1;
                write = 1'b1;
            end

            `DONE: begin
                done = 1'b1;
            end
            

        endcase
    end
    

    always@(*) begin
        nstate = pstate;
        case (pstate)
            `IDLE: begin
                if (start)
                    nstate = `WAIT;
            end

            `WAIT: begin
                if (start == 1'b0) begin
                    nstate = `LOAD_A;  
                end
            end

            `LOAD_A: begin
                if (block_itt_cout) begin
                    nstate = `NEW_ROW;
                end
            end

            `NEW_ROW: begin
                nstate = `LOAD_ROW;
            end

            `LOAD_ROW: begin
                if (block_itt_cout) begin
                    nstate = `PASS_MSB;
                end
            end

            `PASS_MSB: begin
                nstate = `PASS_BITS;
            end

            `PASS_BITS: begin
                if (a_reg_itt_cout) begin
                    nstate = `WRITE_DATA;
                end
            end

            `WRITE_DATA: begin
                if (block_num_cout) begin
                    nstate = `DONE;
                end
                else begin
                    nstate = `NEW_ROW;
                end
            end

            `DONE: begin
                nstate = `IDLE;
            end


        endcase
    end

endmodule