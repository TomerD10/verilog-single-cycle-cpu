module pc (
    input wire clk,
    input wire reset,
    input wire jump_en, // Jump enable signal
    input wire [15:0] jump_addr, // Jump target address
    output reg [15:0] pc_out  // Current program counter value
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_out <= 16'd0; // Reset PC to 0 on reset
        else if (jump_en)
            pc_out <= jump_addr; // If jump is enabled, go to jump address
        else
            pc_out <= pc_out + 1;  // Default: increment PC to next instruction
    end

endmodule
