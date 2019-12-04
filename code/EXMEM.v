module EXMEM(clk_i, WB_i,Mem_i,ALUres_i,imm_i,rs1_data_i,rs2_data_i,rd_addr_i,Memaddr_o,Memdata_o,WB_o,Mem_o,rd_addr_o,ALUres_o);
    input [31:0] ALUres_i,imm_i,rs1_data_i,rs2_data_i;
    input [4:0] rd_addr_i;
    input [1:0] Mem_i;
    input WB_i, clk_i;
    output reg [31:0] Memaddr_o,Memdata_o,ALUres_o;
    output reg [4:0] rd_addr_o;
    output reg [1:0] Mem_o;
    output reg WB_o;

    always @ ( posedge clk_i ) begin
        WB_o <= WB_i;
        Mem_o <= Mem_i;
        rd_addr_o <= rd_addr_i;
        Memdata_o <= rs2_data_i;
        ALUres_o <= ALUres_i;
        Memaddr_o <= (Mem_i == 2'b01 ? rs1_data_i + rs2_data_i : rs1_data_i + imm_i);
    end

endmodule
