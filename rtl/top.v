module top(

    input wire clk,
    input wire rst

);

// WIRES

// PC

wire [31:0] pc_current;
wire [31:0] pc_next;
wire [31:0] pc_plus4;
wire [31:0] branch_target;

// Instruction

wire [31:0] instr;

// Register File

wire [31:0] rd1;
wire [31:0] rd2;

// Immediate

wire [31:0] imm_out;

// Control

wire reg_write;
wire alu_src;
wire mem_read;
wire mem_write;
wire mem_to_reg;
wire branch;
wire jump;
wire [1:0] alu_op;

// ALU

wire [3:0] alu_ctrl;
wire [31:0] alu_operand_b;
wire [31:0] alu_result;
wire zero;

// Memory

wire [31:0] read_data;

// Writeback

wire [31:0] write_back_data;

// PC

adder pc_adder(

.a(pc_current),
.b(32'd4),
.y(pc_plus4)

);

adder branch_adder(

.a(pc_current),
.b(imm_out),
.y(branch_target)

);

assign pc_next = ((branch & zero) | jump) ? branch_target : pc_plus4;

pc PC(

.clk(clk),
.rst(rst),
.pc_in(pc_next),
.pc_out(pc_current)
);

// Instruction Memory

instr_memory IM(
.addr(pc_current),
.instr(instr)
);

// Control Unit

control_unit CU(
.opcode(instr[6:0]),
.reg_write(reg_write),
.alu_src(alu_src),
.mem_read(mem_read),
.mem_write(mem_write),
.mem_to_reg(mem_to_reg),
.branch(branch),
.jump(jump),
.alu_op(alu_op)

);

// Register File

reg_file RF(
.clk(clk),
.we3(reg_write),
.ra1(instr[19:15]),
.ra2(instr[24:20]),
.wa3(instr[11:7]),
.wd3(write_back_data),
.rd1(rd1),
.rd2(rd2)
);

// Immediate Generator

imm_gen IG(
.instr(instr),
.imm_out(imm_out)
);

// ALU CONTROL

alu_control ALUCTRL(
.alu_op(alu_op),
.funct3(instr[14:12]),
.funct7_5(instr[30]),
.alu_ctrl(alu_ctrl)
);

// ALU INPUT MUX

mux2 ALUMUX(
.a(rd2),
.b(imm_out),
.sel(alu_src),
.y(alu_operand_b)
);

// ALU

alu ALU(
.a(rd1),
.b(alu_operand_b),
.alu_ctrl(alu_ctrl),
.result(alu_result),
.zero(zero)
);

// DATA MEMORY

data_memory DM(
.clk(clk),
.mem_read(mem_read),
.mem_write(mem_write),
.addr(alu_result),
.write_data(rd2),
.read_data(read_data)

);

// WRITEBACK MUX

mux2 WBMUX(
.a(alu_result),
.b(read_data),
.sel(mem_to_reg),
.y(write_back_data)

);

endmodule