module memory 
#(
    parameter MEMORY_WIDTH = 34,
    parameter MEMORY_LENGTH = 128,
    parameter MEM_FILE = "input_memory.txt"
)
(
    clk,
    rst, 
    write,
    address,
    write_data,
    read_data
);

    localparam ADDRESS_WIDTH = $clog2(MEMORY_LENGTH);

    input wire clk;
    input wire rst; 
    input wire write;
    input wire [ADDRESS_WIDTH-1:0] address;
    input wire [MEMORY_WIDTH-1:0] write_data;
    output wire [MEMORY_WIDTH-1:0] read_data;

    reg [MEMORY_WIDTH-1:0] mem [0:MEMORY_LENGTH-1];

    initial begin
        $readmemh(MEM_FILE, mem);
    end

    assign read_data = mem[address];

    always @(posedge clk) begin
        if (write)
        begin
            mem[address] <= write_data;
        end
    end

endmodule
