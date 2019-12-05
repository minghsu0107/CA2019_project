module HazardDetection (MemRead_IDEX, rd_IDEX, rs1_IFID, rs2_IFID, ID_equal, isBranch, PCWrite_o, IFIDStall_o, IFIDFlush_o, Mux_o);

input [0:0] MemRead_IDEX, ID_equal, isBranch;
input [4:0] rd_IDEX, rs1_IFID, rs2_IFID;
output [0:0] PCWrite_o, IFIDStall_o, IFIDFlush_o, Mux_o;

reg [0:0] tmp_PCWrite_o, tmp_IFIDStall_o, tmp_IFIDFlush_o, tmp_Mux_o;

assign PCWrite_o = tmp_PCWrite_o;
assign IFIDStall_o = tmp_IFIDStall_o;
assign IFIDFlush_o = tmp_IFIDFlush_o;
assign Mux_o = tmp_Mux_o;

always @ ( * ) begin
    {tmp_IFIDStall_o, tmp_IFIDFlush_o, tmp_Mux_o} <= 0;
    tmp_PCWrite_o <= 1'b1;

    if (MemRead_IDEX && rd_IDEX != 0 && (rd_IDEX == rs1_IFID || rd_IDEX == rs2_IFID)) begin // stall
        tmp_PCWrite_o <= 1'b0;
        tmp_IFIDStall_o <= 1'b1;
        tmp_IFIDFlush_o <= 1'b0;
        tmp_Mux_o <= 1'b0;
    end

    if (ID_equal && isBranch) begin // flush
        tmp_PCWrite_o <= 1'b1;
        tmp_IFIDStall_o <= 1'b0;
        tmp_IFIDFlush_o <= 1'b1;
        tmp_Mux_o <= 1'b1;
    end
end

endmodule //HazardDetection
