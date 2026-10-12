
module forwarding_unit (
    input  wire [4:0] id_ex_rs1,
    input  wire [4:0] id_ex_rs2,

    input  wire [4:0] ex_mem_rd,
    input  wire [4:0] mem_wb_rd,

    input  wire       ex_mem_reg_write,
    input  wire       mem_wb_reg_write,

    output reg  [1:0] forward_a,
    output reg  [1:0] forward_b
);

    // Forwarding select:
    // 00 = Register file
    // 10 = EX/MEM
    // 01 = MEM/WB

    always @(*) begin

        // Default: use register-file value
        forward_a = 2'b00;
        forward_b = 2'b00;

        // Operand A: check EX/MEM first
        if (ex_mem_reg_write &&
            (ex_mem_rd != 5'd0) &&
            (ex_mem_rd == id_ex_rs1)) begin

            forward_a = 2'b10;

        end
        else if (mem_wb_reg_write &&
                 (mem_wb_rd != 5'd0) &&
                 (mem_wb_rd == id_ex_rs1)) begin

            forward_a = 2'b01;

        end

        // Operand B: check EX/MEM first
        if (ex_mem_reg_write &&
            (ex_mem_rd != 5'd0) &&
            (ex_mem_rd == id_ex_rs2)) begin

            forward_b = 2'b10;

        end
        else if (mem_wb_reg_write &&
                 (mem_wb_rd != 5'd0) &&
                 (mem_wb_rd == id_ex_rs2)) begin

            forward_b = 2'b01;

        end

    end

endmodule
