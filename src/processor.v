module processor (
    input clk,
    input rst,
    output [15:0] pc
);

    reg [15:0] PC,MDB;
    assign pc = PC;

    // Inputs and outputs for Control Unit (CU)
    reg [15:0] instruction;
    wire [8:0]immediate;
    assign immediate = instruction[8:0];


    wire we, memWrite, memRead, regsrc, store,alusrc;
    wire [1:0] ALUOP;
    wire ready,IRpdate;

    // Register File Interface
    wire signed [15:0] rdata1, rdata2;
    wire [1:0] readAdd1, readAdd2, writeAdd;
    assign writeAdd = instruction[12:11];
    assign readAdd1 = instruction[10:9];
    assign readAdd2 = (store) ? instruction[12:11]:instruction[8:7];
    wire [15:0] wdata;

    // ALU signals
    wire signed [15:0] ALU_result;
    wire carry, zero;
 
    // Memory Interface
    wire signed [15:0] memDataOut, dataIn,alusrcB;
    wire [15:0] dataOut;
    wire signed [15:0] signedIM;
    assign signedIM = {{7{immediate[8]}},immediate};
    wire [15:0] address;
    assign address = (IRpdate) ? PC:ALU_result; // 0 for load store
    assign alusrcB = (alusrc) ? rdata2: signedIM; // 0 for load store
    assign wdata = (regsrc) ? ALU_result:MDB; // 0 for load store

    // Instantiate Control Unit
    // Assuming control signals and instruction connections
    CU cu (
        .instruction(instruction),
        .clk(clk),
        .rst(rst),
        .we(we),
        .memWrite(memWrite),
        .memRead(memRead),
        .ready(ready),
        .regsrc(regsrc),
        .IRpdate(IRpdate),
        .store(store),
        .alusrc(alusrc),
        .ALUOP(ALUOP)
    );

    // Instantiate Register File
    registerFile regFile (
        .clk(clk),
        .wdata(wdata),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .readAdd1(readAdd1),
        .readAdd2(readAdd2),
        .writeAdd(writeAdd),
        .we(we),
        .rst(rst)
    );

    // Instantiate ALU
    ALU alu (
        .A(rdata1),
        .B(alusrcB),
        .ALUOP(ALUOP),
        .Result(ALU_result),
        .carry(carry),
        .zero(zero),
        .clk(clk)
    );

    // Instantiate Memory
    memory mem (
        .rst(rst),
        .memRead(memRead),
        .memWrite(memWrite),
        .dataIN(rdata2),
        .address(address),
        .clk(clk),
        .dataOut(memDataOut)
    );

    always @(posedge clk) begin
        if (rst) begin 
            PC <= 0;
        end else begin
            if (ready) PC <= PC + 1;
        end        
    end
    always @(negedge clk) begin
        if (IRpdate) 
        begin 
            instruction <= memDataOut;
        end
        MDB <= memDataOut;
    end
endmodule