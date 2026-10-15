module multiplier
#(
    parameter INP_SIZE = 8 
)
(
    clr, clk, inp, en, load, 
    out,
    done
);


    input wire [INP_SIZE -1 : 0] inp;
    input wire clk, clr, en, load;
    output wire [INP_SIZE -1 : 0] out;
    output wire done;

    wire done_inv;

    wire [INP_SIZE/2-1:0] a = inp[INP_SIZE/2-1:0];
    wire [INP_SIZE/2-1:0] b = inp[INP_SIZE-1:INP_SIZE/2];


    wire [INP_SIZE -1 : 0] out_bit_multiplier ;
    wire [INP_SIZE -1 : 0] out_adder ;
    wire [INP_SIZE -1 : 0] out_shift_left ;
    wire [1 : 0] out_counter ;


    wire bit_b;
    wire [1:0]sel_reg = {load, en};
    wire [INP_SIZE/4-1:0] minus_one = -1;
    

    counter #(
        .INP_SIZE(2) 
    )
    counter_inst(   
        .clk(clk), 
        .clr(clr), 
        .en(en), 
        .load(load),
        .step(minus_one), 
        .inp(2'b11),
        .out(out_counter)
    );


    bitI #(
        .INP_SIZE(INP_SIZE/2) 
    )
    bitI_inst(
        .inp(b),
        .num(out_counter),
        .out(bit_b)
    );


    bitMultiplier #(
        .INP_SIZE(INP_SIZE/2),
        .OUT_SIZE(INP_SIZE)
    )
    bitMultiplier_inst(
        .a_inp(a), 
        .b_inp(bit_b),
        .final_out(out_bit_multiplier)
    );


    adder#(
        .INP_SIZE(INP_SIZE)
    )
    adder_inst(
        .inp0(out_bit_multiplier), 
        .inp1(out_shift_left),
        .out(out_adder)
    );


    register#(      
        .INP_SIZE(INP_SIZE) 
    )
    register_inst(   
        .clk(clk), 
        .clr(clr),
        .inp1(out_adder), 
        .inp2(8'b0), 
        .inp3(8'b0),
        .sel(sel_reg),
        .out(out)
    );


    assign out_shift_left = {out[INP_SIZE-2:0], 1'b0};            
    
    notModule done_inv_inst (done_inv, done);
    orModule done_inv_or_int (out_counter[1], out_counter[0], 1'b0, 1'b0, done_inv);

endmodule