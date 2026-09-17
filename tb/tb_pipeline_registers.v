`timescale 1ns/1ps

module tb_pipeline_registers;

    reg clk;
    reg rst;

    integer errors;

    // ============================================================
    // IF/ID SIGNALS
    // ============================================================

    reg  [31:0] if_pc_in;
    reg  [31:0] if_instr_in;

    wire [31:0] if_pc_out;
    wire [31:0] if_instr_out;


    // ============================================================
    // ID/EX SIGNALS
    // ============================================================

    reg        id_reg_write_in;
    reg        id_mem_to_reg_in;
    reg        id_mem_write_in;
    reg        id_mem_read_in;
    reg        id_branch_in;
    reg        id_alu_src_in;
    reg        id_jump_in;

    reg [1:0]  id_alu_op_in;

    reg [31:0] id_pc_in;
    reg [31:0] id_rd1_in;
    reg [31:0] id_rd2_in;
    reg [31:0] id_imm_in;

    reg [4:0]  id_rs1_in;
    reg [4:0]  id_rs2_in;
    reg [4:0]  id_rd_in;

    reg [2:0]  id_funct3_in;
    reg [6:0]  id_funct7_in;


    wire       id_reg_write_out;
    wire       id_mem_to_reg_out;
    wire       id_mem_write_out;
    wire       id_mem_read_out;
    wire       id_branch_out;
    wire       id_alu_src_out;
    wire       id_jump_out;

    wire [1:0]  id_alu_op_out;

    wire [31:0] id_pc_out;
    wire [31:0] id_rd1_out;
    wire [31:0] id_rd2_out;
    wire [31:0] id_imm_out;

    wire [4:0]  id_rs1_out;
    wire [4:0]  id_rs2_out;
    wire [4:0]  id_rd_out;

    wire [2:0]  id_funct3_out;
    wire [6:0]  id_funct7_out;


    // ============================================================
    // EX/MEM SIGNALS
    // ============================================================

    reg [31:0] ex_alu_result_in;
    reg [31:0] ex_rd2_in;
    reg [31:0] ex_pc_target_in;

    reg        ex_zero_in;

    reg [4:0]  ex_rd_in;

    reg        ex_reg_write_in;
    reg        ex_mem_read_in;
    reg        ex_mem_write_in;
    reg        ex_mem_to_reg_in;
    reg        ex_branch_taken_in;


    wire [31:0] ex_alu_result_out;
    wire [31:0] ex_rd2_out;
    wire [31:0] ex_pc_target_out;

    wire        ex_zero_out;

    wire [4:0]  ex_rd_out;

    wire        ex_reg_write_out;
    wire        ex_mem_read_out;
    wire        ex_mem_write_out;
    wire        ex_mem_to_reg_out;
    wire        ex_branch_taken_out;


    // ============================================================
    // MEM/WB SIGNALS
    // ============================================================

    reg [31:0] mem_read_data_in;
    reg [31:0] mem_alu_result_in;

    reg [4:0]  mem_rd_in;

    reg        mem_reg_write_in;
    reg        mem_to_reg_in;


    wire [31:0] mem_read_data_out;
    wire [31:0] mem_alu_result_out;

    wire [4:0]  mem_rd_out;

    wire        mem_reg_write_out;
    wire        mem_to_reg_out;


    // ============================================================
    // INSTANTIATE IF/ID
    // ============================================================

    if_id IF_ID (
        .clk(clk),
        .rst(rst),

        .pc_in(if_pc_in),
        .instr_in(if_instr_in),

        .pc_out(if_pc_out),
        .instr_out(if_instr_out)
    );


    // ============================================================
    // INSTANTIATE ID/EX
    // ============================================================

    id_ex ID_EX (
        .clk(clk),
        .rst(rst),

        .reg_write_in(id_reg_write_in),
        .mem_to_reg_in(id_mem_to_reg_in),
        .mem_write_in(id_mem_write_in),
        .mem_read_in(id_mem_read_in),
        .branch_in(id_branch_in),
        .alu_src_in(id_alu_src_in),
        .jump_in(id_jump_in),
        .alu_op_in(id_alu_op_in),

        .pc_in(id_pc_in),
        .rd1_in(id_rd1_in),
        .rd2_in(id_rd2_in),
        .imm_in(id_imm_in),

        .rs1_in(id_rs1_in),
        .rs2_in(id_rs2_in),
        .rd_in(id_rd_in),

        .funct3_in(id_funct3_in),
        .funct7_in(id_funct7_in),

        .reg_write_out(id_reg_write_out),
        .mem_to_reg_out(id_mem_to_reg_out),
        .mem_write_out(id_mem_write_out),
        .mem_read_out(id_mem_read_out),
        .branch_out(id_branch_out),
        .alu_src_out(id_alu_src_out),
        .jump_out(id_jump_out),
        .alu_op_out(id_alu_op_out),

        .pc_out(id_pc_out),
        .rd1_out(id_rd1_out),
        .rd2_out(id_rd2_out),
        .imm_out(id_imm_out),

        .rs1_out(id_rs1_out),
        .rs2_out(id_rs2_out),
        .rd_out(id_rd_out),

        .funct3_out(id_funct3_out),
        .funct7_out(id_funct7_out)
    );


    // ============================================================
    // INSTANTIATE EX/MEM
    // ============================================================

    ex_mem EX_MEM (
        .clk(clk),
        .rst(rst),

        .alu_result_in(ex_alu_result_in),
        .rd2_in(ex_rd2_in),
        .pc_target_in(ex_pc_target_in),

        .zero_in(ex_zero_in),

        .rd_in(ex_rd_in),

        .reg_write_in(ex_reg_write_in),
        .mem_read_in(ex_mem_read_in),
        .mem_write_in(ex_mem_write_in),
        .mem_to_reg_in(ex_mem_to_reg_in),
        .branch_taken_in(ex_branch_taken_in),

        .alu_result_out(ex_alu_result_out),
        .rd2_out(ex_rd2_out),
        .pc_target_out(ex_pc_target_out),

        .zero_out(ex_zero_out),

        .rd_out(ex_rd_out),

        .reg_write_out(ex_reg_write_out),
        .mem_read_out(ex_mem_read_out),
        .mem_write_out(ex_mem_write_out),
        .mem_to_reg_out(ex_mem_to_reg_out),
        .branch_taken_out(ex_branch_taken_out)
    );


    // ============================================================
    // INSTANTIATE MEM/WB
    // ============================================================

    mem_wb MEM_WB (
        .clk(clk),
        .rst(rst),

        .read_data_in(mem_read_data_in),
        .alu_result_in(mem_alu_result_in),

        .rd_in(mem_rd_in),

        .reg_write_in(mem_reg_write_in),
        .mem_to_reg_in(mem_to_reg_in),

        .read_data_out(mem_read_data_out),
        .alu_result_out(mem_alu_result_out),

        .rd_out(mem_rd_out),

        .reg_write_out(mem_reg_write_out),
        .mem_to_reg_out(mem_to_reg_out)
    );


    // ============================================================
    // CLOCK
    // ============================================================

    always #5 clk = ~clk;


    // ============================================================
    // TEST PROCEDURE
    // ============================================================

    initial begin

        $dumpfile("sim/pipeline_registers.vcd");
        $dumpvars(0, tb_pipeline_registers);

        clk = 0;
        rst = 1;

        errors = 0;


        // --------------------------------------------------------
        // Initialize all inputs
        // --------------------------------------------------------

        if_pc_in = 0;
        if_instr_in = 0;

        id_reg_write_in = 0;
        id_mem_to_reg_in = 0;
        id_mem_write_in = 0;
        id_mem_read_in = 0;
        id_branch_in = 0;
        id_alu_src_in = 0;
        id_jump_in = 0;
        id_alu_op_in = 0;

        id_pc_in = 0;
        id_rd1_in = 0;
        id_rd2_in = 0;
        id_imm_in = 0;

        id_rs1_in = 0;
        id_rs2_in = 0;
        id_rd_in = 0;

        id_funct3_in = 0;
        id_funct7_in = 0;


        ex_alu_result_in = 0;
        ex_rd2_in = 0;
        ex_pc_target_in = 0;
        ex_zero_in = 0;
        ex_rd_in = 0;

        ex_reg_write_in = 0;
        ex_mem_read_in = 0;
        ex_mem_write_in = 0;
        ex_mem_to_reg_in = 0;
        ex_branch_taken_in = 0;


        mem_read_data_in = 0;
        mem_alu_result_in = 0;
        mem_rd_in = 0;
        mem_reg_write_in = 0;
        mem_to_reg_in = 0;


        // --------------------------------------------------------
        // RESET TEST
        // --------------------------------------------------------

        #10;

        if (if_pc_out !== 32'b0 ||
            if_instr_out !== 32'h00000013) begin

            $display("FAIL : IF/ID reset");
            errors = errors + 1;

        end
        else begin

            $display("PASS : IF/ID reset");

        end


        if (id_pc_out !== 32'b0 ||
            id_rd_out !== 5'b0 ||
            id_reg_write_out !== 1'b0) begin

            $display("FAIL : ID/EX reset");
            errors = errors + 1;

        end
        else begin

            $display("PASS : ID/EX reset");

        end


        if (ex_alu_result_out !== 32'b0 ||
            ex_rd_out !== 5'b0 ||
            ex_reg_write_out !== 1'b0) begin

            $display("FAIL : EX/MEM reset");
            errors = errors + 1;

        end
        else begin

            $display("PASS : EX/MEM reset");

        end


        if (mem_read_data_out !== 32'b0 ||
            mem_alu_result_out !== 32'b0 ||
            mem_rd_out !== 5'b0 ||
            mem_reg_write_out !== 1'b0) begin

            $display("FAIL : MEM/WB reset");
            errors = errors + 1;

        end
        else begin

            $display("PASS : MEM/WB reset");

        end


        // Release reset
        rst = 0;


        // --------------------------------------------------------
        // APPLY TEST DATA
        // --------------------------------------------------------

        if_pc_in = 32'h00000010;
        if_instr_in = 32'h00A00093;

        id_reg_write_in = 1;
        id_mem_to_reg_in = 0;
        id_mem_write_in = 0;
        id_mem_read_in = 0;
        id_branch_in = 0;
        id_alu_src_in = 1;
        id_jump_in = 0;
        id_alu_op_in = 2'b10;

        id_pc_in = 32'h00000010;
        id_rd1_in = 32'd5;
        id_rd2_in = 32'd10;
        id_imm_in = 32'd10;

        id_rs1_in = 5'd1;
        id_rs2_in = 5'd2;
        id_rd_in = 5'd3;

        id_funct3_in = 3'b000;
        id_funct7_in = 7'b0000000;


        ex_alu_result_in = 32'd15;
        ex_rd2_in = 32'd10;
        ex_pc_target_in = 32'h00000020;

        ex_zero_in = 0;

        ex_rd_in = 5'd3;

        ex_reg_write_in = 1;
        ex_mem_read_in = 0;
        ex_mem_write_in = 0;
        ex_mem_to_reg_in = 0;
        ex_branch_taken_in = 0;


        mem_read_data_in = 32'd100;
        mem_alu_result_in = 32'd15;

        mem_rd_in = 5'd3;

        mem_reg_write_in = 1;
        mem_to_reg_in = 0;


        // --------------------------------------------------------
        // WAIT FOR CLOCK
        // --------------------------------------------------------

        @(posedge clk);
        #1;


        // --------------------------------------------------------
        // IF/ID TEST
        // --------------------------------------------------------

        if (if_pc_out == 32'h00000010 &&
            if_instr_out == 32'h00A00093) begin

            $display("PASS : IF/ID data propagation");

        end
        else begin

            $display("FAIL : IF/ID data propagation");
            errors = errors + 1;

        end


        // --------------------------------------------------------
        // ID/EX TEST
        // --------------------------------------------------------

        if (id_pc_out == 32'h00000010 &&
            id_rd1_out == 32'd5 &&
            id_rd2_out == 32'd10 &&
            id_imm_out == 32'd10 &&
            id_rs1_out == 5'd1 &&
            id_rs2_out == 5'd2 &&
            id_rd_out == 5'd3 &&
            id_reg_write_out == 1'b1 &&
            id_alu_src_out == 1'b1 &&
            id_alu_op_out == 2'b10) begin

            $display("PASS : ID/EX data and control propagation");

        end
        else begin

            $display("FAIL : ID/EX data and control propagation");
            errors = errors + 1;

        end


        // --------------------------------------------------------
        // EX/MEM TEST
        // --------------------------------------------------------

        if (ex_alu_result_out == 32'd15 &&
            ex_rd2_out == 32'd10 &&
            ex_pc_target_out == 32'h00000020 &&
            ex_rd_out == 5'd3 &&
            ex_reg_write_out == 1'b1 &&
            ex_mem_read_out == 1'b0 &&
            ex_mem_write_out == 1'b0 &&
            ex_mem_to_reg_out == 1'b0) begin

            $display("PASS : EX/MEM data and control propagation");

        end
        else begin

            $display("FAIL : EX/MEM data and control propagation");
            errors = errors + 1;

        end


        // --------------------------------------------------------
        // MEM/WB TEST
        // --------------------------------------------------------

        if (mem_read_data_out == 32'd100 &&
            mem_alu_result_out == 32'd15 &&
            mem_rd_out == 5'd3 &&
            mem_reg_write_out == 1'b1 &&
            mem_to_reg_out == 1'b0) begin

            $display("PASS : MEM/WB data and control propagation");

        end
        else begin

            $display("FAIL : MEM/WB data and control propagation");
            errors = errors + 1;

        end


        // --------------------------------------------------------
        // FINAL RESULT
        // --------------------------------------------------------

        #10;

        $display("");
        $display("========================================");
        $display("       PHASE 2 VERIFICATION");
        $display("========================================");

        if (errors == 0) begin

            $display("ALL PHASE 2 TESTS PASSED");

        end
        else begin

            $display("PHASE 2 FAILED");
            $display("Number of errors = %0d", errors);

        end

        $display("========================================");

        $finish;

    end

endmodule