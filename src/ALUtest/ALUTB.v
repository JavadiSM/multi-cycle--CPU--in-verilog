module ALU_tb;
 
    // Inputs
    reg signed [15:0] A;
    reg signed [15:0] B;
    wire signed [15:0] realAdd;
    assign realAdd = A + B;
    wire signed [15:0] realSub;
    assign realSub = A - B;
    wire signed [15:0] realMul;
    assign realMul = A * B;
    wire signed [15:0] realDiv;
    assign realDiv = A / B;
    reg [1:0] ALUOP;
    reg clk;
    // Outputs
    wire signed [15:0] Result;
    wire carry;
    wire zero;

    // Instantiate the ALU
    ALU dut (
        .A(A),
        .B(B),
        .ALUOP(ALUOP),
        .Result(Result),
        .carry(carry),
        .zero(zero),
        .clk(clk)
    );

    integer a_value, b_value;
    integer fail = 0;

    initial begin
    clk = 0;
    forever #1 clk = ~clk;
    end

    initial begin
        // $monitor(a_value);
        for (a_value = -32768; a_value <= 32767; a_value = a_value + 103) begin
            for (b_value = -32767; b_value <= 32767; b_value = b_value + 103) begin
                // Test ADD
                A = a_value;
                B = b_value;
                ALUOP = 2'b00; // ADD
                #2;
                if (realAdd !== Result) begin
                    $display("ADD: A=%d B=%d Result=%d Carry=%b Zero=%b", A, B, Result, carry, zero);
                    fail=1;
                end

                ALUOP = 2'b10; // MUL
                #40
                if (realMul !== Result) begin
                     $display("MUL: A=%d B=%d Result=%d Carry=%b Zero=%b", A, B, Result, carry, zero);
                    fail=1;
                end

                // Test SUB
                ALUOP = 2'b01; // SUB
                #2;
                if (realSub !== Result) begin
                     $display("SUB: A=%d B=%d Result=%d Carry=%b Zero=%b", A, B, Result, carry, zero);
                    fail=1;
                end

                ALUOP = 2'b11; // DIV
                #40
                if (realDiv !== Result && B!=0) begin
                     $display("DIV: A=%d B=%d Result=%d  real answer", A, B, Result, realDiv);
                    fail=1;
                end
            end
        end
        if (fail) $display("fail");
        else $display("nice");
        $finish;
    end

endmodule