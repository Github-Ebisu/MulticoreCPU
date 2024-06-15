`timescale 1ns/1ns

module Bus_tb;

  // Parameters
  parameter MEM_WIDTH = 12;
  parameter INS_WIDTH = 8;

  // Signals
  reg [3:0] selectIn;
  reg [MEM_WIDTH-1:0] DataMem, R, RL, RC, RP, RQ, R1, ACC;
  reg [INS_WIDTH-1:0] IR;
  wire [MEM_WIDTH-1:0] busOut;

  // Instantiate Bus module
  Bus #(MEM_WIDTH, INS_WIDTH) uut (
    .selectIn(selectIn),
    .DataMem(DataMem),
    .R(R),
    .RL(RL),
    .RC(RC),
    .RP(RP),
    .RQ(RQ),
    .R1(R1),
    .ACC(ACC),
    .IR(IR),
    .busOut(busOut)
  );

  // Clock generation
  reg clk = 0;
  always #5 clk = ~clk;

  // Testbench stimulus
  initial begin
    // Test case 1: DataMem_sel
    selectIn = 4'b0000;
    DataMem = 12'h123;
    R = 12'h456;
    RL = 12'h789;
    RC = 12'hABC;
    RP = 12'hDEF;
    RQ = 12'hF00;
    R1 = 12'hFED;
    ACC = 12'h987;
    IR = 8'b10101010;
    #10;
    $display("Time = %0t, Test case 1: DataMem_sel, selectIn = %b, busOut = %h", $time, selectIn, busOut);

    // Test case 2: R_sel
    selectIn = 4'b0001;
    #10;
    $display("Time = %0t, Test case 2: R_sel, selectIn = %b, busOut = %h", $time, selectIn, busOut);

    // Test case 3: IR_sel
    selectIn = 4'b0010;
    #10;
    $display("Time = %0t, Test case 3: IR_sel, selectIn = %b, busOut = %h", $time, selectIn, busOut);

    // Test case 4: RL_sel
    selectIn = 4'b0011;
    #10;
    $display("Time = %0t, Test case 4: RL_sel, selectIn = %b, busOut = %h", $time, selectIn, busOut);

    // Test case 5: RC_sel
    selectIn = 4'b0100;
    #10;
    $display("Time = %0t, Test case 5: RC_sel, selectIn = %b, busOut = %h", $time, selectIn, busOut);

    // Test case 6: RP_sel
    selectIn = 4'b0101;
    #10;
    $display("Time = %0t, Test case 6: RP_sel, selectIn = %b, busOut = %h", $time, selectIn, busOut);

    // Test case 7: RQ_sel
    selectIn = 4'b0110;
    #10;
    $display("Time = %0t, Test case 7: RQ_sel, selectIn = %b, busOut = %h", $time, selectIn, busOut);

    // Test case 8: R1_sel
    selectIn = 4'b0111;
    #10;
    $display("Time = %0t, Test case 8: R1_sel, selectIn = %b, busOut = %h", $time, selectIn, busOut);

    // Test case 9: ACC_sel
    selectIn = 4'b1000;
    #10;
    $display("Time = %0t, Test case 9: ACC_sel, selectIn = %b, busOut = %h", $time, selectIn, busOut);

    // Test case 10: idle
    selectIn = 4'b1001;
    #10;
    $display("Time = %0t, Test case 10: idle, selectIn = %b, busOut = %h", $time, selectIn, busOut);

    $stop;
  end

endmodule
