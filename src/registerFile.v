module registerFile (
    input clk,
    input [15:0] wdata,
    output reg signed  [15:0] rdata1, rdata2,
    input [1:0] readAdd1,readAdd2,writeAdd,
    input we,rst
);
    reg signed [15:0] regs [0:3];
    always @(posedge clk) begin
        if (rst) begin
            regs[0]<= 0;
            regs[1]<= 0;
            regs[2]<= 0;
            regs[3]<= 0;
        end
        if (we) regs[writeAdd] <= wdata;
    end
    always @(negedge clk) begin
        rdata1 <= regs[readAdd1];
        rdata2 <= regs[readAdd2];
    end
    initial begin
        $monitor("REGISTER FILE: at time: %t\nr0:%h\nr1:%h\nr2:%h\nr3:%h\n",$time,regs[0],regs[1],regs[2],regs[3]);
    end
endmodule