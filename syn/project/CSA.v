module CSA (
    input [15:0] A,B,
    input CIN,
    output [15:0] S,
    output COUT 
);
    reg ONE= 1;
    reg Zero = 0;
    wire [3:0] RealCarry;
    // first part of CSA
    wire [3:0] xor_First, and_abFirst, and_xorab_cinFirst;
    wire [3:0] sumFirst,coutFirst;
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : firstPart
            if (i == 0) begin
                xor (xor_First[i], A[i], B[i]);
                xor (sumFirst[i], xor_First[i], CIN);
                and (and_abFirst[i], A[i], B[i]);
                and (and_xorab_cinFirst[i], xor_First[i], CIN);
                or  (coutFirst[i], and_abFirst[i], and_xorab_cinFirst[i]);
            end else begin
                xor (xor_First[i], A[i], B[i]);
                xor (sumFirst[i], xor_First[i], coutFirst[i-1]);
                and (and_abFirst[i], A[i], B[i]);
                and (and_xorab_cinFirst[i], xor_First[i], coutFirst[i-1]);
                or  (coutFirst[i], and_abFirst[i], and_xorab_cinFirst[i]);
            end
        end
    endgenerate
    wire [3:0] xor_0 [0:3];
    wire [3:0] and_ab0 [0:3];
    wire [3:0] and_xorab_cin0 [0:3];
    wire [3:0] sum0[0:3];
    wire [3:0] cout0[0:3];
    genvar j;
    generate
        for (j = 1; j < 4; j = j + 1) begin : ZeroParts
            for (i = 0; i < 4; i = i + 1) begin :zeropppp
                if (i == 0) begin
                    xor (xor_0[j][i], A[4 *j + i], B[4 *j + i]);
                    xor (sum0[j][i], xor_0[j][i], Zero);
                    and (and_ab0[j][i], A[4 *j + i], B[4 *j + i]);
                    and (and_xorab_cin0[j][i], xor_0[j][i], Zero);
                    or  (cout0[j][i], and_ab0[j][i], and_xorab_cin0[j][i]);
                end else begin
                    xor (xor_0[j][i], A[4 *j + i], B[4 *j + i]);
                    xor (sum0[j][i], xor_0[j][i], cout0[j][i-1]);
                    and (and_ab0[j][i], A[4 *j + i], B[4 *j + i]);
                    and (and_xorab_cin0[j][i], xor_0[j][i], cout0[j][i-1]);
                    or  (cout0[j][i], and_ab0[j][i], and_xorab_cin0[j][i]);
                end
            end
        end
    endgenerate
    wire [3:0] xor_1 [0:3];
    wire [3:0] and_ab1 [0:3];
    wire [3:0] and_xorab_cin1 [0:3];
    wire [3:0] sum1[0:3];
    wire [3:0] cout1[0:3];
    generate
        for (j = 1; j < 4; j = j + 1) begin : OneParts
            for (i = 0; i < 4; i = i + 1) begin :oneeeeeee
                if (i == 0) begin
                    xor (xor_1[j][i], A[4 *j + i], B[4 *j + i]);
                    xor (sum1[j][i], xor_1[j][i], ONE);
                    and (and_ab1[j][i], A[4 *j + i], B[4 *j + i]);
                    and (and_xorab_cin1[j][i], xor_1[j][i], ONE);
                    or  (cout1[j][i], and_ab1[j][i], and_xorab_cin1[j][i]);
                end else begin
                    xor (xor_1[j][i], A[4 *j + i], B[4 *j + i]);
                    xor (sum1[j][i], xor_1[j][i], cout1[j][i-1]);
                    and (and_ab1[j][i], A[4 *j + i], B[4 *j + i]);
                    and (and_xorab_cin1[j][i], xor_1[j][i], cout1[j][i-1]);
                    or  (cout1[j][i], and_ab1[j][i], and_xorab_cin1[j][i]);
                end
            end
        end
    endgenerate
    assign RealCarry[0] = coutFirst[3];
    assign S[3:0] = sumFirst;

    assign RealCarry[1] = (RealCarry[0]) ? cout1[1][3] : cout0[1][3];
    assign S[7:4] = (RealCarry[0]) ? sum1[1] : sum0[1];

    assign RealCarry[2] = (RealCarry[1]) ? cout1[2][3] : cout0[2][3];
    assign S[11:8] =  (RealCarry[1]) ? sum1[2] : sum0[2];

    assign RealCarry[3] = (RealCarry[2]) ? cout1[3][3] : cout0[3][3];
    assign S[15:12] =  (RealCarry[2]) ? sum1[3] : sum0[3];

    assign COUT = RealCarry[3];
endmodule