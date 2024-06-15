`timescale 1ns/1ns

module InsMemory_tb;

  // Parameters
  parameter MEM_INIT = 1;
  parameter WIDTH = 8;
  parameter DEPTH = 256;
  parameter ADDR_WIDTH = $clog2(DEPTH);

  // Signals
  reg clock;
  reg writeEn;
  reg [WIDTH-1:0] dataIn;
  reg [ADDR_WIDTH-1:0] address;
  wire [WIDTH-1:0] dataOut;

  // Instantiate the InsMemory module
  InsMemory #(MEM_INIT, WIDTH, DEPTH, ADDR_WIDTH) uut (
    .clock(clock),
    .writeEn(writeEn),
    .dataIn(dataIn),
    .address(address),
    .dataOut(dataOut)
  );

  // Clock generation
  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  // Stimulus
  initial begin
    $display("Starting Test Bench...");

    writeEn = 1;
    address = 0;
    dataIn = 8'b11011010;
    $display("Write: writeEn=%b, address=%h, dataIn=%h", writeEn, address, dataIn);

    #10; // Wait for a few cycles

    // Perform write operation
    writeEn = 1;
    address = 8'h1;
    dataIn = 8'b00110011;
    $display("Write: writeEn=%b, address=%h, dataIn=%h", writeEn, address, dataIn);
    #10;

    // Perform read operation
    writeEn = 0;
    address = 8'h1;
    $display("Read: writeEn=%b, address=%h, dataOut=%h", writeEn, address, dataOut);
    #10;

    // Add more test cases as needed

    $stop; // Stop simulation
  end

endmodule // InsMemory_tb
