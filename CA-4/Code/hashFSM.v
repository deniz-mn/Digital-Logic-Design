module hashFSM(
    clk, rst,
    start, done,
    it_cout,
    selValue,
    load_it,
    en_value,
    en_it,
    done_rnd,
    start_rnd
);
    input wire clk, start, rst;
    input wire it_cout;
    input wire done_rnd;

    output reg en_it, en_value;
    output reg load_it;
    output reg done, selValue;
    output reg start_rnd;

    reg [2:0] pstate, nstate;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pstate <= 3'd0;
        end
        else begin
            pstate <= nstate;
        end
    end

    always @(*) begin
        en_it = 1'b0;
        en_value = 1'b0;
        load_it = 1'b0;
        done = 1'b0;
        selValue = 1'b0;
        start_rnd = 1'b0;
        
        case (pstate)
            3'd0: begin
            end

            3'd1: begin
                selValue = 1'b1;
                en_value = 1'b1;
                load_it = 1'b1;
            end

            3'd2: begin
                start_rnd = 1'b1;
            end

            3'd3: begin
                selValue = 1'b0;
                en_value = 1'b1;
                en_it = 1'b1;
            end
            
            3'd4: begin
                done = 1'b1;
            end
        endcase
    end

    always @(*) begin
        nstate = pstate;
        case (pstate)
            3'd0: begin
                if (start)
                    nstate = 3'd1;
            end

            3'd1: begin
                if (!start)
                    nstate = 3'd2;
            end

            3'd2: begin
                if (done_rnd)
                    nstate = 3'd3;
                else 
                    nstate = 3'd2;
            end

            3'd3: begin
                if (it_cout)
                    nstate = 3'd4;
                else 
                    nstate = 3'd2;
            end
            
            3'd4: begin
                nstate = 3'd0;
            end
        endcase
    end
endmodule