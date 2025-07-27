module DIV (
    input signed [15:0] A, B,
    input clk, start,
    output reg signed [31:0] S
); 
    reg [4:0] count;
    reg [15:0] abs_A, abs_B;
    reg signed [31:0] remainder;
    reg signed [15:0] quotient;
    reg sign;
    always @(posedge clk) begin
        if (start) begin
            // Start division
            abs_A <= A[15] ? -A : A;
            abs_B <= B[15] ? -B : B;
            remainder <= 0;
            quotient <= 0;
            count <= 16;
            sign <= A[15] ^ B[15];
        end else begin
            remainder = {remainder[30:0], abs_A[15]};
            abs_A = abs_A << 1;
            remainder = remainder - {16'b0, abs_B};
            if (remainder[31]) begin
                remainder = remainder + {16'b0, abs_B};
                quotient = quotient << 1;
            end else begin
                quotient = (quotient << 1) | 1'b1;
            end
            count = count - 1;
            if (count == 0) begin
                S <= sign ? -quotient : quotient;
            end
        end
    end
endmodule
