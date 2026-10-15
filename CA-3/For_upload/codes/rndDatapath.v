
module rndDatapath
#(
    parameter ITT_SIZE = 6
)
(
    clk, rst,
    en, load,
    itt,
    rnd
);
    input wire clk, rst;
    input wire en, load;
    input wire [ITT_SIZE-1:0] itt;

    output wire [1:0] rnd;

    wire fb;
    wire [ITT_SIZE-1:0] x_reg_out;

    assign rnd = x_reg_out[1:0];

    register #(
        .INP_SIZE(ITT_SIZE)
    ) x_reg (
        .clk(clk), .clr(rst),
         .inp1(itt), 
         .inp2({x_reg_out[ITT_SIZE-2:0], fb}), 
         .inp3({ITT_SIZE{1'b0}}),
          .sel({en, load}),
           .out(x_reg_out));

    xorModule #(.INP_SIZE(1)) xor_inst_fb (.inp0(x_reg_out[1]), .inp1(x_reg_out[3]), .inp2(x_reg_out[5]), .out(fb));
    
endmodule