module datapath
#(
    parameter INP_SIZE = 8,
    parameter ITT_SIZE = 6
)
(
    clk, rst,
    en_reg, load_init,
    message,
    A0, B0, C0, D0,
    const,
    itt,
    rnd,
    digest,
    start_rnd,
    rnd_done,
    en_F_multiplier,
    load_F_multiplier,
    F_multiplier_done,
    load_itt, en_itt,
    itt_done
);
    localparam MESSAGE_LENGTH = 4*INP_SIZE;

    input wire clk, rst;
    input wire en_reg, load_init;
    input wire [MESSAGE_LENGTH-1:0] message;
    input wire [INP_SIZE-1:0] const;
    input wire [INP_SIZE-1:0] A0, B0, C0, D0;
    input wire [1:0] rnd;

    input wire load_F_multiplier, load_itt, en_F_multiplier, en_itt, start_rnd;
    output wire F_multiplier_done, rnd_done, itt_done;
    output wire[ITT_SIZE-1:0] itt;
    output wire [MESSAGE_LENGTH-1:0] digest;

    wire[1:0] reg_sel = {load_init, en_reg};
    wire [INP_SIZE-1:0] B_reg_inp;
    wire [INP_SIZE-1:0] A_reg_out, B_reg_out, C_reg_out, D_reg_out;
    wire [MESSAGE_LENGTH-1:0] message_reg;

    wire [INP_SIZE-1:0] F_counter, F_summed, F_multiplied;
    wire [INP_SIZE-1:0] F_summed_0, F_summed_1;
    wire [INP_SIZE-1:0] M_selected;

    wire itt_done0;

    wire [1:0] rnd_reg;

    andModule #(.INP_SIZE(1)) itt_done0_inst(itt[0],itt[1],itt[2],itt[3], itt_done0);
    andModule #(.INP_SIZE(1)) itt_done_inst(itt[4],itt[5], itt_done0, 1'b1, itt_done);

    register #(
        .INP_SIZE(INP_SIZE)
        ) A_reg(
        .clk(clk), .clr(rst),
        .inp1(D_reg_out), .inp2(A0), .inp3(0),
        .sel(reg_sel),
        .out(A_reg_out)
    );
    register #(
        .INP_SIZE(INP_SIZE)
        ) B_reg(
        .clk(clk), .clr(rst),
        .inp1(B_reg_inp), .inp2(B0), .inp3(0),
        .sel(reg_sel),
        .out(B_reg_out)
    );
    register #(
        .INP_SIZE(INP_SIZE)
        ) C_reg(
        .clk(clk), .clr(rst),
        .inp1(B_reg_out), .inp2(C0), .inp3(0),
        .sel(reg_sel),
        .out(C_reg_out)
    );
    register #(
        .INP_SIZE(INP_SIZE)
        ) D_reg(
        .clk(clk), .clr(rst),
        .inp1(C_reg_out), .inp2(D0), .inp3(0),
        .sel(reg_sel),
        .out(D_reg_out)
    );
    
    register #(
    .INP_SIZE(MESSAGE_LENGTH)
    ) message_reg_inst(
        .clk(clk), .clr(1'b0),
        .inp1(message[MESSAGE_LENGTH-1:0]), .inp2(0), .inp3(0),
        .sel({1'b0,load_init}),
        .out(message_reg[MESSAGE_LENGTH-1:0])
    );

    counter #(
        .INP_SIZE(ITT_SIZE)
        ) itt_counter_inst (
            .clk(clk),
            .clr(rst), 
            .en(en_itt),
            .load(load_init),
            .step(6'd1), 
            .inp({{ITT_SIZE}{1'b0}}),
            .out(itt)
        );
    
    calF #(
        .INP_SIZE(INP_SIZE),
        .ITT_SIZE(ITT_SIZE)
    ) calF_inst (
        .itt(itt),
        .B(B_reg_out), .C(C_reg_out), .D(D_reg_out),
        .F(F_counter)
    );

    rndTop #(
        .ITT_SIZE(ITT_SIZE)
    )
        rndTop_inst
    (
        .clk(clk),
        .rst(rst),
        .start(start_rnd),
        .itt(itt),
        .rnd(rnd),
        .done(rnd_done)
    );

    register #(.INP_SIZE(2)) rnd_reg_inst (.clk(clk), .clr(rst), .inp1(rnd), .inp2(0), .inp3(0), .sel({1'b0, rnd_done}), .out(rnd_reg));

    mux #(
        .INP_SIZE(INP_SIZE)
        ) M_mux (
            .inp0(message_reg[31:24]),
            .inp1(message_reg[23:16]),
            .inp2(message_reg[15:8]),
            .inp3(message_reg[7:0]),
            .sel(rnd_reg),
            .out(M_selected)
        );


    adder #(
        .INP_SIZE(INP_SIZE) 
    )
        adder_F_summed_0
    (
        .inp0(F_counter),
        .inp1(A_reg_out),
        .out(F_summed_0)
    );

    adder #(
        .INP_SIZE(INP_SIZE) 
    )
        adder_F_summed_1
    (
        .inp0(M_selected),
        .inp1(const),
        .out(F_summed_1)
    );

    adder #(
        .INP_SIZE(INP_SIZE) 
    )
        adder_F_summed
    (
        .inp0(F_summed_0),
        .inp1(F_summed_1),
        .out(F_summed)
    );

    multiplier #(
        .INP_SIZE(INP_SIZE) 
    )
        F_multiplied_multiplier
    (
        .clr(rst),
        .clk(clk),
        .inp(F_summed),
        .en(en_F_multiplier),
        .load(load_F_multiplier), 
        .out(F_multiplied),
        .done(F_multiplier_done)
    );

    adder #(
        .INP_SIZE(INP_SIZE) 
    )
        adder_B_reg_inp
    (
        .inp0(F_multiplied),
        .inp1(B_reg_out),
        .out(B_reg_inp)
    );

    assign digest[31:24] = A_reg_out;
    assign digest[23:16] = B_reg_out;
    assign digest[15:8] = C_reg_out;
    assign digest[7:0]  = D_reg_out;
    
endmodule