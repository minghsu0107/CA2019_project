module EXMEM(clk_i,WB_i,Mem_i,ALUres_i,imm_i,rs1_data_i,rs2_data_i,rd_addr_i,Memaddr_o,Memdata_o,WB_o,Mem_o,rd_addr_o,ALUres_o);
    input [31:0] ALUres_i,imm_i,rs1_data_i,rs2_data_i;
    input [4:0] rd_addr_i;
    input [1:0] Mem_i;
    input WB_i,clk_i;
    output [31:0] Memaddr_o,Memdata_o,ALUres_o;
    output [4:0] rd_addr_o;
    output [1:0] Mem_o;
    output WB_o;

    reg [31:0] tmp_Memaddr_o,tmp_Memdata_o,tmp_ALUres_o;
    reg [4:0] tmp_rd_addr_o;
    reg [1:0] tmp_Mem_o;
    reg tmp_WB_o;

    assign WB_o = tmp_WB_o;
    assign Mem_o = tmp_Mem_o;
    assign rd_addr_o = tmp_rd_addr_o;
    assign Memdata_o = tmp_Memdata_o;
    assign ALUres_o = tmp_ALUres_o;
    assign Memaddr_o = tmp_Memaddr_o;

    always @ ( posedge clk_i ) begin
        tmp_WB_o <= WB_i;
        tmp_Mem_o <= Mem_i;
        tmp_rd_addr_o <= rd_addr_i;
        tmp_Memdata_o <= rs2_data_i;
        tmp_ALUres_o <= ALUres_i;
        tmp_Memaddr_o <= (Mem_i == 2'b01 ? rs1_data_i + rs2_data_i : rs1_data_i + imm_i);
    end
    
endmodule
