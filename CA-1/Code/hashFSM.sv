`define BITS(x) $rtoi($ceil($clog2(x)))

`define IDLE            3'd0
`define LOAD_INITIAL    3'd1
`define GET_RND         3'd2
`define LOAD_STEP       3'd3
`define ROTATE          3'd4
`define UPDATE_VALUES   3'd5
`define DONE            3'd6

module hashFSM(
    clk, rst,
    start, done,
    it_cout,
    step_cout,
    selValue,
    load_it,
    load_step,
    load_LRF,
    en_value,
    en_it,
    en_LRF,
    en_step,
    done_rnd,
    start_rnd
);

    localparam numOfStates = 7;

    input logic clk, start, rst;
    input logic it_cout, step_cout;

    input logic done_rnd;

    output logic en_it, en_LRF, en_step, en_value;
    output logic load_it, load_LRF, load_step;
    output logic done, selValue;

    output logic start_rnd;
    

    logic [`BITS(numOfStates)-1:0] pstate, nstate;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            pstate <= `IDLE;
        end
        else begin
            pstate <= nstate;
        end
    end

    always @(*) begin
        
        en_it =         1'b0;
        en_LRF =        1'b0;
        en_step  =      1'b0;
        en_value  =     1'b0;
        load_it  =      1'b0;
        load_LRF  =     1'b0;
        load_step =     1'b0;
        done  =         1'b0;
        selValue =      1'b0;
        start_rnd =     1'b0;
        
        case (pstate)
            `IDLE: begin
                
            end

            `LOAD_INITIAL: begin
                selValue = 1'b1;
                en_value = 1'b1;
                load_it =  1'b1;
            end

            `GET_RND: begin
                // Here en_it was removed and moved to update values
                start_rnd = 1'b1;
            end

            `LOAD_STEP: begin
                load_step = 1'b1;
                load_LRF =  1'b1;
            end

            `ROTATE: begin
                en_step = 1'b1;
                en_LRF =  1'b1;
            end

            `UPDATE_VALUES: begin
                selValue = 1'b0;
                en_value = 1'b1;
                en_it =    1'b1;
            end
            
            `DONE: begin
                done =    1'b1;
            end

        endcase
    end
    

    always@(pstate, start, done_rnd, it_cout, step_cout) begin
        nstate = pstate;
        case (pstate)
            `IDLE: begin
                if (start)
                    nstate = `LOAD_INITIAL;
            end

            `LOAD_INITIAL: begin
                nstate = `GET_RND;    
            end

            `GET_RND: begin
                if (done_rnd)
                    nstate = `LOAD_STEP;
                else nstate = `GET_RND;
            end

            `LOAD_STEP: begin
                nstate = `ROTATE;
            end

            `ROTATE: begin
                if (step_cout)
                    nstate = `UPDATE_VALUES;
                else nstate = `ROTATE;
            end

            `UPDATE_VALUES: begin
                if (it_cout)
                    nstate = `DONE;
                else nstate = `GET_RND;
            end
            
            `DONE: begin
                nstate = `IDLE;
            end

        endcase
    end

endmodule