
module instr_memory (
    input wire [31:0] addr,
    output wire [31:0] instr
);

    reg [31:0] rom [0:1023];
    integer i;

    initial begin
        for (i = 0; i < 1024; i = i + 1)
            rom[i] = 32'h00000013;

        $readmemh("tests/load_use_program.hex", rom);
    end

    assign instr = rom[addr[11:2]];

endmodule
