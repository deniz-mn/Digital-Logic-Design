module selectorM1 
#(
    parameter INPUT_SIZE = 16
)
(
    i_is_msb, 
    inp_num,
    inp_bit,
    out
);
    input wire i_is_msb;
    input wire [INPUT_SIZE-1:0] inp_num;
    input wire inp_bit;
    output wire [INPUT_SIZE-1:0] out;
    
    assign out = inp_bit? (i_is_msb?  -inp_num: inp_num) : {INPUT_SIZE{1'b0}};
   
endmodule