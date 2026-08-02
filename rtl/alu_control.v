module alu_control (
    input  wire [1:0] alu_op,
    input  wire [2:0] funct3,
    input  wire       funct7_5,
    output reg  [3:0] alu_ctrl
);

    always @(*) begin
        case (alu_op)
            // Load / Store / JAL / JALR (Requires ADD)
            2'b00: begin
                alu_ctrl = 4'b0000; // ADD
            end

            // Branch instructions (Requires SUB for zero-flag checking)
            2'b01: begin
                alu_ctrl = 4'b0001; // SUB
            end

            // R-Type & I-Type ALU Operations
            2'b10: begin
                case (funct3)
                    3'b000: begin
                        if (funct7_5)
                            alu_ctrl = 4'b0001; // SUB
                        else
                            alu_ctrl = 4'b0000; // ADD
                    end

                    3'b001: alu_ctrl = 4'b0101; // SLL
                    3'b010: alu_ctrl = 4'b1000; // SLT
                    3'b011: alu_ctrl = 4'b1001; // SLTU
                    3'b100: alu_ctrl = 4'b0100; // XOR

                    3'b101: begin
                        if (funct7_5)
                            alu_ctrl = 4'b0111; // SRA
                        else
                            alu_ctrl = 4'b0110; // SRL
                    end

                    3'b110: alu_ctrl = 4'b0011; // OR
                    3'b111: alu_ctrl = 4'b0010; // AND

                    default: alu_ctrl = 4'b0000;
                endcase
            end

            // LUI / Upper Immediate pass-through
            2'b11: begin
                alu_ctrl = 4'b0000;
            end

            default: begin
                alu_ctrl = 4'b0000;
            end
        endcase
    end

endmodule