module InsMemory
#( 
    parameter MEM_INIT = 0, 
    parameter WIDTH = 8,
    parameter DEPTH = 256,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)
(
    input wire clock, writeEn,
    input wire [WIDTH-1:0]dataIn,
    input wire [ADDR_WIDTH-1:0]address,
    output wire [WIDTH-1:0]dataOut
);


reg [ADDR_WIDTH-1:0] addr_reg;

reg [WIDTH-1:0] memory[0:DEPTH-1] ;

/// initialize memory for simulation  /////////
initial begin
    if (MEM_INIT == 1) begin
       // $readmemb("../Code/9_ins_mem_tb.txt", memory);
        $readmemb("../test/5_ins_mem_tb.txt", memory);
    end
end
///////////////////////////////////////////////

always @(posedge clock) begin
    addr_reg <= address;
    if (writeEn) begin
        memory[address] <= dataIn;   // write requires only 1 clk cyle. 
    end
end
assign dataOut = memory[addr_reg];   // address is registered. Need 2 clk cycles to read.

endmodule // INS_RAM
