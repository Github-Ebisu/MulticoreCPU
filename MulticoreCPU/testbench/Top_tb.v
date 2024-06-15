`timescale 1ns/1ns

module Top_tb();

localparam CLK_PERIOD = 20;

reg clk;
initial begin
    clk = 0;
    forever #((CLK_PERIOD)/2) clk = ~clk;
end

localparam CORE_COUNT = 6;

reg reset, start;
wire processor_ready, processDone;

Top #(.CORE_COUNT(CORE_COUNT)) top_instance (
    .clock(clk),
    .reset(reset),
    .start(start),
    .processorReady(processor_ready),
    .processDone(processDone)
);

initial begin
    @(posedge clk);
    reset = 1;
    start = 0;

    @(posedge clk);
    reset = 0;
    start = 1;

    @(posedge clk);
    start = 0;

    // Wait for the first rising edge of clk after startN is asserted
    wait(processDone);

    // Add a delay to observe the simulation results
    #10;

    $stop;
end

endmodule // Top_tb
