module RAM #(
    parameter DATA_WIDTH = 12,
    parameter DEPTH = 256,
    parameter ADDR_WIDTH = $clog2(DEPTH)  // 4096 locations
)
(clock, dataIn, address, WriteEn, dataOut);


input wire clock, WriteEn;
input wire [DATA_WIDTH-1 : 0] dataIn;
input wire [ADDR_WIDTH-1 : 0] address;
output wire [DATA_WIDTH-1 : 0] dataOut;

reg [DATA_WIDTH-1 : 0] ram[0 : DEPTH-1];
reg [DATA_WIDTH-1 : 0] temp;

always @(posedge clock) begin
    if (WriteEn) begin
        ram[address] <= dataIn;
    end
    temp <= ram[address];
end

assign dataOut = temp;

endmodule