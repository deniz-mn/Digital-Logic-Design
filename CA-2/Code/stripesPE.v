module stripesPE
#(
    parameter NUM_O_B_BITS = 16 ,
    parameter NUM_O_A_BITS = 4 ,
    parameter NUM_OF_ROWS = 4
)
(
    rst,clk,
    reset_vals,
    i_vec_b , i_vec_a,
    i_is_msb , i_is_lsb , i_is_valid ,
    initial_sum,
    o_dot_product   
);

    localparam  OUTPUT_SIZE = NUM_O_A_BITS + NUM_O_B_BITS + $clog2(NUM_OF_ROWS);

    input wire [NUM_O_B_BITS * NUM_OF_ROWS-1 : 0] i_vec_b ;
    input wire [NUM_OF_ROWS-1 : 0] i_vec_a ;
    input wire i_is_msb , i_is_lsb , i_is_valid , reset_vals;
    input wire [ OUTPUT_SIZE-1 : 0] initial_sum ;
    input rst , clk ;
    output wire [ OUTPUT_SIZE-1 : 0] o_dot_product ;

    wire [NUM_OF_ROWS*OUTPUT_SIZE - 1 :0] adder_1_input; 
    wire [(OUTPUT_SIZE + OUTPUT_SIZE) - 1 :0] adder_2_input , adder_3_input;
    wire [OUTPUT_SIZE - 1 :0] adder_1_out , adder_2_out , adder_3_out , accumulator_out;
     

    
    genvar g;
    generate
        for (g = 0; g < NUM_OF_ROWS; g = g + 1) begin : gen_m1
        wire [NUM_O_B_BITS-1:0] out;

        selectorM1 #(
            .INPUT_SIZE(NUM_O_B_BITS)
        ) ins_m (
            .i_is_msb (i_is_msb),
            .inp_num (i_vec_b[g*NUM_O_B_BITS +: NUM_O_B_BITS]),
            .inp_bit  (i_vec_a[g]),
            .out      (out)
        );

        assign adder_1_input[g*OUTPUT_SIZE +: OUTPUT_SIZE] =
               {{(OUTPUT_SIZE-NUM_O_B_BITS){out[NUM_O_B_BITS-1]}}, out};
    end
    endgenerate


    adder#(
        .NUM_OF_INPUTS(NUM_OF_ROWS),
        .INPUT_SIZE (OUTPUT_SIZE)
    )ins_adder_1(
        .inp(adder_1_input),
        .sum(adder_1_out)
    );

    assign  adder_2_input = {accumulator_out , adder_1_out }; 

    adder#(
        .NUM_OF_INPUTS(2),
        .INPUT_SIZE (OUTPUT_SIZE)
    ) ins_adder_2 (
        .inp(adder_2_input),
        .sum(adder_2_out)
    );


    accumulator#(
        .INPUT_SIZE(OUTPUT_SIZE)
    ) ins_accumulator(
        .clk(clk), 
        .rst(rst), 
        .reset_values(reset_vals),
        .en(i_is_valid),
        .inp(adder_2_out),
        .out(accumulator_out)
    );


    assign  adder_3_input = { initial_sum , accumulator_out };

    adder#(
        .NUM_OF_INPUTS(2),
        .INPUT_SIZE (OUTPUT_SIZE)
    )ins_adder_3(
        .inp(adder_3_input),
        .sum(adder_3_out)
    );


    assign o_dot_product = i_is_lsb? adder_3_out: accumulator_out;



endmodule