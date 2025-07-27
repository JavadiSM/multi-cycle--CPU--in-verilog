module tb;
    reg clk;
    reg rst;
    wire [15:0] pc;
    
    processor mips(
        .rst(rst),
        .clk(clk),
        .pc(pc)
    );

    initial begin
        clk = 1;
        forever #1 clk = ~clk;
    end

    initial begin
        rst = 1;
        #2;
        rst = 0;
        wait (pc == 10) 
        #50
        $finish;
    end

    initial begin
        $dumpfile("tb_.vcd");
        $dumpvars(0, tb);
    end
endmodule