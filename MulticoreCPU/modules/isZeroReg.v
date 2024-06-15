module isZeroReg 
#(parameter WIDTH = 12)
(
    input wire clock,
    input wire rst,
    input wire writeEn,
    input wire [WIDTH-1:0] dataIn,
    output wire dataOut
);

reg temp;

    always @(posedge clock) begin
        if (rst == 1) temp <= 1'b0;
        else if (writeEn == 1) begin
            if (dataIn == 0) temp <= 1;
            else temp <= 0;
        end
        else temp <= dataOut;
    end
assign dataOut = temp;

endmodule