module incRegister 
#(parameter WIDTH = 12 )  //default size of a register is 12
(
    input [WIDTH-1:0]dataIn,
    input writeEn,rst,clock,incEn,
    output [WIDTH-1:0]dataOut
);

reg [WIDTH-1:0]value;

always @(posedge clock) begin
    if (rst)
        value <= 0;
    else if (writeEn)
        value <= dataIn;
    else if (incEn)
        value <= value + 1'b1;
end

assign dataOut = value;

endmodule //incRegister