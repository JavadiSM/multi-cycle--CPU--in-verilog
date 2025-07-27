module CU (
    input [15:0] instruction,
    input clk,rst,
    output reg  we,memWrite,memRead,ready,regsrc,IRpdate, store,alusrc,
    output reg [1:0] ALUOP
);
    wire [2:0] opcode = instruction[15:13];
    reg check=0;
    reg [6:0] state,nstate;
    reg [5:0] counter=0;
    localparam IF = 0,
                DEC = 1,
                ADDALU = 2,
                ADDWB=3,
                SUBALU=4,
                SUBWB=5,
                LOADALU=6,
                LOADMEM=7,
                LOADWB=8,
                STOREALU=9,STOREMEM=10,
                dedfdd=11,MULALU=12,MULWB=13,DIVALU=14,DIVWB=15;
    always @(posedge clk) begin
        if (rst) begin
            state <= 0;
            counter <= 0;
        end else begin
            state <= nstate;
        end
        if (ALUOP==2'b10 || ALUOP==2'b11) begin
            counter <= counter + 1;
        end else begin 
            counter <= 0;
        end
    end

    always @(*) begin
        case (state)
            IF: begin
            we=0;
            memWrite=0;
            memRead=1;
            ready= 0;
            regsrc=1;
            IRpdate=1;
            store=0;
            alusrc=0;
            ALUOP=0;
            nstate = DEC;
            end
            DEC: begin
            we=0;
            memWrite=0;
            memRead=0;
            ready= 0;
            regsrc=0;
            IRpdate=1;
            store=0;
            alusrc=0;
            ALUOP=0;
            if (opcode==3'b000) nstate=ADDALU;
            else if (opcode==3'b001) nstate=SUBALU;
            else if (opcode==3'b010) nstate=MULALU;
            else if (opcode==3'b011) nstate=DIVALU;
            else if (opcode==3'b100) nstate=LOADALU;
            else if (opcode==3'b101) nstate=STOREALU;
            end
            ADDALU: begin
            we=0;
            memWrite=0;
            memRead=0;
            ready= 0;
            regsrc=1;
            IRpdate=0;
            store=0;
            alusrc=1;
            ALUOP=0;
            nstate = ADDWB;
            end
            ADDWB: begin
            we=1;
            memWrite=0;
            memRead=0;
            ready= 1;
            regsrc=1;
            IRpdate=0;
            store=0;
            alusrc=1;
            ALUOP=0;
            nstate = IF;
            end
            SUBALU: begin
            we=0;
            memWrite=0;
            memRead=0;
            ready= 0;
            regsrc=1;
            IRpdate=0;
            store=0;
            alusrc=1;
            ALUOP=1;
            nstate = SUBWB;
            end
            SUBWB: begin
            we=1;
            memWrite=0;
            memRead=0;
            ready= 1;
            regsrc=1;
            IRpdate=0;
            store=0;
            alusrc=1;
            ALUOP=1;
            nstate = IF;
            end
            LOADALU: begin
            we=0;
            memWrite=0;
            memRead=1;
            ready= 0;
            regsrc=0;
            IRpdate=0;
            store=0;
            alusrc=0;
            ALUOP=0;
            nstate = LOADMEM;
            end
            LOADMEM: begin
            we=0;
            memWrite=0;
            memRead=1;
            ready= 0;
            regsrc=0;
            IRpdate=0;
            store=0;
            alusrc=0;
            ALUOP=0;
            nstate = LOADWB;
            end
            LOADWB: begin
            we=1;
            memWrite=0;
            memRead=0;
            ready= 1;
            regsrc=0;
            IRpdate=0;
            store=0;
            alusrc=0;
            ALUOP=0;
            nstate = IF;
            end
            STOREALU: begin
            we=0;
            memWrite=0;
            memRead=0;
            ready= 0;
            regsrc=0;
            IRpdate=0;
            store=1;
            alusrc=0;
            ALUOP=0;
            nstate = STOREMEM;
            end
            STOREMEM: begin
            we=0;
            memWrite=1;
            memRead=0;
            ready= 1;
            regsrc=0;
            IRpdate=0;
            store=1;
            alusrc=0;
            ALUOP=0;
            nstate = IF;
            end
            
            MULALU: begin
            we=0;
            memWrite=0;
            memRead=0;
            ready= 0;
            regsrc=1;
            IRpdate=0;
            store=0;
            alusrc=1;
            ALUOP=2'b10;
            if (counter>25)
                nstate = MULWB;
            else   
                nstate = MULALU;
            end
            MULWB: begin
            we=1;
            memWrite=0;
            memRead=0;
            ready= 1;
            regsrc=1;
            IRpdate=0;
            store=0;
            alusrc=1;
            ALUOP=2'b10;
            nstate = IF;
            end

            DIVALU: begin
            we=0;
            memWrite=0;
            memRead=0;
            ready= 0;
            regsrc=1;
            IRpdate=0;
            store=0;
            alusrc=1;
            ALUOP=2'b11;
            if (counter>25)
                nstate = DIVWB;
            else   
                nstate = DIVALU;
            end
            DIVWB: begin
            we=1;
            memWrite=0;
            memRead=0;
            ready= 1;
            regsrc=1;
            IRpdate=0;
            store=0;
            alusrc=1;
            ALUOP=2'b11;
            nstate = IF;
            end
        endcase
    end
endmodule