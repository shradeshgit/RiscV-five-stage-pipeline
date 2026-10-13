
`timescale 1ns/1ps

module tb_hazard_detection_unit;

    reg [4:0] id_ex_rd;
    reg id_ex_mem_read;
    reg [4:0] if_id_rs1;
    reg [4:0] if_id_rs2;

    wire stall;

    hazard_detection_unit dut (
        .id_ex_rd(id_ex_rd),
        .id_ex_mem_read(id_ex_mem_read),
        .if_id_rs1(if_id_rs1),
        .if_id_rs2(if_id_rs2),
        .stall(stall)
    );

    initial begin
        // Test 1: Load destination matches rs1
        id_ex_rd = 5'd5;
        id_ex_mem_read = 1'b1;
        if_id_rs1 = 5'd5;
        if_id_rs2 = 5'd2;
        #10;
        if (stall !== 1'b1)
            $fatal(1, "TEST 1 FAILED");
        $display("TEST 1 PASSED: rs1 dependency");

        // Test 2: Load destination matches rs2
        id_ex_rd = 5'd6;
        if_id_rs1 = 5'd1;
        if_id_rs2 = 5'd6;
        #10;
        if (stall !== 1'b1)
            $fatal(1, "TEST 2 FAILED");
        $display("TEST 2 PASSED: rs2 dependency");

        // Test 3: No dependency
        id_ex_rd = 5'd5;
        if_id_rs1 = 5'd1;
        if_id_rs2 = 5'd2;
        #10;
        if (stall !== 1'b0)
            $fatal(1, "TEST 3 FAILED");
        $display("TEST 3 PASSED: no dependency");

        // Test 4: x0 must not cause a stall
        id_ex_rd = 5'd0;
        if_id_rs1 = 5'd0;
        if_id_rs2 = 5'd0;
        #10;
        if (stall !== 1'b0)
            $fatal(1, "TEST 4 FAILED");
        $display("TEST 4 PASSED: x0 excluded");

        // Test 5: A non-load instruction must not stall
        id_ex_rd = 5'd5;
        id_ex_mem_read = 1'b0;
        if_id_rs1 = 5'd5;
        if_id_rs2 = 5'd2;
        #10;
        if (stall !== 1'b0)
            $fatal(1, "TEST 5 FAILED");
        $display("TEST 5 PASSED: non-load instruction");

        $display("ALL 5 HAZARD DETECTION TESTS PASSED");
        $finish;
    end

endmodule
