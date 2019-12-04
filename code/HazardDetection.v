module HazardDetection (MemRead_IDEX, rd_IDEX, rs1_IFID, rs2_IFID, ID_equal, isBranch, PCWrite_o, IFIDStall_o, IFIDFlush_o, Mux_o);

input [0:0] MemRead_IDEX, ID_equal, isBranch;
input [4:0] rd_IDEX, rs1_IFID, rs2_IFID;
output reg [0:0] PCWrite_o, IFIDStall_o, IFIDFlush_o;
output reg [1:0] Mux_o;

always @ ( * ) begin
    {IFIDStall_o, IFIDFlush_o, Mux_o} <= 0;
    PCWrite_o = 1'b1;

    if (MemRead_IDEX && (rd_IDEX == rs1_IFID || rd_IDEX == rs2_IFID)) begin // stall
        PCWrite_o <= 1'b0;
        IFIDStall_o <= 1'b1;
        IFIDFlush_o <= 1'b0;
        Mux_o <= 1'b0;
    end

    if (ID_equal && isBranch) begin // flush
        PCWrite_o <= 1'b1;
        IFIDStall_o <= 1'b0;
        IFIDFlush_o <= 1'b1;
        Mux_o <= 1'b1;
    end
end

endmodule //HazardDetection
