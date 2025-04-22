module datapath #(
    parameter WIDTH = 8, // Bit width of registers and ALU
    parameter DEPTH = 16  // Number of registers
)(
    input wire clk,
    input wire write_en, // Write enable signal from control
    input wire [15:0] instruction, // Full 16-bit instruction

    output wire [WIDTH-1:0] alu_result, // Final ALU result or immediate
    output wire zero, // Zero flag from ALU
    output wire carry, // Carry flag from ALU
    output wire overflow, // Overflow flag from ALU

    output wire [WIDTH-1:0] read_data1, // Source register 1 (for BEQ/BNE)
    output wire [WIDTH-1:0] read_data2  // Source register 2 (for BEQ/BNE)
);

    // === Instruction Decoding ===
    wire [1:0] instr_type = instruction[15:14]; // Top 2 bits determine type: 00=ALU, 01=MOVI
    wire [3:0] dest = instruction[13:10]; // Destination register index
    wire [3:0] src1 = instruction[9:6]; // First source register index
    wire [3:0] src2 = instruction[5:2]; // Second source register index
    wire [1:0] func = instruction[1:0]; // Operation code (ALUop or branch type)
    wire [7:0] imm = instruction[9:2]; // Immediate value (for MOVI)

    // === ALU Instantiation ===
    wire [WIDTH-1:0] alu_out;

    alu alu_inst (
        .A(read_data1), // First operand from register file
        .B(read_data2), // Second operand from register file
        .ALUop(func), // Operation selector (ADD, SUB, AND, OR)
        .result(alu_out),
        .zero(zero),
        .carry(carry),
        .overflow(overflow)
    );

    // === Register File Instantiation ===
    // Provides register read and write functionality
    register_file #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) register_file_inst (
        .clk(clk),
        .write_en(write_en), // Enable write when signaled by control
        .write_addr(dest),  // Target register to write
        .write_data((instr_type == 2'b01) ? imm : alu_out), // Write immediate or ALU result based on condition
        .read_addr1(src1),
        .read_addr2(src2),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // === ALU Result Output ===
    // Based on condition, output imm or ALU. 
    assign alu_result = (instr_type == 2'b01) ? imm : alu_out;

endmodule
