module adder
#(
    parameter NUM_OF_INPUTS = 2,
    parameter INPUT_SIZE = 34
)
(
    inp,
    sum
);
    input wire [INPUT_SIZE*NUM_OF_INPUTS-1:0] inp;
    output reg [INPUT_SIZE-1:0] sum;

    integer i;
    always @(*)
    begin
        sum = {INPUT_SIZE{1'b0}};

        for (i = 0; i < NUM_OF_INPUTS; i = i + 1)
        begin
            sum = sum + inp[(i*INPUT_SIZE) +: INPUT_SIZE];
        end
    end

endmodule