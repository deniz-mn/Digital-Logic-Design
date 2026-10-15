module rndTop 
#(
    parameter ITT_SIZE = 6
)
(
    clk, rst,
    start,
    itt,
    rnd,
    done
);
    input wire clk, rst;
    input wire start;
    input wire [ITT_SIZE-1:0] itt;
    output wire [1:0] rnd;
    output wire done;

    wire en, load;

    rndFsm rndFsm_inst
    (
        .clk(clk),
        .rst(rst),
        .start(start),
        .en(en),
        .load(load),
        .done(done) 
    );

    rndDatapath 
    #(
        .ITT_SIZE(ITT_SIZE)
    ) rndDatapath_inst (
        .clk(clk),
        .rst(rst),
        .en(en),
        .load(load),
        .itt(itt),
        .rnd(rnd)
    );
endmodule
