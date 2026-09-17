`timescale 1ns/1ps

module tb_pipeline_top;

    reg clk;
    reg rst;

    // ============================================================
    // DUT
    // ============================================================

    pipeline_top uut (
        .clk(clk),
        .rst(rst)
    );


    // ============================================================
    // CLOCK
    // ============================================================

    always #5 clk = ~clk;


    // ============================================================
    // TEST
    // ============================================================

    initial begin

        // VCD file
        $dumpfile("sim/pipeline.vcd");
        $dumpvars(0, tb_pipeline_top);

        // Initial values
        clk = 0;
        rst = 1;

        // Hold reset
        #12;

        rst = 0;

        // Run pipeline
        #300;

        $display("");
        $display("======================================");
        $display("      PIPELINE SIMULATION FINISHED");
        $display("======================================");

        $display("");
        $display("Final Register Values:");

        $display("x1 = %d", uut.rf_inst.regs[1]);
        $display("x2 = %d", uut.rf_inst.regs[2]);
        $display("x3 = %d", uut.rf_inst.regs[3]);
        $display("x4 = %d", uut.rf_inst.regs[4]);
        $display("x5 = %d", uut.rf_inst.regs[5]);
        $display("x6 = %d", uut.rf_inst.regs[6]);

        $display("");
        $display("======================================");

        $finish;

    end

endmodule