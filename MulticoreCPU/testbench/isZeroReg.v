`timescale 1ns/1ns

module isZeroReg_tb;

  // Parameters
  parameter WIDTH = 12;

  // Signals
  reg rst, writeEn;
  reg clock = 0;
  reg [WIDTH-1:0] dataIn;
  wire dataOut;

  // Instantiate isZeroReg module
  isZeroReg #(WIDTH) uut (
    .clock(clock),
    .rst(rst),
    .writeEn(writeEn),
    .dataIn(dataIn),
    .dataOut(dataOut)
  );

  // Clock generation
  always #5 clock = ~clock;

  // Testbench stimulus
  initial begin
    // Test case 1: Reset
    rst = 1;
    writeEn = 0;
    dataIn = 12'h123;
    #10;
    $display("Time = %0t, Test case 1: Reset, dataIn = %h, writeEn = %b, rst = %b, dataOut = %b", $time, dataIn, writeEn, rst, dataOut);

    // Test case 2: Write 0
    rst = 0;
    writeEn = 1;
    dataIn = 12'h000;
    #10;
    $display("Time = %0t, Test case 2: Write 0, dataIn = %h, writeEn = %b, rst = %b, dataOut = %b", $time, dataIn, writeEn, rst, dataOut);

    // Test case 3: Write non-zero
    rst = 0;
    writeEn = 1;
    dataIn = 12'h456;
    #10;
    $display("Time = %0t, Test case 3: Write non-zero, dataIn = %h, writeEn = %b, rst = %b, dataOut = %b", $time, dataIn, writeEn, rst, dataOut);

    // Test case 4: No write
    rst = 0;
    writeEn = 0;
    dataIn = 12'h789;
    #10;
    $display("Time = %0t, Test case 4: No write, dataIn = %h, writeEn = %b, rst = %b, dataOut = %b", $time, dataIn, writeEn, rst, dataOut);

    // Add more test cases as needed

    $stop;
  end

endmodule
