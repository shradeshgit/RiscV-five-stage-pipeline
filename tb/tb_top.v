`timescale 1ns/1ps

module tb_top;

    reg clk;
    reg rst;

    // Instantiate Top-Level Processor (Unit Under Test)
    top uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock Generation (100MHz)
    always #5 clk = ~clk;

    // Test Sequence & Verification

    initial 
    begin
        // Configure waveform dumping
        $dumpfile("sim/top.vcd");
        $dumpvars(0, tb_top);

        // Reset sequence
        clk = 0;
        rst = 1;
        #20;
        rst = 0;

        // Run processor simulation
        #300;

        //----------------------------------
        // Register Assertions / Checks
        //----------------------------------
        if (uut.RF.regs[1] != 32'd5)
            $display("FAIL x1: Actual = %0d (Expected: 5)", uut.RF.regs[1]);
        else
            $display("PASS x1");

        if (uut.RF.regs[2] != 32'd10)
            $display("FAIL x2: Actual = %0d (Expected: 10)", uut.RF.regs[2]);
        else
            $display("PASS x2");

        if (uut.RF.regs[3] != 32'd15)
            $display("FAIL x3: Actual = %0d (Expected: 15)", uut.RF.regs[3]);
        else
            $display("PASS x3");

        if (uut.RF.regs[4] != 32'd15)
            $display("FAIL x4: Actual = %0d (Expected: 15)", uut.RF.regs[4]);
        else
            $display("PASS x4");

        if (uut.RF.regs[5] != 32'd0)
            $display("FAIL x5: Actual = %0d (Expected: 0)", uut.RF.regs[5]);
        else
            $display("PASS x5");

        if (uut.RF.regs[6] != 32'd999)
            $display("FAIL x6: Actual = %0d (Expected: 999)", uut.RF.regs[6]);
        else
            $display("PASS x6");

        $display("\nSimulation Finished.");
        #20;

        $display("\n===== Final Register Values =====");
        $display("x1 = %0d", uut.RF.regs[1]);
        $display("x2 = %0d", uut.RF.regs[2]);
        $display("x3 = %0d", uut.RF.regs[3]);
        $display("x4 = %0d", uut.RF.regs[4]);
        $display("x5 = %0d", uut.RF.regs[5]);
        $display("x6 = %0d", uut.RF.regs[6]);

        $finish;
    end

endmodule