`timescale 1ns/1ns

module incRegister_tb;

  // Parameters
  parameter WIDTH = 12;

  // Signals
  reg [WIDTH-1:0] dataIn;
  reg writeEn, rst, incEn;
  reg clock = 0;
  wire [WIDTH-1:0] dataOut;

  // Instantiate incRegister module
  incRegister #(WIDTH) uut (
    .dataIn(dataIn),
    .writeEn(writeEn),
    .rst(rst),
    .clock(clock),
    .incEn(incEn),
    .dataOut(dataOut)
  );

  // Clock generation=
  always #5 clock = ~clock;

  // Testbench stimulus
  initial begin
    // Test case 1: Write operation
    dataIn = 12'h123;
    writeEn = 1;
    rst = 0;
    incEn = 0;
    #10;
    $display("Time = %0t, Test case 1: Write operation, dataIn = %h, writeEn = %b, rst = %b, incEn = %b, dataOut = %h", $time, dataIn, writeEn, rst, incEn, dataOut);

    // Test case 2: Increment operation
    dataIn = 12'h000;
    writeEn = 0;
    rst = 0;
    incEn = 1;
    #10;
    $display("Time = %0t, Test case 2: Increment operation, dataIn = %h, writeEn = %b, rst = %b, incEn = %b, dataOut = %h", $time, dataIn, writeEn, rst, incEn, dataOut);

    // Test case 3: Reset operation
    dataIn = 12'h000;
    writeEn = 0;
    rst = 1;
    incEn = 0;
    #10;
    $display("Time = %0t, Test case 3: Reset operation, dataIn = %h, writeEn = %b, rst = %b, incEn = %b, dataOut = %h", $time, dataIn, writeEn, rst, incEn, dataOut);

    // Add more test cases as needed

    $stop;
  end

endmodule
