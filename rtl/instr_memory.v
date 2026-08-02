module instr_memory(

    input  wire [31:0] addr,
    output wire [31:0] instr

);

    // 1024 x 32-bit instruction memory
    reg [31:0] rom [0:1023];

integer i;
    // Load instructions from HEX file
    initial begin
        for(i=0;i<1024;i=i+1)
        rom[i]=32'h00000013;

        $readmemh("tests/program.hex", rom);
    end

    // Word-aligned instruction fetch
    assign instr = rom[addr[11:2]];

endmodule