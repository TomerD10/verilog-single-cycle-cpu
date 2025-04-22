`timescale 1ns / 1ps

module cpu_tb;

    reg clk = 0;
    reg reset;

    // Instantiate the CPU
    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    // Generates a 10ns clock (5ns high, 5ns low)
    always #5 clk = ~clk;

    initial begin
        // Waveform dump for GTKWave
        $dumpfile("cpu.vcd");
        $dumpvars(0, cpu_tb);

        // Step 1: Apply reset
        reset = 1;
        #10;
        reset = 0;

        // Step 2: Let the CPU run
        #300;

        // Step 3: Check register values
        $display("R0 = %d", uut.datapath_inst.register_file_inst.regs[0]);  // 42
        $display("R1 = %d", uut.datapath_inst.register_file_inst.regs[1]);  // 10
        $display("R2 = %d", uut.datapath_inst.register_file_inst.regs[2]);  // 20
        $display("R3 = %d", uut.datapath_inst.register_file_inst.regs[3]);  // 10
        $display("R4 = %d", uut.datapath_inst.register_file_inst.regs[4]);  // 30
        $display("R5 = %d", uut.datapath_inst.register_file_inst.regs[5]);  // 55
        $display("R6 = %d", uut.datapath_inst.register_file_inst.regs[6]);  // 0
        $display("R7 = %d", uut.datapath_inst.register_file_inst.regs[7]);  // 77

        $finish;
    end

endmodule
