module MUL (
    input signed [15:0] A,B,
    input clk,start,
    output signed [31:0] S
); 
    wire [7:0] XH,XL,YH,YL,S1,S2;
    wire signed [15:0] Z2,Z1,Z0,S3; // s1 = XH+XL,s2= YH+YL, S3 = S1*S2
    assign XH = A[15:8];
    assign XL = A[7:0];
    assign YH = B[15:8];
    assign YL = B[7:0];
    assign S1 = XH + XL;
    assign S2 = YH + YL;
    assign Z1 = S3 - Z2 - Z0;
    shiftaddmul abaaadad(.A(XH),.B(YH),.clk(clk),.start(start),.out(Z2));
    shiftaddmul sdfsfrg(.A(XL),.B(YL),.clk(clk),.start(start),.out(Z0));
    shiftaddmul sdsds333ntyuk(.A(S1),.B(S2),.clk(clk),.start(start),.out(S3));
    assign S = {Z2,16'b0} + {8'b0,{Z1, 8'b0}} + {16'b0, Z0};

endmodule