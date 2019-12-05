module IFID ( clk , PC_i , PC_o , instr_i , instr_o , IFflush , IFstall );
    input [31:0] PC_i,instr_i;
    input clk,IFflush,IFstall;
    output [31:0] PC_o,instr_o;
    reg [31:0] instr,PC;

    initial begin
        {instr,PC} <= 0;
    end

    assign instr_o = instr;
    assign PC_o = PC;
    always @ (posedge clk) begin
        if (!IFstall) begin
            if (IFflush) begin
                instr <= 32'b0;
                PC <= 32'b0;
            end
            else begin
                instr <= instr_i;
                PC <= PC_i;
            end
        end
    end
endmodule
