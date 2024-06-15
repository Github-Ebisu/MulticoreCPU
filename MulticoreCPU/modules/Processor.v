module Processor #(
    parameter MEM_WIDTH = 12,
    parameter INS_WIDTH = 8,
    parameter MEM_ADDR = 12,
    parameter INS_ADDR = 8
) (
    input wire clock,reset,start,
    input wire [MEM_WIDTH-1:0] fromDataMem,
    input wire [INS_WIDTH-1:0] fromInsMem,
    output wire [MEM_WIDTH-1:0] toDataMem,
    output wire [MEM_ADDR-1:0] MemAddr,
    output wire [INS_ADDR-1:0] InsAddr,
    output wire DataMemoryWriteEnable,
    output wire done,ready
);

wire [MEM_WIDTH-1:0] aluA, aluB, aluOUT;
wire [2:0] aluOP;
wire [3:0] busSel;
wire [MEM_WIDTH-1:0] busOut;
wire [INS_WIDTH-1:0] IRout;
wire [MEM_WIDTH-1:0] Rout, RLout, RCout, RPout, RQout, R1out, ACCout;
wire Zout, ZWrEn;
wire [3:0]  incReg;    // {PC, RC, RP, RQ}
wire [9:0]  wrEnReg;   // {AR, R, PC, IR, RL, RC, RP, RQ, R1, ACC}

ControlUnit #(.INS_WIDTH(INS_WIDTH)) controlUnit(
    .clk(clock), .reset(reset), .start(start), 
    .Zout(Zout), 
    .ins(IRout), 
    .aluOp(aluOP), 
    .incReg(incReg), 
    .wrEnReg(wrEnReg), 
    .busSel(busSel), 
    .DataMemWrEn(DataMemoryWriteEnable), 
    .ZWrEn(ZWrEn), 
    .done(done), .ready(ready)
    );


ALU #(.WIDTH(MEM_WIDTH)) alu(
    .A(aluA), .B(aluB), 
    .ALUop(aluOP), 
    .result(aluOUT)
    );

Bus #(.MEM_WIDTH(MEM_WIDTH), .INS_WIDTH(INS_WIDTH)) bus(
    .selectIn(busSel), 
    .DataMem(fromDataMem), 
    .R(Rout), .RL(RLout), .RC(RCout), .RP(RPout), .RQ(RQout), .R1(R1out), 
    .ACC(ACCout), .IR(IRout), 
    .busOut(busOut)
    );

Register #(.WIDTH(MEM_WIDTH)) AR(
    .dataIn(busOut), 
    .writeEn(wrEnReg[9]), .rst(reset), .clock(clock),
    .dataOut(MemAddr)
    );

Register #(.WIDTH(MEM_WIDTH)) R(
    .dataIn(busOut),
    .writeEn(wrEnReg[8]), .rst(reset), .clock(clock),
    .dataOut(Rout)
    );

incRegister #(.WIDTH(INS_WIDTH)) PC(
    .dataIn(IRout), 
    .writeEn(wrEnReg[7]), .rst(reset), .clock(clock), 
    .incEn(incReg[3]), 
    .dataOut(InsAddr)
    );


Register #(.WIDTH(INS_WIDTH)) IR(
    .dataIn(fromInsMem), 
    .writeEn(wrEnReg[6]), .rst(reset), .clock(clock),
    .dataOut(IRout)
    );    


Register #(.WIDTH(MEM_WIDTH)) RL(
    .dataIn(busOut), 
    .writeEn(wrEnReg[5]), .rst(reset), .clock(clock),
    .dataOut(RLout)
    );

incRegister #(.WIDTH(MEM_WIDTH)) RC(
    .dataIn(busOut), 
    .writeEn(wrEnReg[4]), .rst(reset), .clock(clock), 
    .incEn(incReg[2]), 
    .dataOut(RCout)
    );

incRegister #(.WIDTH(MEM_WIDTH)) RP(
    .dataIn(busOut), 
    .writeEn(wrEnReg[3]), .rst(reset), .clock(clock),
    .incEn(incReg[1]), 
    .dataOut(RPout)
    );

incRegister #(.WIDTH(MEM_WIDTH)) RQ(
    .dataIn(busOut), 
    .writeEn(wrEnReg[2]), .rst(reset), .clock(clock), 
    .incEn(incReg[0]), 
    .dataOut(RQout)
    );


Register #(.WIDTH(MEM_WIDTH)) R1(
    .dataIn(busOut), 
    .writeEn(wrEnReg[1]), .rst(reset), .clock(clock), 
    .dataOut(R1out)
    );

Register #(.WIDTH(MEM_WIDTH)) ACC(
    .dataIn(aluOUT), 
    .writeEn(wrEnReg[0]), .rst(reset), .clock(clock), 
    .dataOut(ACCout)
    );

isZeroReg #(.WIDTH(MEM_WIDTH)) Z(
    .dataIn(aluOUT), 
    .clock(clock), .rst(reset), .writeEn(ZWrEn), 
    .dataOut(Zout)
    );

assign toDataMem = Rout;
assign aluA = ACCout;
assign aluB = busOut;

endmodule