module ALU (
    input signed [15:0] A, B,
    input [1:0] ALUOP,
    input clk,
    output reg signed [15:0] Result,
    output reg carry,
    output zero 
);
    reg start=0;
    reg [4:0] counter=0;
    wire signed [31:0] reslow,divres;
    wire signed [15:0] negB, negA, resADD, resSUB;
    reg [15:0] multiplier,multiplicand,divA,divB;
    wire _CARRY, _BORROW;
    reg Cin=0;
    assign negB = -B;
    assign negA = -A;
    assign zero = (Result == 16'b0);
    
    CSA ADDER (
        .A(A),
        .B(B),
        .CIN(Cin),
        .S(resADD),
        .COUT(_CARRY)
    );

    CSA SIGNED_SUBTRACTOR (
        .A(A),
        .B(negB),
        .CIN(Cin),
        .S(resSUB),
        .COUT(_BORROW)
    );
    MUL aasd(
        .A(multiplier),
        .B(multiplicand),
        .clk(clk),
        .start(start),
        .S(reslow)
    );
    DIV dividerModule(
        .A(divA),
        .B(divB),
        .clk(clk),
        .start(start),
        .S(divres)
    );
    always @(*) begin
        case (ALUOP)
            2'b00: begin // ADD
                Result = resADD;
                carry = _CARRY; // For signed, overflow detection might need more logic
            end 
            2'b01: begin // SUB
                Result = resSUB;
                carry = _BORROW; // Same note for overflow
            end 
            2'b10: begin // MUL
            if (A[15]) multiplier = negA;
            else multiplier = A; 
            if (B[15]) multiplicand = negB;
            else multiplicand = B; 

            if (counter<=2) 
                start = 1;
            else
                start = 0;

            if ((A[15] && ~B[15])||(~A[15] && B[15])) Result = -reslow[15:0];
            else Result = reslow[15:0];
            end 
            2'b11: begin // DIV
            divA = A;
            divB = B;
            if (counter<=2)
                start = 1;
            else
                start = 0;

            if (((A[15] && ~B[15])||(~A[15] && B[15]))&&(!divres[15])) Result = -divres[15:0];
            else if (((A[15] && B[15])||(~A[15] && ~B[15]))&&(divres[15])) Result = -divres[15:0];
            else Result = divres[15:0];
            end
        endcase
    end

    always @(posedge clk) begin
        if (ALUOP==2'b10 || ALUOP==2'b11) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
        end
    end

endmodule