module Top #(
    parameter CORE_COUNT = 3
) (
    input wire clock, reset, start,
    output wire processorReady, processDone
);

localparam MEM_WIDTH = 12;
localparam INS_WIDTH = 8;
localparam INS_MEM_DEPTH = 256;
localparam DATA_MEM_DEPTH = 2048;
localparam MEM_ADDR = $clog2(DATA_MEM_DEPTH);
localparam INS_ADDR = $clog2(INS_MEM_DEPTH);


wire [MEM_WIDTH*CORE_COUNT-1:0] DataMemOut, DataMemIn, processor_DataOut;
wire [MEM_ADDR-1:0] MemAddr;
wire [MEM_ADDR-1:0] processor_dataMemAddr;

wire [INS_WIDTH-1:0] InsMemOut, InsMemIn;
wire [INS_ADDR-1:0] InsAddr; 
wire [INS_ADDR-1:0] processor_InsMemAddr;

wire dataMemWrEn, processor_DataMemWrEn;
wire processStart;


localparam [2:0]   //states
    idle = 3'd0,
    process_exicute = 3'd4,
    finish = 3'd6;


reg [2:0] currentState, nextState; 

always @(posedge clock) begin
    if (reset) begin
        currentState <= idle;
    end
    else begin
        currentState <= nextState;
    end
end

always @(*) begin

    nextState = currentState;

    case (currentState)
        idle: begin     // start state
            if (start) begin
                nextState = process_exicute;
            end
        end

        process_exicute: begin  // processor exicute program (matrix multiplication)
            if (processDone) begin
                nextState = finish;
            end
        end


        finish: begin  //End of the process
            
        end

        default : nextState = idle;            
        
    endcase
end

assign processStart = ((currentState == idle) && (start))? 1'b1: 1'b0;

assign dataMemWrEn = (currentState == process_exicute)? processor_DataMemWrEn : 1'b0;

assign MemAddr = (currentState == process_exicute)? processor_dataMemAddr: {MEM_ADDR{1'b0}};

assign DataMemIn = (currentState == process_exicute)? processor_DataOut: {(MEM_WIDTH*CORE_COUNT){1'b0}};

assign InsAddr = (currentState == process_exicute)? processor_InsMemAddr: {INS_ADDR{1'b0}};

MultiCore #(
    .MEM_WIDTH(MEM_WIDTH), 
    .INS_WIDTH(INS_WIDTH), 
    .CORE_COUNT(CORE_COUNT), 
    .MEM_ADDR(MEM_ADDR), 
    .INS_ADDR(INS_ADDR)
) 
multi_core_processor(
    .clock(clock), 
    .reset(reset), 
    .start(processStart), 
    .ProcessorDataIn(DataMemOut), 
    .InsMemOut(InsMemOut),
    .ProcessorDataOut(processor_DataOut), 
    .InsAddr(processor_InsMemAddr),
    .MemAddr(processor_dataMemAddr),
    .DataMemoryWriteEnable(processor_DataMemWrEn), 
    .ready(processorReady),
    .done(processDone)
);


InsMemory #(.WIDTH(INS_WIDTH), .DEPTH(INS_MEM_DEPTH), .MEM_INIT(1)) 
IM (.clock(clock), .writeEn(1'b0), 
.dataIn(InsMemIn), 
.address(InsAddr), 
.dataOut(InsMemOut)
);

DataMemory #(.WIDTH(MEM_WIDTH*CORE_COUNT), .DEPTH(DATA_MEM_DEPTH), .MEM_INIT(1)) 
DM (.clock(clock), .writeEn(dataMemWrEn), 
.dataIn(DataMemIn), 
.address(MemAddr), 
.dataOut(DataMemOut), 
.processDone(processDone)
);

endmodule