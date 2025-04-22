module instr_mem (
    input wire [15:0] addr,
    output wire [15:0] instruction
);
    reg [15:0] memory [0:255];

    initial begin
        // === Setup ===
        memory[0] = {2'b01, 4'd1, 8'd10, 2'b00};     // MOVI R1, 10
        memory[1] = {2'b01, 4'd2, 8'd20, 2'b00};     // MOVI R2, 20
        memory[2] = {2'b01, 4'd3, 8'd10, 2'b00};     // MOVI R3, 10

        // === ALU Operations ===
        memory[3] = {2'b00, 4'd4, 4'd1, 4'd2, 2'b00}; // ADD R4 = R1 + R2 = 30
        memory[4] = {2'b00, 4'd5, 4'd2, 4'd1, 2'b01}; // SUB R5 = R2 - R1 = 10
        memory[5] = {2'b00, 4'd6, 4'd1, 4'd2, 2'b10}; // AND R6 = R1 & R2
        memory[6] = {2'b00, 4'd7, 4'd1, 4'd2, 2'b11}; // OR  R7 = R1 | R2

        // === BEQ (R1 == R3) → branch to 9 ===
        memory[7] = {2'b11, 4'd9, 4'd1, 4'd3, 2'b00}; // BEQ R1 == R3 → jump to 9

        memory[8] = {2'b01, 4'd4, 8'd99, 2'b00}; // MOVI R4, 99 (should be skipped)

        // === Target of BEQ ===
        memory[9] = {2'b01, 4'd5, 8'd55, 2'b00}; // MOVI R5, 55

        memory[10] = {2'b11, 4'd12, 4'd1, 4'd2, 2'b01}; // BNE R1 != R2 → jump to 12

        memory[11] = {2'b01, 4'd6, 8'd88, 2'b00}; // MOVI R6, 88 (should be skipped)

        // === Target of BNE ===
        memory[12] = {2'b01, 4'd7, 8'd77, 2'b00};  // MOVI R7, 77

        memory[13] = {2'b10, 14'd15}; // JUMP to addr 15
        memory[14] = {2'b01, 4'd0, 8'd123, 2'b00}; // MOVI R0, 123 (should be skipped)

        // === Target of JUMP ===
        memory[15] = {2'b01, 4'd0, 8'd42, 2'b00}; // MOVI R0, 42

    end

    assign instruction = memory[addr];
endmodule
