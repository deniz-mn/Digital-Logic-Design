module FGenerator(
    it,
    A,
    B,
    C,
    D,
    F
);
    input wire [5:0] it;
    input wire [7:0] A, B, C, D;
    output wire [7:0] F;

    assign F = ((it <= 15) ? ((B & C) | ((~B) & D)) :
                (it <= 31) ? ((D & B) | ((~D) & C)) :
                (it <= 47) ? (B ^ C ^ D) :
                (it <= 63) ? (C ^ (B | (~D))) : 8'd0);
endmodule

