module IDEX(clk_i,rs1_data,rs2_data,Iimm,Simm,rs1_addr,rs2_addr,rd_addr,funct3,funct7,WB,Mem,ALUOp,ALUSrc,val1,val2,ALUCtrl,rs1_addr_o,rs2_addr_o,rd_addr_o,Simm_o,Mem_o,WB_o);
    input [31:0] rs1_data,rs2_data,Iimm,Simm;
    input [4:0] rs1_addr,rs2_addr,rd_addr;
    input [2:0] funct3;
    input [6:0] funct7;
    input [1:0] Mem,ALUOp;
    input WB,ALUSrc,clk_i;
    output [31:0] val1,val2,Simm_o;
    output [3:0] ALUCtrl;
    output [4:0] rs1_addr_o,rs2_addr_o,rd_addr_o;
    output [1:0] Mem_o;
    output WB_o;

    reg [3:0] tmp;
    reg [9:0] funct;
    
    reg [31:0] tmp_val1,tmp_val2,tmp_Simm_o;
    reg [3:0] tmp_ALUCtrl;
    reg [4:0] tmp_rs1_addr_o,tmp_rs2_addr_o,tmp_rd_addr_o;
    reg [1:0] tmp_Mem_o;
    reg tmp_WB_o;

    assign val1 = tmp_val1;
    assign val2 = tmp_val2;
    assign Simm_o = tmp_Simm_o;
    assign rs1_addr_o = tmp_rs1_addr_o;
    assign rs2_addr_o = tmp_rs2_addr_o;
    assign rd_addr_o = tmp_rd_addr_o;
    assign Mem_o = tmp_Mem_o;
    assign WB_o = tmp_WB_o;
    assign ALUCtrl = tmp_ALUCtrl;

    always @ ( posedge clk_i ) begin
        tmp_val1 = rs1_data;
        tmp_val2 = ( ALUSrc ? Iimm : rs2_data );
        tmp_Simm_o = Simm;
        tmp_rs1_addr_o = rs1_addr;
        tmp_rs2_addr_o = rs2_addr;
        tmp_rd_addr_o = rd_addr;
        tmp_Mem_o = Mem;
        tmp_WB_o = WB;
        tmp_ALUCtrl = tmp;
    end
    /*
    assign val1 = rs1_data;
    assign val2 = ( ALUSrc ? Iimm : rs2_data );
    assign Simm_o = Simm;
    assign rs1_addr_o = rs1_addr;
    assign rs2_addr_o = rs2_addr;
    assign rd_addr_o = rd_addr;
    assign Mem_o = Mem;
    assign WB_o = WB;
    assign ALUCtrl = tmp;
    */
    // control
    always @(*) begin
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
