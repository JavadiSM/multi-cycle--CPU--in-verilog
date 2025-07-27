module multb;

reg [15:0] A, B;
reg clk, start;
wire [31:0] S,realANs;
 
// Instantiate the MUL module
MUL dut (
    .A(A),
    .B(B),
    .clk(clk),
    .start(start),
    .S(S)
);
assign realANs = A*B;
// Clock generation
initial begin
    clk = 0;
    forever #1 clk = ~clk; // 10 time units period
end

// Test procedure
initial begin
    // Initialize inputs
    start = 0;
    A = 0;
    B = 0;

    // Wait for some time before starting test
    #10;

    // Test case 1
    A = 16'h1234; // 4660 in decimal
    B = 16'h00FF; // 255 in decimal
    start = 1; // Start multiplication
    #2;
    start = 0; // Clear start signal

    // Wait until the multiplication completes
    #50

    // Check result
    $display("A=%h, B=%h, S=%h, real ANS:%h", A, B, S,realANs);
    $display(realANs==S);

    // Test case 2
    @(negedge clk);
    A = 16'h0BCD; // 43981
    B = 16'h0002; // 2
    start = 1;
    #2
    start = 0;
    #50
    $display("A=%h, B=%h, S=%h, real ANS:%h", A, B, S,realANs);
    $display(realANs==S);
    // Add more test cases as needed

    // Finish simulation
    #20;
    $stop;
end

endmodule