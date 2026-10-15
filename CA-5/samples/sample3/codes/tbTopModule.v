`timescale 1ns / 1ps
module tbTopModule;
reg clk, rst, start;
reg [31:0] i1;
reg [31:0] i2;
wire [31:0] result;
wire done;

topModule dut (
.clk(clk), .rst(rst), .start(start),
.i1(i1), .i2(i2),
.result(result), .done(done)
);

always #5 clk = ~clk;
wire [31:0] expected_2;
assign expected_2 = i1 * i2;
wire [31:0] expected_3;
assign expected_3 = i1 & i2;
wire [31:0] expected_4;
assign expected_4 = expected_2 + expected_3;
wire [31:0] expected_5;
assign expected_5 = i1 - i2;
wire [31:0] expected_6;
assign expected_6 = expected_4 + expected_5;
wire [31:0] expected_7;
assign expected_7 = i1 | i2;
wire [31:0] expected_8;
assign expected_8 = expected_6 + expected_7;

initial begin
clk = 0; rst = 1; start = 0;
i1 = 0;
i2 = 0;
#20 rst = 0;
i1 = $urandom & 4'hF;
i2 = $urandom & 4'hF;
#10 start = 1;
#10 start = 0;
wait(done == 1);
#5;
$display("Time: %0t | Result: %0d | Expected: %0d", $time, result, expected_8);
if (result === expected_8) begin
$display("Test PASSED");
end else begin
$display("Test FAILED");
end

#20 $stop;
end
endmodule