`timescale 1ns/1ns

module ALU_tb;

  // Parameters
  parameter WIDTH = 12;

  // Signals
  reg [2:0] ALUop;
  reg [WIDTH-1:0] A, B;
  wire [WIDTH-1:0] result;

  // Instantiate ALU module
  ALU #(WIDTH) uut (
    .ALUop(ALUop),
    .A(A),
    .B(B),
    .result(result)
  );

  // Clock generation
  reg clk = 0;
  always #5 clk = ~clk;

  // Testbench stimulus
  initial begin
    // Test case 1: clr
    ALUop = 3'b000;
    A = 12'h123;
    B = 12'h456;
    #10;
    $display("Time = %0t, Test case 1: clr, A = %h, B = %h, ALUop = %b, Result = %h", $time, A, B, ALUop, result);

    // Test case 2: pass
    ALUop = 3'b001;
    A = 12'h123;
    B = 12'h456;
    #10;
    $display("Time = %0t, Test case 2: pass, A = %h, B = %h, ALUop = %b, Result = %h", $time, A, B, ALUop, result);

    // Test case 3: add
    ALUop = 3'b010;
    A = 12'h123;
    B = 12'h456;
    #10;
    $display("Time = %0t, Test case 3: add, A = %h, B = %h, ALUop = %b, Result = %h", $time, A, B, ALUop, result);

    // Test case 4: sub
    ALUop = 3'b011;
    A = 12'h123;
    B = 12'h456;
    #10;
    $display("Time = %0t, Test case 4: sub, A = %h, B = %h, ALUop = %b, Result = %h", $time, A, B, ALUop, result);

    // Test case 5: mul
    ALUop = 3'b100;
    A = 12'h123;
    B = 12'h456;
    #10;
    $display("Time = %0t, Test case 5: mul, A = %h, B = %h, ALUop = %b, Result = %h", $time, A, B, ALUop, result);

    // Test case 6: inc
    ALUop = 3'b101;
    A = 12'h123;
    B = 12'h456;
    #10;
    $display("Time = %0t, Test case 6: inc, A = %h, B = %h, ALUop = %b, Result = %h", $time, A, B, ALUop, result);

    // Test case 7: idle
    ALUop = 3'b110;
    A = 12'h123;
    B = 12'h456;
    #10;
    $display("Time = %0t, Test case 7: idle, A = %h, B = %h, ALUop = %b, Result = %h", $time, A, B, ALUop, result);
    
    $stop;
  end

endmodule
