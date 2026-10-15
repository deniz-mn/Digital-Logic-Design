module constModule(
    it,
    const_out
);
    input wire [5:0] it;
    output reg [7:0] const_out;

    always @(*) begin
        case(it)
            6'd0:  const_out = 8'h78;
            6'd1:  const_out = 8'h56;
            6'd2:  const_out = 8'hdb;
            6'd3:  const_out = 8'hee;
            6'd4:  const_out = 8'haf;
            6'd5:  const_out = 8'h2a;
            6'd6:  const_out = 8'h13;
            6'd7:  const_out = 8'h01;
            6'd8:  const_out = 8'hd8;
            6'd9:  const_out = 8'haf;
            6'd10: const_out = 8'hb1;
            6'd11: const_out = 8'hbe;
            6'd12: const_out = 8'h22;
            6'd13: const_out = 8'h93;
            6'd14: const_out = 8'h8e;
            6'd15: const_out = 8'h21;
            6'd16: const_out = 8'h62;
            6'd17: const_out = 8'h40;
            6'd18: const_out = 8'h51;
            6'd19: const_out = 8'haa;
            6'd20: const_out = 8'h5d;
            6'd21: const_out = 8'h53;
            6'd22: const_out = 8'h81;
            6'd23: const_out = 8'hc8;
            6'd24: const_out = 8'he6;
            6'd25: const_out = 8'hd6;
            6'd26: const_out = 8'h87;
            6'd27: const_out = 8'hed;
            6'd28: const_out = 8'h05;
            6'd29: const_out = 8'hf8;
            6'd30: const_out = 8'hd9;
            6'd31: const_out = 8'h8a;
            6'd32: const_out = 8'h42;
            6'd33: const_out = 8'h81;
            6'd34: const_out = 8'h22;
            6'd35: const_out = 8'h0c;
            6'd36: const_out = 8'h44;
            6'd37: const_out = 8'ha9;
            6'd38: const_out = 8'h60;
            6'd39: const_out = 8'h70;
            6'd40: const_out = 8'hc6;
            6'd41: const_out = 8'hfa;
            6'd42: const_out = 8'h85;
            6'd43: const_out = 8'h05;
            6'd44: const_out = 8'h39;
            6'd45: const_out = 8'he5;
            6'd46: const_out = 8'hf8;
            6'd47: const_out = 8'h65;
            6'd48: const_out = 8'h44;
            6'd49: const_out = 8'h97;
            6'd50: const_out = 8'ha7;
            6'd51: const_out = 8'h39;
            6'd52: const_out = 8'hc3;
            6'd53: const_out = 8'h92;
            6'd54: const_out = 8'h7d;
            6'd55: const_out = 8'hd1;
            6'd56: const_out = 8'h4f;
            6'd57: const_out = 8'he0;
            6'd58: const_out = 8'h14;
            6'd59: const_out = 8'ha1;
            6'd60: const_out = 8'h82;
            6'd61: const_out = 8'h35;
            6'd62: const_out = 8'hbb;
            6'd63: const_out = 8'h91;
            default: const_out = 8'h00;
        endcase
    end
endmodule