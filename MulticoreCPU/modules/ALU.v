module ALU #(parameter WIDTH = 12) (ALUop, A, B, result);


input wire [2:0] ALUop;
input wire [WIDTH-1:0] A,B;
output reg [WIDTH-1:0] result;

// ALU operations and their control signals
localparam [2:0] 
clr  =  3'd0,   // result ← 0
pass =  3'd1,   // result ← b
add  =  3'd2,   // result ← a+b
sub  =  3'd3,   // result ← a-b
mul  =  3'd4,   // result ← a * b
inc  =  3'd5,   // result ← result +1
idle =  3'd6;   // No operation

always @(*) begin
    case (ALUop)
        clr: result = {WIDTH{1'b0}};  
        pass: result = B;
        add: result = A + B;
        sub: result = A - B;
        mul: result = A * B;
        inc: result = A + 1'b1; // result = a + 1'b1; 
        idle: result = {WIDTH{1'b0}};
        default: result = {WIDTH{1'b0}};
    endcase
end
    
endmodule