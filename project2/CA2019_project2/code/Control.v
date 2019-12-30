module Control(opcode,ALUOp,ALUSrc,Mem,WB);
    input [6:0] opcode;
    output [1:0] ALUOp,Mem;
    output ALUSrc,WB;
    assign ALUSrc = ( opcode[5:4] == 2'b11 ? 1'b0 : 1'b1 );
    assign ALUOp = ( opcode[4] == 1'b1 ? 2'b10 : ( opcode[6] == 1'b0 ? 2'b00 : 2'b01 ) );
    assign WB = ( opcode[5:4] == 2'b10 ? 1'b0 : 1'b1 );
    assign Mem = ( opcode == 7'b0000011 ? 2'b01 : ( opcode == 7'b0100011 ? 2'b10 : 2'b00 ) );
endmodule
