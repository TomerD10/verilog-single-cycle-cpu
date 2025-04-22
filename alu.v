module alu (
    input wire [7:0] A,
    input wire [7:0] B, 
    input wire [1:0] ALUop, // ALU operation selector
    output reg [7:0] result, // ALU result
    output wire zero, // Zero flag (1 if result == 0)
    output reg carry, // Carry-out flag (for ADD/SUB)
    output reg overflow // Overflow flag (for signed operations)
);

    always @(*) begin
        // Reset carry and overflow before each operation
        carry = 0;  
        overflow = 0;

        case (ALUop)
        // ADD
            2'b00: begin
                {carry, result} = A + B; // Carry is MSB of 9-bit sum
                // Checks for overflow : if A and B have same sign but result has different sign
                overflow = (~A[7] & ~B[7] & result[7]) | (A[7] & B[7] & ~result[7]);
            end

        // SUB
            2'b01: begin 
                {carry, result} = A - B; // Carry = borrow bit
                // Checks for overflow : if A and B have different signs and result flips sign
                overflow = (~A[7] & B[7] & result[7]) | (A[7] & ~B[7] & ~result[7]);
            end

            2'b10: result = A & B; // AND operation
            2'b11: result = A | B; // OR operation

            default: result = 8'b00000000; // Default case (invalid ALUop)
        endcase
    end

    // Zero flag: Set if result is all zeros
    assign zero = (result == 8'b00000000);

endmodule
