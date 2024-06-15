module Register #(
    parameter WIDTH = 12
) 
(
    input wire clock,
    input wire rst,
    input wire writeEn,
    input wire [WIDTH-1:0] dataIn,
    output wire [WIDTH-1:0] dataOut
);

reg [WIDTH-1:0] temp;
    always @(posedge clock) begin
        if (rst == 1) temp <= 0;
        else if (writeEn) temp <= dataIn;
    end

assign dataOut = temp;

endmodule