module CPU
(
    clk_i,
    rst_i,
    start_i
);

// Ports
input         clk_i;
input         rst_i;
input         start_i;

wire [31:0] cur_PC,nxt_PC1,branch_PC,nxt_PC;
wire PCWrite,PC_select;

Adder Add_PC(
    .data1_i (cur_PC),
    .data2_i (13'b100),
    .data_o (nxt_PC1)
);

MUX PC_MUX(
    .data1_i (nxt_PC1),
    .data2_i (branch_PC),
    .select_i (1'b0),
    .data_o (nxt_PC)
);

PC PC(
    .clk_i          (clk_i),
    .start_i        (start_i),
    .rst_i          (rst_i),
    .PCWrite_i      (PCWrite),
    .pc_i           (nxt_PC),
    .pc_o           (cur_PC)
);

wire [31:0] instr;

Instruction_Memory Instruction_Memory(
    .addr_i         (cur_PC),
    .instr_o        (instr)
);

wire [4:0] RS1addr,RS2addr,RDaddr;
wire [31:0] RS1data,RS2data,RDdata;
wire RegWrite;

Registers Registers(
    .clk_i          (clk_i),
    .RS1addr_i      (RS1addr),
    .RS2addr_i      (RS2addr),
    .RDaddr_i       (RDaddr),
    .RDdata_i       (RDdata),
    .RegWrite_i     (RegWrite),
    .RS1data_o      (RS1data),
    .RS2data_o      (RS2data)
);

wire [31:0] DMaddr,DMRdata,DMWdata;
wire MemWrite;

Data_Memory Data_Memory(
    .clk_i          (clk_i),
    .addr_i         (DMaddr),
    .MemWrite_i     (MemWrite),
    .data_i         (DMWdata),
    .data_o         (DMRdata)
);

// ID stage

wire [31:0] ID_PC,ID_instr;
wire IFflush,IFstall;

IFID IFID(
    .clk (clk_i),
    .PC_i (cur_PC),
    .PC_o (ID_PC),
    .instr_i (instr),
    .instr_o (ID_instr),
    .IFflush (IFflush),
    .IFstall (IFstall)
);

wire [6:0] IDfunct7,IDopcode;
wire [4:0] IDrs1,IDrs2,IDrd;
wire [2:0] IDfunct3;
wire [11:0] IDIimm,IDSimm1;
wire [12:0] IDBimm;
wire [31:0] IDSimm;
assign IDfunct7 = ID_instr[31:25];
assign IDfunct3 = ID_instr[14:12];
assign IDopcode = ID_instr[6:0];
assign IDrs1 = ID_instr[19:15];
assign IDrs2 = ID_instr[24:20];
assign IDrd = ID_instr[11:7];
assign IDIimm = ID_instr[31:20];
assign IDSimm1[11:5] = ID_instr[31:25];
assign IDSimm1[4:0] = ID_instr[11:7];
assign {IDBimm[12],IDBimm[10:5]} = ID_instr[31:25];
assign {IDBimm[4:1],IDBimm[11]} = ID_instr[11:7];
assign IDBimm[0] = 1'b0;

assign RS1addr = IDrs1;
assign RS2addr = IDrs2;

wire [31:0] IDrs1_data,IDrs2_data,IDimm_val,ID_newPC;
wire ID_EQ;
assign IDrs1_data = RS1data;
assign IDrs2_data = RS2data;

EQUAL EQUAL(
    .data1_i (IDrs1_data),
    .data2_i (IDrs2_data),
    .data_o (ID_EQ)
);

assign PC_select = ID_EQ & IDopcode[6];

SignExtend SignExtendI(
    .data_i (IDIimm),
    .data_o (IDimm_val)
);

SignExtend SignExtendS(
    .data_i (IDSimm1),
    .data_o (IDSimm)
);

Adder Adder(
    .data1_i (ID_PC),
    .data2_i (IDBimm),
    .data_o (ID_newPC)
);

assign branch_PC = ID_newPC;

wire [1:0] ALUOp1,IDMem1,ALUOp,IDMem;
wire ALUSrc,IDWB1,IDWB;

Control Control(
    .opcode (IDopcode),
    .ALUOp (ALUOp1),
    .ALUSrc (ALUSrc),
    .Mem (IDMem1),
    .WB (IDWB1)
);

wire [4:0] MuxIn,MuxOut;
wire EXnop;
assign MuxIn = {ALUOp1,IDMem1,IDWB1};

CtrlMux CtrlMux(
    .data1_i (MuxIn),
    .data2_i (5'b00000),
    .select_i (EXnop),
    .data_o (MuxOut)
);

assign {ALUOp,IDMem,IDWB} = MuxOut;

// EX stage

wire [31:0] EXval1,EXval2,EXimm;
wire [3:0] ALUCtrl;
wire [4:0] EXrs1,EXrs2,EXrd;
wire [1:0] EXMem;
wire EXWB;

IDEX IDEX(
    .rs1_data (IDrs1_data),
    .rs2_data (IDrs2_data),
    .Iimm (IDimm_val),
    .Simm (IDSimm),
    .rs1_addr (IDrs1),
    .rs2_addr (IDrs2),
    .rd_addr (IDrd),
    .funct3 (IDfunct3),
    .funct7 (IDfunct7),
    .WB (IDWB),
    .Mem (IDMem),
    .ALUOp (ALUOp),
    .ALUSrc (ALUSrc),
    .val1 (EXval1),
    .val2 (EXval2),
    .ALUCtrl (ALUCtrl),
    .rs1_addr_o (EXrs1),
    .rs2_addr_o (EXrs2),
    .rd_addr_o (EXrd),
    .Simm_o (EXimm),
    .Mem_o (EXMem),
    .WB_o (EXWB)
);

wire [31:0] MemForward1,MemForward2,ALUForward1,ALUForward2,Src1,Src2;
wire [1:0] select1,select2;

ALU_MUX ALU_SRC1(
    .data1_i (EXval1),
    .data2_i (MemForward1),
    .data3_i (ALUForward1),
    .select_i (select1),
    .data_o (Src1)
);

ALU_MUX ALU_SRC2(
    .data1_i (EXval2),
    .data2_i (MemForward2),
    .data3_i (ALUForward2),
    .select_i (select2),
    .data_o (Src2)
);

wire [31:0] ALUans;

ALU ALU(
    .data1_i (Src1),
    .data2_i (Src2),
    .ALUCtrl_i (ALUCtrl),
    .data_o (ALUans)
);

// MEM stage

wire [31:0] Memaddr,Memdata,MEM_ALUres,MemRdata;
wire [4:0] MEMrd;
wire [1:0] Mem;
wire MEM_WB,MEM_WBSrc;

EXMEM EXMEM(
    .WB_i (EXWB),
    .Mem_i (EXMem),
    .ALUres_i (ALUans),
    .imm_i (EXimm),
    .rs1_data_i (EXval1),
    .rs2_data_i (EXval2),
    .rd_addr_i (EXrd),
    .Memaddr_o (Memaddr),
    .Memdata_o (Memdata),
    .WB_o (MEM_WB),
    .Mem_o (Mem),
    .rd_addr_o (MEMrd),
    .ALUres_o (MEM_ALUres)
);

assign DMaddr = Memaddr;
assign DMWdata = Memdata;
assign MemWrite = ( Mem == 2'b10 ? 1'b1 : 1'b0 );
assign MemRdata = DMRdata;
assign MEM_WBSrc = ( Mem == 2'b01 ? 1'b1 : 1'b0 );

// WB stage

wire [31:0] WB_Memdata,WB_ALUres;
wire [4:0] WBrd;
wire WBWB,WB_WBSrc;

MEMWB MEMWB(
    .WB_i (MEM_WB),
    .MemRdata_i (MemRdata),
    .ALUres_i (MEM_ALUres),
    .rd_addr_i (MEMrd),
    .WBSrc_i (MEM_WBSrc),
    .WB_o (WBWB),
    .MemRdata_o (WB_Memdata),
    .ALUres_o (WB_ALUres),
    .rd_addr_o (WBrd),
    .WBSrc_o (WB_WBSrc)
);

wire [31:0] WBdata;

MUX WB_MUX(
    .data1_i (WB_ALUres),
    .data2_i (WB_Memdata),
    .select_i (WB_WBSrc),
    .data_o (WBdata)
);

assign RDaddr = WBrd;
assign RDdata = WBdata;
assign RegWrite = WBWB;

wire [1:0] ForwardA,ForwardB;

Forwarding_unit FU(
    .rs1_IDEX (EXrs1),
    .rs2_IDEX (EXrs2),
    .rd_EXMEM (MEMrd),
    .rd_MEMWB (WBrd),
    .RegWrite_EXMEM (MEM_WB),
    .RegWrite_MEMWB (WBWB),
    .ForwardA (ForwardA),
    .ForwardB (ForwardB)
);

assign select1 = ForwardA;
assign select2 = ForwardB;

wire HD_PCWrite,HDstall,HDflush,HDMux;

HazardDetection HD(
    .MemRead_IDEX (EXMem[0]),
    .rd_IDEX (EXrd),
    .rs1_IFID (IDrs1),
    .rs2_IFID (IDrs2),
    .ID_equal (ID_EQ),
    .isBranch (IDopcode[6]),
    .PCWrite_o (HD_PCWrite),
    .IFIDStall_o (HDstall),
    .IFIDFlush_o (HDflush),
    .Mux_o (HDMux)
);

assign PCWrite = HD_PCWrite;
assign IFflush = HDflush;
assign IFstall = HDstall;
assign EXnop = IFflush | IFstall;

endmodule

