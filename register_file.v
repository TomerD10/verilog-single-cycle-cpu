module register_file #(
    parameter WIDTH = 8, // Width of each register 
    parameter DEPTH = 8  // Number of registers
) (
    input wire clk,
    input wire write_en, // Write enable signal
    input wire [$clog2(DEPTH) - 1:0] write_addr, // Address to write to
    input wire [WIDTH - 1:0] write_data, // Data to write
    input wire [$clog2(DEPTH) - 1:0] read_addr1, // First read address
    input wire [$clog2(DEPTH) - 1:0] read_addr2, // Second read address
    output wire [WIDTH - 1:0] read_data1, // Output of first read
    output wire [WIDTH - 1:0] read_data2  // Output of second read
);

    // Register array: DEPTH registers, each WIDTH bits wide
    reg [WIDTH - 1:0] regs [0:DEPTH - 1];

    // Asynchronous reads: data is available immediately when address changes
    assign read_data1 = regs[read_addr1];
    assign read_data2 = regs[read_addr2];

    // Synchronous write
    always @(posedge clk) begin
        if (write_en) begin
            regs[write_addr] <= write_data; // Write data into selected register
        end
    end

endmodule
