module Forwarding_unit(rs1_IDEX, rs2_IDEX, rd_EXMEM, rd_MEMWB, RegWrite_EXMEM, RegWrite_MEMWB, ForwardA, ForwardB);

input [4:0] rs1_IDEX, rs2_IDEX, rd_EXMEM, rd_MEMWB;
input [0:0] RegWrite_EXMEM, RegWrite_MEMWB;
output reg [0:1] ForwardA, ForwardB;

always @ ( * ) begin
    {ForwardA, ForwardB} <= 0;

    if (RegWrite_EXMEM && rd_EXMEM != 0 && rd_EXMEM == rs1_IDEX) ForwardA <= 2'b10;
    else if (RegWrite_MEMWB && rd_MEMWB != 0 && rd_MEMWB == rs1_IDEX) ForwardA <= 2'b01;

    if (RegWrite_EXMEM && rd_EXMEM != 0 && rd_EXMEM == rs2_IDEX) ForwardB <= 2'b10;
    else if (RegWrite_MEMWB && rd_MEMWB != 0 && rd_MEMWB == rs2_IDEX) ForwardB <= 2'b01;
end

endmodule
