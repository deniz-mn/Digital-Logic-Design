`timescale 1ns / 1ns

module tbCalF;

    localparam INP_SIZE = 8;
    localparam ITT_SIZE = 6;

    reg [ITT_SIZE-1:0] tb_itt;
    reg [INP_SIZE-1:0] tb_B, tb_C, tb_D;
    
    wire [INP_SIZE-1:0] tb_F;
    reg [INP_SIZE-1:0] expected_F;

    calF #(
        .INP_SIZE(INP_SIZE),
        .ITT_SIZE(ITT_SIZE)
    ) uut (
        .itt(tb_itt),
        .B(tb_B), .C(tb_C), .D(tb_D),
        .F(tb_F)
    );

    always @(*) begin
        if (tb_itt >= 0 && tb_itt <= 15)
            expected_F = (tb_B & tb_C) | (~tb_B & tb_D);
        else if (tb_itt >= 16 && tb_itt <= 31)
            expected_F = (tb_D & tb_B) | (~tb_D & tb_C);
        else if (tb_itt >= 32 && tb_itt <= 47)
            expected_F = tb_B ^ tb_C ^ tb_D;
        else
            expected_F = tb_C ^ (tb_B | ~tb_D);
    end

    initial begin
        tb_B = 0; tb_C = 0; tb_D = 0; tb_itt = 0;
        
        #10;
        
        tb_itt = 6'd5; 
        tb_B = 8'b11110000;
        tb_C = 8'b10101010;
        tb_D = 8'b00111100;
        #10;
        $display("i=%d | B=%h C=%h D=%h | F=%h | Exp=%h", 
                  tb_itt, tb_B, tb_C, tb_D, tb_F, expected_F);

        tb_itt = 6'd20; 
        tb_B = 8'hAA;
        tb_C = 8'h55;
        tb_D = 8'hF0;
        #10;
        $display("i=%d | B=%h C=%h D=%h | F=%h | Exp=%h", 
                  tb_itt, tb_B, tb_C, tb_D, tb_F, expected_F);

        tb_itt = 6'd40; 
        tb_B = 8'hFF;
        tb_C = 8'h00;
        tb_D = 8'hAA;
        #10;
        $display("i=%d | B=%h C=%h D=%h | F=%h | Exp=%h", 
                  tb_itt, tb_B, tb_C, tb_D, tb_F, expected_F);

        tb_itt = 6'd60; 
        tb_B = 8'h0F;
        tb_C = 8'hF0;
        tb_D = 8'hCC;
        #10;
        $display("i=%d | B=%h C=%h D=%h | F=%h | Exp=%h", 
                  tb_itt, tb_B, tb_C, tb_D, tb_F, expected_F);

        #10;
        $stop;
    end

endmodule