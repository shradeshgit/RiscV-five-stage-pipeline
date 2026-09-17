module pipeline_top (
    input wire clk,
    input wire rst
);

    // ============================================================
    // FETCH STAGE
    // ============================================================

    wire [31:0] pc_current;
    wire [31:0] pc_next;
    wire [31:0] pc_plus_4;

    wire [31:0] instr;

    assign pc_plus_4 = pc_current + 32'd4;


    // ============================================================
    // IF/ID PIPELINE REGISTER OUTPUTS
    // ============================================================

    wire [31:0] if_id_pc;
    wire [31:0] if_id_instr;


    // ============================================================
    // DECODE STAGE
    // ============================================================

    wire [31:0] rd1;
    wire [31:0] rd2;
    wire [31:0] imm_out;

    wire reg_write;
    wire mem_to_reg;
    wire mem_write;
    wire mem_read;
    wire branch;
    wire alu_src;
    wire jump;

    wire [1:0] alu_op;


    // ============================================================
    // ID/EX PIPELINE REGISTER OUTPUTS
    // ============================================================

    wire id_ex_reg_write;
    wire id_ex_mem_to_reg;
    wire id_ex_mem_write;
    wire id_ex_mem_read;
    wire id_ex_branch;
    wire id_ex_alu_src;
    wire id_ex_jump;

    wire [1:0] id_ex_alu_op;

    wire [31:0] id_ex_pc;
    wire [31:0] id_ex_rd1;
    wire [31:0] id_ex_rd2;
    wire [31:0] id_ex_imm;

    wire [4:0] id_ex_rs1;
    wire [4:0] id_ex_rs2;
    wire [4:0] id_ex_rd;

    wire [2:0] id_ex_funct3;
    wire [6:0] id_ex_funct7;


    // ============================================================
    // EXECUTE STAGE
    // ============================================================

    wire [31:0] alu_input_b;
    wire [31:0] alu_result;
    wire alu_zero;

    reg [3:0] alu_ctrl;

    wire [31:0] branch_target;
    wire branch_taken;


    // ============================================================
    // EX/MEM PIPELINE REGISTER OUTPUTS
    // ============================================================

    wire [31:0] ex_mem_alu_result;
    wire [31:0] ex_mem_rd2;
    wire [31:0] ex_mem_pc_target;

    wire ex_mem_zero;

    wire [4:0] ex_mem_rd;

    wire ex_mem_reg_write;
    wire ex_mem_mem_read;
    wire ex_mem_mem_write;
    wire ex_mem_mem_to_reg;
    wire ex_mem_branch_taken;


    // ============================================================
    // MEMORY STAGE
    // ============================================================

    wire [31:0] mem_read_data;


    // ============================================================
    // MEM/WB PIPELINE REGISTER OUTPUTS
    // ============================================================

    wire [31:0] mem_wb_read_data;
    wire [31:0] mem_wb_alu_result;

    wire [4:0] mem_wb_rd;

    wire mem_wb_reg_write;
    wire mem_wb_mem_to_reg;


    // ============================================================
    // WRITEBACK STAGE
    // ============================================================

    wire [31:0] write_back_data;

    assign write_back_data =
        mem_wb_mem_to_reg ?
        mem_wb_read_data :
        mem_wb_alu_result;


    // ============================================================
    // PC / NEXT PC LOGIC
    // ============================================================

    assign branch_target = id_ex_pc + id_ex_imm;

    assign branch_taken =
        id_ex_branch & alu_zero;

    assign pc_next =
        branch_taken ?
        branch_target :
        pc_plus_4;


    // ============================================================
    // PC
    // ============================================================

    pc pc_inst (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_next),
        .pc_out(pc_current)
    );


    // ============================================================
    // INSTRUCTION MEMORY
    // ============================================================

    instr_memory imem_inst (
        .addr(pc_current),
        .instr(instr)
    );


    // ============================================================
    // IF/ID PIPELINE REGISTER
    // ============================================================

    if_id if_id_inst (
        .clk(clk),
        .rst(rst),

        .pc_in(pc_current),
        .instr_in(instr),

        .pc_out(if_id_pc),
        .instr_out(if_id_instr)
    );


    // ============================================================
    // CONTROL UNIT
    // ============================================================

    control_unit cu_inst (
        .opcode(if_id_instr[6:0]),

        .reg_write(reg_write),
        .alu_src(alu_src),

        .mem_read(mem_read),
        .mem_write(mem_write),

        .mem_to_reg(mem_to_reg),

        .branch(branch),
        .jump(jump),

        .alu_op(alu_op)
    );


    // ============================================================
    // REGISTER FILE
    // ============================================================

    reg_file rf_inst (
        .clk(clk),

        .we3(mem_wb_reg_write),

        .ra1(if_id_instr[19:15]),
        .ra2(if_id_instr[24:20]),

        .wa3(mem_wb_rd),

        .wd3(write_back_data),

        .rd1(rd1),
        .rd2(rd2)
    );


    // ============================================================
    // IMMEDIATE GENERATOR
    // ============================================================

    imm_gen imm_inst (
        .instr(if_id_instr),
        .imm_out(imm_out)
    );


    // ============================================================
    // ID/EX PIPELINE REGISTER
    // ============================================================

    id_ex id_ex_inst (
        .clk(clk),
        .rst(rst),

        // Control signals
        .reg_write_in(reg_write),
        .mem_to_reg_in(mem_to_reg),
        .mem_write_in(mem_write),
        .mem_read_in(mem_read),
        .branch_in(branch),
        .alu_src_in(alu_src),
        .jump_in(jump),
        .alu_op_in(alu_op),

        // Datapath
        .pc_in(if_id_pc),
        .rd1_in(rd1),
        .rd2_in(rd2),
        .imm_in(imm_out),

        // Register addresses
        .rs1_in(if_id_instr[19:15]),
        .rs2_in(if_id_instr[24:20]),
        .rd_in(if_id_instr[11:7]),

        // Instruction information
        .funct3_in(if_id_instr[14:12]),
        .funct7_in(if_id_instr[31:25]),

        // Outputs
        .reg_write_out(id_ex_reg_write),
        .mem_to_reg_out(id_ex_mem_to_reg),
        .mem_write_out(id_ex_mem_write),
        .mem_read_out(id_ex_mem_read),
        .branch_out(id_ex_branch),
        .alu_src_out(id_ex_alu_src),
        .jump_out(id_ex_jump),
        .alu_op_out(id_ex_alu_op),

        .pc_out(id_ex_pc),
        .rd1_out(id_ex_rd1),
        .rd2_out(id_ex_rd2),
        .imm_out(id_ex_imm),

        .rs1_out(id_ex_rs1),
        .rs2_out(id_ex_rs2),
        .rd_out(id_ex_rd),

        .funct3_out(id_ex_funct3),
        .funct7_out(id_ex_funct7)
    );


    // ============================================================
    // ALU CONTROL
    // ============================================================

    always @(*) begin

        case (id_ex_alu_op)

            // ADD
            // Used for LW, SW, etc.
            2'b00: begin
                alu_ctrl = 4'b0000;
            end

            // SUB
            // Used for BEQ
            2'b01: begin
                alu_ctrl = 4'b0001;
            end

            // R-type / I-type ALU operations
            2'b10: begin

                case (id_ex_funct3)

                    // ADD / SUB
                    3'b000: begin
                        if (id_ex_funct7[5])
                            alu_ctrl = 4'b0001;   // SUB
                        else
                            alu_ctrl = 4'b0000;   // ADD
                    end

                    // AND
                    3'b111: begin
                        alu_ctrl = 4'b0010;
                    end

                    // OR
                    3'b110: begin
                        alu_ctrl = 4'b0011;
                    end

                    // XOR
                    3'b100: begin
                        alu_ctrl = 4'b0100;
                    end

                    // SLL
                    3'b001: begin
                        alu_ctrl = 4'b0101;
                    end

                    // SRL / SRA
                    3'b101: begin
                        if (id_ex_funct7[5])
                            alu_ctrl = 4'b0111;   // SRA
                        else
                            alu_ctrl = 4'b0110;   // SRL
                    end

                    // SLT
                    3'b010: begin
                        alu_ctrl = 4'b1000;
                    end

                    // SLTU
                    3'b011: begin
                        alu_ctrl = 4'b1001;
                    end

                    default: begin
                        alu_ctrl = 4'b0000;
                    end

                endcase

            end

            // LUI / AUIPC
            2'b11: begin
                alu_ctrl = 4'b0000;
            end

            default: begin
                alu_ctrl = 4'b0000;
            end

        endcase

    end


    // ============================================================
    // ALU INPUT MUX
    // ============================================================

    assign alu_input_b =
        id_ex_alu_src ?
        id_ex_imm :
        id_ex_rd2;


    // ============================================================
    // ALU
    // ============================================================

    alu alu_inst (
        .a(id_ex_rd1),
        .b(alu_input_b),

        .alu_ctrl(alu_ctrl),

        .result(alu_result),
        .zero(alu_zero)
    );


    // ============================================================
    // EX/MEM PIPELINE REGISTER
    // ============================================================

    ex_mem ex_mem_inst (
        .clk(clk),
        .rst(rst),

        .alu_result_in(alu_result),
        .rd2_in(id_ex_rd2),
        .pc_target_in(branch_target),

        .zero_in(alu_zero),

        .rd_in(id_ex_rd),

        .reg_write_in(id_ex_reg_write),
        .mem_read_in(id_ex_mem_read),
        .mem_write_in(id_ex_mem_write),
        .mem_to_reg_in(id_ex_mem_to_reg),
        .branch_taken_in(branch_taken),

        .alu_result_out(ex_mem_alu_result),
        .rd2_out(ex_mem_rd2),
        .pc_target_out(ex_mem_pc_target),

        .zero_out(ex_mem_zero),

        .rd_out(ex_mem_rd),

        .reg_write_out(ex_mem_reg_write),
        .mem_read_out(ex_mem_mem_read),
        .mem_write_out(ex_mem_mem_write),
        .mem_to_reg_out(ex_mem_mem_to_reg),
        .branch_taken_out(ex_mem_branch_taken)
    );


    // ============================================================
    // DATA MEMORY
    // ============================================================

    data_memory dmem_inst (
        .clk(clk),

        .mem_write(ex_mem_mem_write),
        .mem_read(ex_mem_mem_read),

        .addr(ex_mem_alu_result),

        .write_data(ex_mem_rd2),

        .read_data(mem_read_data)
    );


    // ============================================================
    // MEM/WB PIPELINE REGISTER
    // ============================================================

    mem_wb mem_wb_inst (
        .clk(clk),
        .rst(rst),

        .read_data_in(mem_read_data),
        .alu_result_in(ex_mem_alu_result),

        .rd_in(ex_mem_rd),

        .reg_write_in(ex_mem_reg_write),
        .mem_to_reg_in(ex_mem_mem_to_reg),

        .read_data_out(mem_wb_read_data),
        .alu_result_out(mem_wb_alu_result),

        .rd_out(mem_wb_rd),

        .reg_write_out(mem_wb_reg_write),
        .mem_to_reg_out(mem_wb_mem_to_reg)
    );

endmodule