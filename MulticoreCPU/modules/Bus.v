module Bus #(
    parameter MEM_WIDTH = 12,
    parameter INS_WIDTH = 8
) (
    input wire [3:0] selectIn,  
    input wire [MEM_WIDTH-1:0] DataMem, R, RL, RC, RP, RQ, R1, ACC,
    input wire [INS_WIDTH-1:0] IR,
    output reg [MEM_WIDTH-1:0] busOut
);

    //control signals to select the bus input 
localparam  [3:0]
    DataMem_sel = 4'b0, 
    R_sel    = 4'd1,
    IR_sel   = 4'd2,
    RL_sel   = 4'd3,
    RC_sel   = 4'd4,
    RP_sel   = 4'd5,
    RQ_sel   = 4'd6,
    R1_sel   = 4'd7,
    ACC_sel   = 4'd8,
    idle     = 4'd9;


//input of the data-bus is selected as below
always @(*) begin
    case (selectIn)
        DataMem_sel: busOut = DataMem;
        R_sel:  busOut = R;
        IR_sel: busOut =  {{(MEM_WIDTH-INS_WIDTH){1'b0}},IR}; // add 4 bits MSB are zero
        RL_sel: busOut =  RL;
        RC_sel: busOut =  RC;
        RP_sel: busOut =  RP;
        RQ_sel: busOut =  RQ;
        R1_sel: busOut =  R1;
        ACC_sel: busOut =  ACC;   
        default: busOut = {(MEM_WIDTH){1'b0}};
    endcase
end
endmodule