module MEMWB(clk_i,WB_i,MemRdata_i,ALUres_i,rd_addr_i,WBSrc_i,WB_o,MemRdata_o,ALUres_o,rd_addr_o,WBSrc_o);
    input [31:0] MemRdata_i,ALUres_i;
    input [4:0] rd_addr_i;
    input WB_i,WBSrc_i,clk_i;
    output [31:0] MemRdata_o,ALUres_o;
    output [4:0] rd_addr_o;
    output WB_o,WBSrc_o;

    reg [31:0] tmp_MemRdata_o,tmp_ALUres_o;
    reg [4:0] tmp_rd_addr_o;
    reg tmp_WB_o,tmp_WBSrc_o;

    assign WB_o = tmp_WB_o;
    assign MemRdata_o = MemRdata_i;
    assign ALUres_o = ALUres_i;
    assign rd_addr_o = rd_addr_i;
    assign WBSrc_o = tmp_WBSrc_o;

    always @ ( posedge clk_i ) begin
        tmp_WB_o = WB_i;
        //tmp_MemRdata_o = MemRdata_i;
        //ALUres_o = ALUres_i;
        //rd_addr_o = rd_addr_i;
        tmp_WBSrc_o = WBSrc_i;
    end


endmodule
