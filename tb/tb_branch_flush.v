
`timescale 1ns/1ps

module tb_branch_flush;

    reg clk;
    reg rst;

    pipeline_top uut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim/branch_flush.vcd");
        $dumpvars(0, tb_branch_flush);

        clk = 0;
        rst = 1;
// Initialize registers for deterministic simulation results.
for (integer i = 0; i < 32; i = i + 1)
    uut.rf_inst.regs[i] = 32'b0;

        #12;
        rst = 0;

        #200;

        $display("");
        $display("======= BRANCH FLUSH TEST =======");
        $display("x1 = %0d", uut.rf_inst.regs[1]);
        $display("x2 = %0d", uut.rf_inst.regs[2]);
        $display("x3 = %0d", uut.rf_inst.regs[3]);
        $display("x4 = %0d", uut.rf_inst.regs[4]);

        if (uut.rf_inst.regs[1] == 5 &&
            uut.rf_inst.regs[2] == 5 &&
            uut.rf_inst.regs[3] == 0 &&
            uut.rf_inst.regs[4] == 7)
            $display("PASS: Branch flush test");
        else
            $display("FAIL: Branch flush test");
$display("PC = %h", uut.pc_current);
$display("Instruction = %h", uut.instr);
$display("IF/ID instruction = %h", uut.if_id_instr);
$display("ID/EX instruction fields: rd=%0d, reg_write=%b, branch=%b",
         uut.id_ex_rd, uut.id_ex_reg_write, uut.id_ex_branch);

        $display("================================");
        $finish;
    end

endmodule
