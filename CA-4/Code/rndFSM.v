module rndFSM(
    clk, start, rst,
    en_x, load_x,
    load_shift_counter, en_shift_counter, 
    shift_counter_cout,
    done
);
    input wire clk, start, rst;
    input wire shift_counter_cout;
    output reg en_x, load_x, load_shift_counter, en_shift_counter, done;
    
    reg [1:0] pstate, nstate;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pstate <= 2'd0;
        end
        else begin
            pstate <= nstate;
        end
    end

    always@(*) begin
        en_x = 1'b0;
        load_x = 1'b0;
        load_shift_counter = 1'b0;
        en_shift_counter = 1'b0;
        done = 1'b0;
        
        case (pstate)
            2'd0: begin
            end

            2'd1: begin
                load_x = 1'b1;
                load_shift_counter = 1'b1;
            end

            2'd2: begin
                en_x = shift_counter_cout ? 1'b0 : 1'b1;
                en_shift_counter = shift_counter_cout ? 1'b0 : 1'b1;
            end

            2'd3: begin
                done = 1'b1;
            end
        endcase
    end

    always@(*) begin
        nstate = pstate;
        case (pstate)
            2'd0: begin
                if (start)
                    nstate = 2'd1;
            end

            2'd1: begin
                nstate = 2'd2;
            end

            2'd2: begin
                if (shift_counter_cout)
                    nstate = 2'd3;
            end

            2'd3: begin
                nstate = 2'd0;
            end
        endcase
    end
endmodule