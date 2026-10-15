module hashDatapath(    
    clk,
    selValue,
    message,
    rnd,
    load_it,
    en_value,
    en_it,
    it_cout,
    hashed,
    it 
);
    input wire clk, selValue;
    input wire en_it, en_value;
    input wire load_it;
    input wire [31:0] message;
    input wire [1:0] rnd;

    output wire it_cout;
    output wire [31:0] hashed;
    output wire [5:0] it;

    reg [7:0] A, B, C, D;
    reg [7:0] next_A, next_B, next_C, next_D;

    wire [7:0] F, const_val;
    wire [7:0] M_selected;
    wire [7:0] F_summed;
    wire [7:0] B_next_val;
    wire [1:0] msg_idx;

    nBitUpCounter it_counter (
        .clk(clk),
        .load(load_it),
        .en(en_it),
        .din(6'd0),
        .cout(it_cout),
        .dout(it)
    );

    constModule constInst (
        .it(it),
        .const_out(const_val)
    );

    FGenerator FGen (
        .it(it),
        .A(A), .B(B), .C(C), .D(D),
        .F(F)
    );

    assign msg_idx = (2'd3 - rnd);

    assign M_selected = (msg_idx == 2'd3) ? message[31:24] :
                        (msg_idx == 2'd2) ? message[23:16] :
                        (msg_idx == 2'd1) ? message[15:8] :
                                            message[7:0];

    assign F_summed = F + A + const_val + M_selected;
    assign B_next_val = F_summed[7:4] * F_summed[3:0];

    always @(*) begin
        if (selValue) begin
            next_A = 8'h01;
            next_B = 8'h89;
            next_C = 8'hfe;
            next_D = 8'h76;
        end else begin
            next_A = D;
            next_B = B + B_next_val;
            next_C = B;
            next_D = C;
        end
    end

    always @(posedge clk) begin
        if (en_value) begin
            A <= next_A;
            B <= next_B;
            C <= next_C;
            D <= next_D;
        end
    end

    assign hashed = {A, B, C, D};

endmodule