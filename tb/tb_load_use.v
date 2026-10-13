
`timescale 1ns/1ps

module tb_load_use;

    reg clk;
    reg rst;

    integer stall_count;

    pipeline_top uut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    // Count clock edges at which the hazard detector requests a stall.
    always @(posedge clk) begin
        if (rst)
            stall_count = 0;
        else if (uut.stall)
            stall_count = stall_count + 1;
    end

    initial begin
        $dumpfile("sim/load_use.vcd");
        $dumpvars(0, tb_load_use);

        clk = 0;
        rst = 1;
        stall_count = 0;

        // Set a known nonzero value for lw x1, 0(x0).
        // This modifies only the simulation's data memory.
        #1;
        uut.dmem_inst.memory[0] = 32'd7;

        #11;
        rst = 0;

        // Allow the pipeline to execute the test program.
        #300;

        $display("");
        $display("======================================");
        $display("       LOAD-USE HAZARD TEST");
        $display("======================================");
        $display("Stall cycles = %0d", stall_count);
        $display("x1 = %0d", uut.rf_inst.regs[1]);
        $display("x2 = %0d", uut.rf_inst.regs[2]);
        $display("x3 = %0d", uut.rf_inst.regs[3]);
        $display("x4 = %0d", uut.rf_inst.regs[4]);
        $display("x5 = %0d", uut.rf_inst.regs[5]);
        $display("x6 = %0d", uut.rf_inst.regs[6]);

        if (stall_count >= 1)
            $display("PASS: A load-use stall occurred");
        else
            $display("FAIL: No load-use stall detected");

        if (uut.rf_inst.regs[1] == 7 &&
            uut.rf_inst.regs[2] == 14 &&
            uut.rf_inst.regs[3] == 21 &&
            uut.rf_inst.regs[4] == 5 &&
            uut.rf_inst.regs[5] == 26 &&
            uut.rf_inst.regs[6] == 35)
            $display("PASS: All expected register values match");
        else
            $display("FAIL: Register values do not match");

        $display("======================================");
        $finish;
    end

endmodule
