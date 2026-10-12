
`timescale 1ns/1ps

module tb_forwarding_unit;

    reg [4:0] id_ex_rs1;
    reg [4:0] id_ex_rs2;

    reg [4:0] ex_mem_rd;
    reg [4:0] mem_wb_rd;

    reg ex_mem_reg_write;
    reg mem_wb_reg_write;

    wire [1:0] forward_a;
    wire [1:0] forward_b;

    forwarding_unit dut (
        .id_ex_rs1(id_ex_rs1),
        .id_ex_rs2(id_ex_rs2),
        .ex_mem_rd(ex_mem_rd),
        .mem_wb_rd(mem_wb_rd),
        .ex_mem_reg_write(ex_mem_reg_write),
        .mem_wb_reg_write(mem_wb_reg_write),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    initial begin

        // Initialize all inputs
        id_ex_rs1 = 0;
        id_ex_rs2 = 0;
        ex_mem_rd = 0;
        mem_wb_rd = 0;
        ex_mem_reg_write = 0;
        mem_wb_reg_write = 0;

        #10;

        // Test 1: No hazard
        id_ex_rs1 = 5;
        id_ex_rs2 = 6;

        #10;
        if (forward_a !== 2'b00 ||
            forward_b !== 2'b00)
            $fatal(1, "TEST 1 FAILED: No hazard");

        $display("TEST 1 PASSED: No hazard");

        // Test 2: Forward operand A from EX/MEM
        ex_mem_rd = 5;
        ex_mem_reg_write = 1;

        #10;
        if (forward_a !== 2'b10)
            $fatal(1, "TEST 2 FAILED: EX/MEM A");

        $display("TEST 2 PASSED: EX/MEM forwards A");

        // Test 3: Forward operand B from MEM/WB
        ex_mem_rd = 0;
        ex_mem_reg_write = 0;
        mem_wb_rd = 6;
        mem_wb_reg_write = 1;

        #10;
        if (forward_b !== 2'b01)
            $fatal(1, "TEST 3 FAILED: MEM/WB B");

        $display("TEST 3 PASSED: MEM/WB forwards B");

        // Test 4: EX/MEM must win if both stages match
        ex_mem_rd = 5;
        ex_mem_reg_write = 1;
        mem_wb_rd = 5;
        mem_wb_reg_write = 1;

        #10;
        if (forward_a !== 2'b10)
            $fatal(1, "TEST 4 FAILED: Priority");

        $display("TEST 4 PASSED: EX/MEM has priority");

        // Test 5: Never forward a write to x0
        id_ex_rs1 = 0;
        ex_mem_rd = 0;
        mem_wb_rd = 0;
        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;

        #10;
        if (forward_a !== 2'b00)
            $fatal(1, "TEST 5 FAILED: x0");

        $display("TEST 5 PASSED: x0 is not forwarded");

        // Test 6: Both operands forward from different stages
        id_ex_rs1 = 5;
        id_ex_rs2 = 6;

        ex_mem_rd = 5;
        mem_wb_rd = 6;
        ex_mem_reg_write = 1;
        mem_wb_reg_write = 1;

        #10;
        if (forward_a !== 2'b10 ||
            forward_b !== 2'b01)
            $fatal(1, "TEST 6 FAILED: Both operands");

        $display("TEST 6 PASSED: Both operands forwarded");

        $display("--------------------------------");
        $display("ALL 6 FORWARDING TESTS PASSED");
        $display("--------------------------------");

        $finish;
    end

endmodule
