module memory (
    input memRead,
    input memWrite,rst,
    input signed [15:0] dataIN,
    input [15:0] address,
    input clk,
    output reg signed [15:0] dataOut
);
    // Declare the memory as signed
    reg signed [15:0] MEM [0:100]; // [0, 2^16 - 1] 

    always @(posedge clk) begin
        if (rst) begin
            MEM[0] <= 16'b0000000000000000;
            MEM[1] <= 16'b100_01_11_000001010; // load x1 10(x3)
            MEM[2] <= 16'b100_10_11_000001011; // load x2 11(x3)
            MEM[3] <= 16'b000_00_01_10_0000000; // add x0, x1,x2
            MEM[4] <= 16'b001_00_00_01_0000000; // sub x0, x0,x1
            MEM[5] <= 16'b000_00_00_00_0000000; // add x0, x0,x0
            MEM[6] <= 16'b101_00_11_000001100;  // store x0 12(x3)
            MEM[7] <= 16'b010_11_01_10_0001100;  // mul x3, x1,x2
            MEM[8] <= 16'b000_00_00_00_0000000; // add x0, x0,x0
            MEM[9] <= 16'b011_11_00_10_0000000;  // div x3, x0,x2
            MEM[10] <= 16'h00A5;
            MEM[11] <= 16'h00AA;
            MEM[12] <= 16'b0000000000000000;
            MEM[13] <= 16'b0000000000000000;

        end else if (memWrite) begin
            MEM[address] <= dataIN;
        end
    end
    always @(negedge clk) begin
        if (memRead) begin
            dataOut <= MEM[address];
        end
    end
endmodule