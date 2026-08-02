module control_unit (
    input  wire [6:0] opcode,
    output reg        reg_write,
    output reg        alu_src,
    output reg        mem_read,
    output reg        mem_write,
    output reg        mem_to_reg,
    output reg        branch,
    output reg        jump,
    output reg  [1:0] alu_op
);

    always @(*) begin
        // Default control signal values (prevents unintended latches)
        reg_write  = 1'b0;
        alu_src    = 1'b0;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        mem_to_reg = 1'b0;
        branch     = 1'b0;
        jump       = 1'b0;
        alu_op     = 2'b00;

        case (opcode)
            // R-Type Instructions (ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU)
            7'b0110011: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;
                alu_op    = 2'b10;
            end

            // I-Type Instructions (ADDI, ANDI, ORI, XORI, SLLI, SRLI, SRAI, SLTI, SLTIU)
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b10;
            end

            // Load Instructions (LB, LH, LW, LBU, LHU)
            7'b0000011: begin
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                mem_read   = 1'b1;
                mem_to_reg = 1'b1;
                alu_op     = 2'b00;
            end

            // Store Instructions (SB, SH, SW)
            7'b0100011: begin
                alu_src   = 1'b1;
                mem_write = 1'b1;
                alu_op    = 2'b00;
            end

            // Branch Instructions (BEQ, BNE, BLT, BGE, BLTU, BGEU)
            7'b1100011: begin
                branch = 1'b1;
                alu_op = 2'b01;
            end

            // JAL Instruction
            7'b1101111: begin
                jump      = 1'b1;
                reg_write = 1'b1;
                alu_op    = 2'b00;
            end

            // JALR Instruction
            7'b1100111: begin
                jump      = 1'b1;
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b00;
            end

            // LUI Instruction
            7'b0110111: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b11;
            end

            // AUIPC Instruction
            7'b0010111: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b11;
            end

            default: begin
            end
        endcase
    end

endmodule