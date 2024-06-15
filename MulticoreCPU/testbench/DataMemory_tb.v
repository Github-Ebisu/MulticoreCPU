`timescale 1ns/1ns

module DataMemory_tb;

  // Parameters
  parameter MEM_INIT = 0;
  parameter WIDTH = 36;
  parameter DEPTH = 2048;
  parameter ADDR_WIDTH = $clog2(DEPTH);

  // Signals
  reg clock;
  reg writeEn;
  reg [WIDTH-1:0] dataIn;
  reg [ADDR_WIDTH-1:0] address;
  wire [WIDTH-1:0] dataOut;
  reg processDone;

  // Instantiate the DataMemory module
  DataMemory #(MEM_INIT, WIDTH, DEPTH, ADDR_WIDTH) uut (
    .clock(clock),
    .writeEn(writeEn),
    .dataIn(dataIn),
    .address(address),
    .dataOut(dataOut),
    .processDone(processDone)
  );

  // Clock generation
  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  // Stimulus
  initial begin
    writeEn = 1;
    address = 0;
    dataIn = 12'hABC;

    #10; // Wait for a few cycles
    $display("clock=%0d, writeEn=%0d, address=%0h, dataIn=%0h, dataOut=%0h, processDone=%0d", clock, writeEn, address, dataIn, dataOut, processDone);

    // Perform write operation
    writeEn = 1;
    address = 8'h1;
    dataIn = 12'h123;
    #10;
    $display("clock=%0d, writeEn=%0d, address=%0h, dataIn=%0h, dataOut=%0h, processDone=%0d", clock, writeEn, address, dataIn, dataOut, processDone);

    // Perform read operation
    writeEn = 0;
    address = 8'h1;
    #10;

    // Display values
    $display("clock=%0d, writeEn=%0d, address=%0h, dataIn=%0h, dataOut=%0h, processDone=%0d", clock, writeEn, address, dataIn, dataOut, processDone);

    processDone = 1; // Trigger the processDone event
    #10; // Wait for a few cycles

    $stop; // Stop simulation
  end

endmodule // DataMemory_tb
