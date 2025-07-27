module shiftaddmul (
    input [7:0] A, B,
    input clk,start,
    output reg [15:0] out
);
 
reg [15:0] multiplicand; 
reg [15:0] multiplier;
reg [15:0] product;
reg [3:0] count; 

always @(posedge clk) begin
    if (start) begin
        // Initialize for a new multiplication
        multiplicand <= A;
        multiplier <= B;
        product <= 9'b0;
        count <= 0;
    end else begin
        if (count < 8) begin
            if (multiplier[0] == 1)
                product <= product + {1'b0, multiplicand};
            multiplicand <= multiplicand << 1;
            multiplier <= multiplier >> 1;
            count <= count + 1;
        end else begin
            out <= product;
        end
    end
end

endmodule