module MEMWB(WB_i,MemRdata_i,ALUres_i,rd_addr_i,WBSrc_i,WB_o,MemRdata_o,ALUres_o,rd_addr_o,WBSrc_o);
    input [31:0] MemRdata_i,ALUres_i;
    input [4:0] rd_addr_i;
    input WB_i,WBSrc_i;
    output [31:0] MemRdata_o,ALUres_o;
    output [4:0] rd_addr_o;
    output WB_o,WBSrc_o;
    assign WB_o = WB_i;
    assign MemRdata_o = MemRdata_i;
    assign ALUres_o = ALUres_i;
    assign rd_addr_o = rd_addr_i;
endmodule
