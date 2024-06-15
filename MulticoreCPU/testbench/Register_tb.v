`timescale 1ns/1ns

module Register_tb;

  // Parameters
  parameter WIDTH = 12;

  // Signals
  reg clock = 0; // Initialize the clock
  reg rst, writeEn;
  reg [WIDTH-1:0] dataIn;
  wire [WIDTH-1:0] dataOut;

  // Instantiate Register module
  Register #(WIDTH) register (
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
    $display("Time = %0t, Test case 1: Reset, dataIn = %h, writeEn = %b, rst = %b, dataOut = %h", $time, dataIn, writeEn, rst, dataOut);

    // Test case 2: Write
    rst = 0;
    writeEn = 1;
    dataIn = 12'h456;
    #10;
    $display("Time = %0t, Test case 2: Write, dataIn = %h, writeEn = %b, rst = %b, dataOut = %h", $time, dataIn, writeEn, rst, dataOut);

    // Test case 3: No write
    rst = 0;
    writeEn = 0;
    dataIn = 12'h789;
    #10;
    $display("Time = %0t, Test case 3: No write, dataIn = %h, writeEn = %b, rst = %b, dataOut = %h", $time, dataIn, writeEn, rst, dataOut);

    // Add more test cases as needed

    $stop;
  end

endmodule
