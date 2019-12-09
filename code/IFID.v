module IFID (clk,PC_i,PC_o,instr_i,instr_o,IFflush,IFstall);
    input [31:0] PC_i,instr_i;
    input clk,IFflush,IFstall;
    output reg [31:0] PC_o,instr_o;

    initial begin
        {PC_o,instr_o} <= 0;
    end

    always @ (posedge clk) begin
        if (!IFstall) begin
            if (IFflush) begin
                instr_o <= 32'b0;
                PC_o <= 32'b0;
            end
            else begin
                instr_o <= instr_i;
                PC_o <= PC_i;
            end
        end
    end

endmodule
