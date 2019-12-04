module MEMWB(clk_i,WB_i,MemRdata_i,ALUres_i,rd_addr_i,WBSrc_i,WB_o,MemRdata_o,ALUres_o,rd_addr_o,WBSrc_o);
    input [31:0] MemRdata_i,ALUres_i;
    input [4:0] rd_addr_i;
    input WB_i,WBSrc_i,clk_i;
    output reg [31:0] MemRdata_o,ALUres_o;
    output reg [4:0] rd_addr_o;
    output reg WB_o,WBSrc_o;

    always @ ( posedge clk_i ) begin
        WB_o <= WB_i;
        MemRdata_o <= MemRdata_i;
        ALUres_o <= ALUres_i;
        rd_addr_o <= rd_addr_i;
        WBSrc_o <= WBSrc_i;
    end

endmodule
