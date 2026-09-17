module instr_memory (
    input wire [31:0] addr,
    output wire [31:0] instr
);

    // 1024 words = 4 KB
    reg [31:0] rom [0:1023];

    integer i;

    initial begin

        // Fill unused memory with NOP
        for (i = 0; i < 1024; i = i + 1)
            rom[i] = 32'h00000013;

        // Load test program
        $readmemh("tests/program.hex", rom);

    end

    // Word-aligned instruction address
    assign instr = rom[addr[11:2]];

endmodule