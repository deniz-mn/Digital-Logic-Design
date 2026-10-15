`timescale 1ns / 1ps
module tbTopModule;
reg clk, rst, start;
reg [31:0] i1;
reg [31:0] i2;
reg [31:0] i3;
reg [31:0] i4;
reg [31:0] i5;
reg [31:0] i6;
reg [31:0] i7;
wire [31:0] result;
wire done;

topModule dut (
.clk(clk), .rst(rst), .start(start),
.i1(i1), .i2(i2), .i3(i3), .i4(i4), .i5(i5), .i6(i6), .i7(i7),
.result(result), .done(done)
);

always #5 clk = ~clk;
wire [31:0] expected_2;
assign expected_2 = i1 * i2;
wire [31:0] expected_4;
assign expected_4 = expected_2 + i3;
wire [31:0] expected_6;
assign expected_6 = expected_4 * i4;
wire [31:0] expected_8;
assign expected_8 = expected_6 + i5;
wire [31:0] expected_10;
assign expected_10 = expected_8 * i6;
wire [31:0] expected_12;
assign expected_12 = expected_10 + i7;

initial begin
clk = 0; rst = 1; start = 0;
i1 = 0;
i2 = 0;
i3 = 0;
i4 = 0;
i5 = 0;
i6 = 0;
i7 = 0;
#20 rst = 0;
i1 = $urandom & 4'hF;
i2 = $urandom & 4'hF;
i3 = $urandom & 4'hF;
i4 = $urandom & 4'hF;
i5 = $urandom & 4'hF;
i6 = $urandom & 4'hF;
i7 = $urandom & 4'hF;
#10 start = 1;
#10 start = 0;
wait(done == 1);
#5;
$display("Time: %0t | Result: %0d | Expected: %0d", $time, result, expected_12);
if (result === expected_12) begin
$display("Test PASSED");
end else begin
$display("Test FAILED");
end

#20 $stop;
end
endmodule