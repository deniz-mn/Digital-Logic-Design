
module rndFsm (
    clk, rst,
    start,
    en, load,
    done
);
    input wire clk, rst;
    input wire start;
    output wire en, load;
    output wire done;

    wire[3:0] state;

    wire idle_state, cal_rnd1_state, cal_rnd0_state, done_state;
    wire start_inv;

    wire next_state_idle;

    notModule start_inv_inst(start, start_inv);

    assign done = done_state;
    assign load = idle_state;

    assign state[0] = idle_state;
    assign state[1] = cal_rnd1_state;
    assign state[2] = cal_rnd0_state;
    assign state[3] = done_state;

    orModule en_inst(cal_rnd1_state, cal_rnd0_state, 1'b0, 1'b0, en);

    c2 next_state_idle_inst (
                .D00(done), .D01(1'b1), .D10(1'b0), .D11(1'b1),
                 .A1(1'b0), .B1(1'b0),
                  .A0(idle_state), .B0(start_inv),
                   .out(next_state_idle));

    s2 idle_inst(
            .D00(next_state_idle), .D01(1'b1), .D10(1'b0), .D11(1'b0),
             .A1(1'b0), .B1(1'b0),
              .A0(rst), .B0(1'b1),
               .clr(1'b0), .clk(clk), 
                .out(idle_state));

    s2 cal_rnd1_inst(
            .D00(1'b0), .D01(1'b1), .D10(1'b0), .D11(1'b0),
             .A1(1'b0), .B1(1'b0),
              .A0(start), .B0(idle_state),
               .clr(rst), .clk(clk),
                .out(cal_rnd1_state));

    s2 cal_rnd0_inst(
            .D00(cal_rnd1_state), .D01(1'b0), .D10(1'b0), .D11(1'b0),
             .A1(1'b0), .B1(1'b0),
              .A0(1'b0), .B0(1'b0),
               .clr(rst), .clk(clk),
                .out(cal_rnd0_state));

    s2 done_inst(
            .D00(cal_rnd0_state), .D01(1'b0), .D10(1'b0), .D11(1'b0),
             .A1(1'b0), .B1(1'b0),
              .A0(1'b1), .B0(rst),
               .clr(rst), .clk(clk),
                .out(done_state));

endmodule