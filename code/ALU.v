module ALU(data1_i,data2_i,ALUCtrl_i,data_o);
    input [31:0] data1_i,data2_i;
    input [3:0] ALUCtrl_i;
    output [31:0] data_o;
    reg [31:0] tmp;
    assign data_o = tmp;
    always @(*) begin
        case (ALUCtrl_i)
            4'b0010: tmp = data1_i + data2_i;
            4'b0110: tmp = data1_i - data2_i;
            4'b0000: tmp = data1_i & data2_i;
            4'b0001: tmp = data1_i | data2_i;
            4'b1111: tmp = data1_i * data2_i;
        endcase
    end
endmodule
