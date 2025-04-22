module cpu (
    input wire clk, 
    input wire reset  
);

    wire [15:0] pc_out; // Output of Program Counter (PC)
    wire [15:0] instruction; // Current instruction fetched from memory

    wire [7:0] alu_result; // Output of ALU
    wire zero, carry, overflow; // ALU flags
    wire [7:0] read_data1, read_data2; // Register values

    // === Instruction decoding ===
    wire [1:0] instr_type = instruction[15:14]; // Type of instruction
    wire [3:0] dest  = instruction[13:10]; // Destination register or branch addr
    wire [3:0] src1  = instruction[9:6]; // Source register 1
    wire [3:0] src2  = instruction[5:2]; // Source register 2
    wire [1:0] func  = instruction[1:0]; // Function code: ALUop or branch condition

    // === Instruction type flags ===
    wire is_jump = (instr_type == 2'b10); // 2'b10 means JUMP
    wire is_beq  = (instr_type == 2'b11 && func == 2'b00); // BEQ: Branch if equal
    wire is_bne  = (instr_type == 2'b11 && func == 2'b01); // BNE: Branch if not equal

    // === Branch condition logic ===
    wire branch_condition =
        (is_beq && (read_data1 == read_data2)) || // Take BEQ if equal
        (is_bne && (read_data1 != read_data2)); // Take BNE if not equal

    // === Final jump signal ===
    wire jump_en = is_jump || branch_condition; // Jump if unconditional or branch taken

    // === Jump target address logic ===
    // For JUMP: 14-bit absolute address (zero-extended to 16 bits)
    // For BEQ/BNE: use dest field as target (lower 4 bits, zero-extended to 16 bits)
    wire [15:0] jump_addr = is_jump ? {2'b00, instruction[13:0]} : {12'b0, dest};

    // === Program Counter ===
    pc pc_inst (
        .clk(clk),
        .reset(reset),
        .jump_en(jump_en), // Enables PC update to jump address
        .jump_addr(jump_addr), // Targets address to jump to
        .pc_out(pc_out) // Current instruction address
    );

    // === Instruction Memory ===
    instr_mem instr_mem_inst (
        .addr(pc_out), // Fetch instruction at current PC
        .instruction(instruction) // Output fetched instruction
    );

    // === Datapath (ALU + Register File + Write Logic) ===
    datapath datapath_inst (
        .clk(clk),
        .write_en(1'b1), // Always enable register write
        .instruction(instruction),  // 16-bit instruction input
        .alu_result(alu_result), // Result from ALU or immediate
        .zero(zero),                  
        .carry(carry),          
        .overflow(overflow),      
        .read_data1(read_data1),      
        .read_data2(read_data2)
    );

endmodule
