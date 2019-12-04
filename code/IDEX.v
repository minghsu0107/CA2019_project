module IDEX(clk_i,rs1_data,rs2_data,Iimm,Simm,rs1_addr,rs2_addr,rd_addr,funct3,funct7,WB,Mem,ALUOp,ALUSrc,val1,val2,ALUCtrl,rs1_addr_o,rs2_addr_o,rd_addr_o,Simm_o,Mem_o,WB_o);
    input [31:0] rs1_data,rs2_data,Iimm,Simm;
    input [4:0] rs1_addr,rs2_addr,rd_addr;
    input [2:0] funct3;
    input [6:0] funct7;
    input [1:0] Mem,ALUOp;
    input WB,ALUSrc,clk_i;
    output reg [31:0] val1,val2,Simm_o;
    output reg [3:0] ALUCtrl;
    output reg [4:0] rs1_addr_o,rs2_addr_o,rd_addr_o;
    output reg [1:0] Mem_o;
    output reg WB_o;
    reg [3:0] tmp;
    reg [9:0] funct;

    always @ ( posedge clk_i ) begin
        val1 <= rs1_data;
        val2 <= ( ALUSrc ? Iimm : rs2_data );
        Simm_o <= Simm;
        rs1_addr_o <= rs1_addr;
        rs2_addr_o <= rs2_addr;
        rd_addr_o <= rd_addr;
        Mem_o <= Mem;
        WB_o <= WB;
        ALUCtrl <= tmp;

        funct = {funct7,funct3};
        if (ALUOp == 2'b00)
            tmp = 4'b0010;
        else if (ALUOp == 2'b01)
            tmp = 4'b0110;
        else
            case (funct)
                10'b0000000000: tmp = 4'b0010;
                10'b0100000000: tmp = 4'b0110;
                10'b0000000111: tmp = 4'b0000;
                10'b0000000110: tmp = 4'b0001;
                10'b0000001000: tmp = 4'b1111;
            endcase
    end

endmodule
