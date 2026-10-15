module counter
#(
    parameter INP_SIZE = 8 
)
(
    clk, clr, en, load,
    step, inp,
    out
);

    input wire clk, clr, en, load;
    input wire[INP_SIZE-1:0] step, inp;
    output wire[INP_SIZE-1:0] out;

    wire [INP_SIZE-1:0] out_adder;
    wire [1:0]sel_reg =  {load, en};

    adder #(
        .INP_SIZE(INP_SIZE) 
    )
    counter_adder(
        .inp0(out),        
        .inp1(step),  
        .out(out_adder) 
    );

    register #(
        .INP_SIZE(INP_SIZE)
    )
    counter_register  (
        .clk(clk),          
        .clr(clr),          
        .inp1(out_adder),  
        .inp2(inp),           
        .inp3({{INP_SIZE}{1'b0}}),          
        .sel(sel_reg),      
        .out(out) 
    );


    
endmodule