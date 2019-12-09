`define CYCLE_TIME 50

module TestBench;

reg                Clk;
reg                Start;
reg                Reset;
integer            i, outfile, counter;
integer            stall, flush;

always #(`CYCLE_TIME/2) Clk = ~Clk;

CPU CPU(
    .clk_i  (Clk),
    .rst_i  (Reset),
    .start_i(Start)
);

initial begin
    //$dumpfile("ans.vcd");
    //$dumpvars;
    counter = 0;
    stall = 0;
    flush = 0;

    // initialize instruction memory
    for(i=0; i<256; i=i+1) begin
        CPU.Instruction_Memory.memory[i] = 32'b0;
    end

    // initialize data memory
    for(i=0; i<32; i=i+1) begin
        CPU.Data_Memory.memory[i] = 8'b0;
    end

    // initialize Register File
    for(i=0; i<32; i=i+1) begin
        CPU.Registers.register[i] = 32'b0;
    end

    // TODO: initialize pipeline registers

    // Load instructions into instruction memory
    $readmemb("../testdata/Fibonacci_instruction.txt", CPU.Instruction_Memory.memory);

    // Open output file
    outfile = $fopen("../testdata/Fibonacci_output.txt") | 1;

    // Set Input n into data memory at 0x00
    CPU.Data_Memory.memory[0] = 8'h5;       // n = 5 for example

    Clk = 0;
    Reset = 0;
    Start = 0;

    #(`CYCLE_TIME/4)
    Reset = 1;
    Start = 1;


end

always@(posedge Clk) begin
    // TODO: change # of cycles as you need
    if(counter == 64)    // stop after 30 cycles
        $finish;

    // TODO: put in your own signal to count stall and flush
     if(CPU.HD.IFIDStall_o == 1'b1 && CPU.HD.isBranch == 1'b0)stall = stall + 1;
     if(CPU.HD.IFIDFlush_o == 1'b1)flush = flush + 1;


    // print PC
    $fdisplay(outfile, "cycle = %d, Start = %0d, Stall = %0d, Flush = %0d\nPC = %d", counter, Start, stall, flush, CPU.PC.pc_o);

    //$fdisplay(outfile, "nxt_PC1 = %d, branch_PC = %d, nxt_PC = %d, PC_select = %d, PCWrite = %d\n",CPU.nxt_PC1,CPU.branch_PC,CPU.nxt_PC,CPU.PC_select,CPU.PCWrite);
    //$fdisplay(outfile, "instruction = %d, ID-instruction = %d\n",CPU.instr,CPU.ID_instr);
    //$fdisplay(outfile, "rs1 = %d, rs2 = %d, rd = %d\n",CPU.IDrs1,CPU.IDrs2,CPU.IDrd);
    //$fdisplay(outfile, "IDIimm = %d, IDSimm = %d, IDBimm = %d, IDimm_val = %d\n",CPU.IDIimm,CPU.IDSimm,CPU.IDBimm,CPU.IDimm_val);
    //$fdisplay(outfile, "ID_EQ = %d, isBranch = %d, HDstall = %d, HDflush = %d\n",CPU.ID_EQ,CPU.HD.isBranch,CPU.HDstall,CPU.HDflush);
    //$fdisplay(outfile, "RS1data = %d, RS2data = %d, ALUSrc = %d\n",CPU.IDrs1_data,CPU.IDrs2_data,CPU.ALUSrc);
    //$fdisplay(outfile, "val1 = %d, val2 = %d, res = %d, rs2 = %d\n",CPU.Src1,CPU.Src2,CPU.ALUans,CPU.EX_rs2_data);
    //$fdisplay(outfile, "IFflush = %d, IFstall = %d, ID_EQ = %d\n",CPU.IFflush,CPU.IFstall,CPU.ID_EQ);
    //$fdisplay(outfile, "MuxIn = %d, EXnop = %d, MuxOut = %d\n",CPU.MuxIn,CPU.EXnop,CPU.MuxOut);
    //$fdisplay(outfile, "WBWB = %d, WBrd = %d, WBdata = %d, WB_ALUres = %d\n",CPU.IDWB,CPU.WBrd,CPU.WBdata,CPU.WB_ALUres);
    //$fdisplay(outfile, "Mem = %d, MEM_WBSrc = %d\n",CPU.Mem,CPU.MEM_WBSrc);
    //$fdisplay(outfile, "IDrd = %d, EXrd = %d, MEMrd = %d, WBrd = %d\n",CPU.IDrd,CPU.EXrd,CPU.MEMrd,CPU.WBrd);
    //$fdisplay(outfile, "EXval1 = %d, MemForward1 = %d, ALUForward1 = %d, select1 = %d, select2 = %d\n",CPU.EXval1,CPU.MemForward1,CPU.ALUForward1,CPU.select1,CPU.select2);

    // print Registers
    $fdisplay(outfile, "Registers");
    $fdisplay(outfile, "x0 = %d, x8  = %d, x16 = %d, x24 = %d", CPU.Registers.register[0], CPU.Registers.register[8] , CPU.Registers.register[16], CPU.Registers.register[24]);
    $fdisplay(outfile, "x1 = %d, x9  = %d, x17 = %d, x25 = %d", CPU.Registers.register[1], CPU.Registers.register[9] , CPU.Registers.register[17], CPU.Registers.register[25]);
    $fdisplay(outfile, "x2 = %d, x10 = %d, x18 = %d, x26 = %d", CPU.Registers.register[2], CPU.Registers.register[10], CPU.Registers.register[18], CPU.Registers.register[26]);
    $fdisplay(outfile, "x3 = %d, x11 = %d, x19 = %d, x27 = %d", CPU.Registers.register[3], CPU.Registers.register[11], CPU.Registers.register[19], CPU.Registers.register[27]);
    $fdisplay(outfile, "x4 = %d, x12 = %d, x20 = %d, x28 = %d", CPU.Registers.register[4], CPU.Registers.register[12], CPU.Registers.register[20], CPU.Registers.register[28]);
    $fdisplay(outfile, "x5 = %d, x13 = %d, x21 = %d, x29 = %d", CPU.Registers.register[5], CPU.Registers.register[13], CPU.Registers.register[21], CPU.Registers.register[29]);
    $fdisplay(outfile, "x6 = %d, x14 = %d, x22 = %d, x30 = %d", CPU.Registers.register[6], CPU.Registers.register[14], CPU.Registers.register[22], CPU.Registers.register[30]);
    $fdisplay(outfile, "x7 = %d, x15 = %d, x23 = %d, x31 = %d", CPU.Registers.register[7], CPU.Registers.register[15], CPU.Registers.register[23], CPU.Registers.register[31]);

    // print Data Memory
    $fdisplay(outfile, "Data Memory: 0x00 = %10d", {CPU.Data_Memory.memory[3] , CPU.Data_Memory.memory[2] , CPU.Data_Memory.memory[1] , CPU.Data_Memory.memory[0] });
    $fdisplay(outfile, "Data Memory: 0x04 = %10d", {CPU.Data_Memory.memory[7] , CPU.Data_Memory.memory[6] , CPU.Data_Memory.memory[5] , CPU.Data_Memory.memory[4] });
    $fdisplay(outfile, "Data Memory: 0x08 = %10d", {CPU.Data_Memory.memory[11], CPU.Data_Memory.memory[10], CPU.Data_Memory.memory[9] , CPU.Data_Memory.memory[8] });
    $fdisplay(outfile, "Data Memory: 0x0c = %10d", {CPU.Data_Memory.memory[15], CPU.Data_Memory.memory[14], CPU.Data_Memory.memory[13], CPU.Data_Memory.memory[12]});
    $fdisplay(outfile, "Data Memory: 0x10 = %10d", {CPU.Data_Memory.memory[19], CPU.Data_Memory.memory[18], CPU.Data_Memory.memory[17], CPU.Data_Memory.memory[16]});
    $fdisplay(outfile, "Data Memory: 0x14 = %10d", {CPU.Data_Memory.memory[23], CPU.Data_Memory.memory[22], CPU.Data_Memory.memory[21], CPU.Data_Memory.memory[20]});
    $fdisplay(outfile, "Data Memory: 0x18 = %10d", {CPU.Data_Memory.memory[27], CPU.Data_Memory.memory[26], CPU.Data_Memory.memory[25], CPU.Data_Memory.memory[24]});
    $fdisplay(outfile, "Data Memory: 0x1c = %10d", {CPU.Data_Memory.memory[31], CPU.Data_Memory.memory[30], CPU.Data_Memory.memory[29], CPU.Data_Memory.memory[28]});

    $fdisplay(outfile, "\n");

    counter = counter + 1;


end


endmodule
