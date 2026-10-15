module fsm(
        clk, rst,
        en_reg, load_init,
        start_rnd,
        rnd_done,
        en_F_multiplier,
        load_F_multiplier,
        F_multiplier_done,
        load_itt, en_itt,
        itt_done,
        start,
        done
);
    input wire clk, rst;
    input wire itt_done;
    input wire F_multiplier_done;
    input wire rnd_done;
    input wire start;
    output wire en_reg, load_init;
    output wire start_rnd;
    output wire en_F_multiplier;
    output wire load_F_multiplier;
    output wire load_itt, en_itt;
    output wire done;

    wire state[6:0];

    wire idle;
    wire init;
    wire wait_rnd;
    wire load_multi;
    wire wait_multi;
    wire update;

    wire start_inv;
    wire itt_done_inv;
    wire rnd_done_inv;
    wire F_multiplier_done_inv;

    wire wait_inp0;

    assign state[0] = idle;
    assign state[1] = init;
    assign state[2] = wait_rnd;
    assign state[3] = load_multi;
    assign state[4] = wait_multi;
    assign state[5] = update;
    assign state[6] = done;

    wire next_state_idle;
    
    notModule #(.INP_SIZE(1)) start_inv_inst(.inp(start), .out(start_inv));
    notModule #(.INP_SIZE(1)) rnd_done_inv_inst(.inp(rnd_done), .out(rnd_done_inv));
    notModule #(.INP_SIZE(1)) itt_done_inv_inst(.inp(itt_done), .out(itt_done_inv));
    notModule #(.INP_SIZE(1)) multi_done_inv_inst(.inp(F_multiplier_done), .out(F_multiplier_done_inv));

    assign load_init = init;
    assign load_itt = init;
    assign start_rnd = wait_rnd;
    assign load_F_multiplier = load_multi;
    assign en_F_multiplier = wait_multi;
    assign en_reg = update;
    assign en_itt = update;

    c2 wait_inp0_inst (
                .D00(1'b0), .D01(1'b1), .D10(rnd_done_inv), .D11(1'b1),
                 .A1(1'b0), .B1(wait_rnd),
                  .A0(update), .B0(itt_done_inv),
                   .out(wait_inp0));

    c2 next_state_idle_inst (
                .D00(done), .D01(1'b1), .D10(1'b0), .D11(1'b1),
                 .A1(1'b0), .B1(1'b0),
                  .A0(idle), .B0(start_inv),
                   .out(next_state_idle));

    s2 idle_inst(
            .D00(next_state_idle), .D01(1'b1), .D10(1'b0), .D11(1'b0),
             .A1(1'b0), .B1(1'b0),
              .A0(rst), .B0(1'b1),
               .clr(1'b0), .clk(clk), 
                .out(idle));

    s2 init_inst(
            .D00(1'b0), .D01(1'b1), .D10(start), .D11(1'b1),
             .A1(init), .B1(1'b0),
              .A0(idle), .B0(start),
               .clr(rst), .clk(clk),
                .out(init));

    s2 wait_rnd_inst(
            .D00(wait_inp0), .D01(1'b1), .D10(1'b0), .D11(1'b0),
             .A1(1'b0), .B1(1'b0),
              .A0(init), .B0(start_inv),
               .clr(rst), .clk(clk),
                .out(wait_rnd));

    s2 load_multi_inst(
            .D00(1'b0), .D01(1'b1), .D10(1'b0), .D11(1'b0),
             .A1(1'b0), .B1(1'b0),
              .A0(rnd_done), .B0(wait_rnd),
               .clr(rst), .clk(clk),
                .out(load_multi));

    s2 wait_multi_inst(
            .D00(1'b0), .D01(1'b1), .D10(1'b1), .D11(1'b1),
             .A1(1'b0), .B1(load_multi),
              .A0(wait_multi), .B0(F_multiplier_done_inv),
               .clr(rst), .clk(clk),
                .out(wait_multi));

    s2 update_inst(
            .D00(1'b0), .D01(1'b1), .D10(1'b0), .D11(1'b0),
             .A1(1'b0), .B1(1'b0),
              .A0(F_multiplier_done), .B0(wait_multi),
               .clr(rst), .clk(clk),
                .out(update));

    s2 done_inst(
            .D00(1'b0), .D01(1'b1), .D10(1'b0), .D11(1'b0),
             .A1(1'b0), .B1(1'b0),
              .A0(itt_done), .B0(update),
               .clr(rst), .clk(clk),
                .out(done));
     


endmodule