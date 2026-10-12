`define BITS(x) $rtoi($ceil($clog2(x)))

`define IDLE   2'd0
`define LOAD   2'd1
`define SHIFT  2'd2
`define DONE   2'd3

module rndFSM
(
    clk, start, rst,
    en_x, load_x,
    load_shift_counter, en_shift_counter, 
    shift_counter_cout,
    done
); 
    localparam numOfStates = 4;

    input logic clk, start, rst;
    input logic shift_counter_cout;
    output logic en_x, load_x, load_shift_counter, en_shift_counter, done;

    logic [`BITS(numOfStates)-1:0] pstate, nstate;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pstate <= `IDLE;
        end
        else begin
            pstate <= nstate;
        end
    end

    always@(*) begin
        en_x               = 1'b0;
        load_x             = 1'b0;
        load_shift_counter = 1'b0;
        en_shift_counter   = 1'b0;
        done               = 1'b0;

        case (pstate)
            `IDLE: begin
                
            end

            `LOAD: begin
                load_x = 1'b1;
                load_shift_counter = 1'b1;
            end

            `SHIFT: begin
                en_x = shift_counter_cout? 1'b0: 1'b1;
                en_shift_counter = shift_counter_cout? 1'b0: 1'b1;
            end

            `DONE: begin
                done = 1'b1;
            end
        endcase
    end


    always@(pstate, start, shift_counter_cout) begin
        nstate = pstate;
        case (pstate)
            `IDLE: begin
                if (start)
                    nstate = `LOAD;
            end

            `LOAD: begin
                nstate = `SHIFT;
            end

            `SHIFT: begin
                if (shift_counter_cout)
                    nstate = `DONE;
            end

            `DONE: begin
                nstate = `IDLE;
            end
        endcase
    end


endmodule
