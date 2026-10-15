module top
#(
    parameter INP_SIZE = 8,
    parameter ITT_SIZE = 6
)
(
    clk, rst,
    start,
    message,
    digest,
    done
);
    localparam MESSAGE_LENGTH = 4*INP_SIZE;
    localparam NUM_ITERATIONS = 64;

    input wire clk, rst;
    input wire start;
    input wire [MESSAGE_LENGTH-1:0] message;

    output wire [MESSAGE_LENGTH-1:0] digest;
    output wire done;
    wire [INP_SIZE-1:0] A0, B0, C0, D0;
    
    wire [INP_SIZE-1:0] const;
    wire [ITT_SIZE-1:0] itt;

    wire en_reg;
    wire load_init;
    wire start_rnd;
    wire rnd_done;
    wire en_F_multiplier;
    wire load_F_multiplier;
    wire F_multiplier_done;
    wire load_itt;
    wire en_itt;
    wire itt_done;
    wire [1:0] rnd;

    assign A0 = 8'h01;
    assign B0 = 8'h89;
    assign C0 = 8'hfe;
    assign D0 = 8'h76;
    
    reg [INP_SIZE-1:0] constants_mem [0:NUM_ITERATIONS-1];

    
    assign const = constants_mem[itt];

    initial  begin
        $readmemh("k.mem", constants_mem);
    end

    fsm fsm_inst (
        .clk(clk),
        .rst(rst),  
        .en_reg(en_reg),
        .load_init(load_init),
        .start_rnd(start_rnd),
        .start(start),
        .rnd_done(rnd_done),
        .en_F_multiplier(en_F_multiplier),
        .load_F_multiplier(load_F_multiplier),
        .F_multiplier_done(F_multiplier_done),
        .load_itt(load_itt),
        .en_itt(en_itt),
        .itt_done(itt_done),
        .done(done)
    );

    datapath #(
        .INP_SIZE(INP_SIZE),
        .ITT_SIZE(ITT_SIZE)
    ) datapath_inst (
        .clk(clk),
        .rst(rst),
        .en_reg(en_reg),
        .load_init(load_init),
        .message(message),
        .A0(A0), .B0(B0), .C0(C0), .D0(D0),
        .const(const),
        .itt(itt),
        .rnd(rnd),
        .digest(digest),
        .start_rnd(start_rnd),
        .rnd_done(rnd_done),
        .en_F_multiplier(en_F_multiplier),
        .load_F_multiplier(load_F_multiplier),
        .F_multiplier_done(F_multiplier_done),
        .load_itt(load_itt), 
        .en_itt(en_itt),
        .itt_done(itt_done)
    );

endmodule