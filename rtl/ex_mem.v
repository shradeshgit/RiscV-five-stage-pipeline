module ex_mem (
    input wire clk,
    input wire rst,

    input wire [31:0] alu_result_in,
    input wire [31:0] rd2_in,
    input wire [31:0] pc_target_in,

    input wire zero_in,

    input wire [4:0] rd_in,

    input wire reg_write_in,
    input wire mem_read_in,
    input wire mem_write_in,
    input wire mem_to_reg_in,
    input wire branch_taken_in,

    output reg [31:0] alu_result_out,
    output reg [31:0] rd2_out,
    output reg [31:0] pc_target_out,

    output reg zero_out,

    output reg [4:0] rd_out,

    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg mem_to_reg_out,
    output reg branch_taken_out
);

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            alu_result_out <= 32'b0;
            rd2_out        <= 32'b0;
            pc_target_out  <= 32'b0;

            zero_out <= 1'b0;

            rd_out <= 5'b0;

            reg_write_out  <= 1'b0;
            mem_read_out   <= 1'b0;
            mem_write_out  <= 1'b0;
            mem_to_reg_out <= 1'b0;
            branch_taken_out <= 1'b0;

        end
        else begin

            alu_result_out <= alu_result_in;
            rd2_out        <= rd2_in;
            pc_target_out  <= pc_target_in;

            zero_out <= zero_in;

            rd_out <= rd_in;

            reg_write_out  <= reg_write_in;
            mem_read_out   <= mem_read_in;
            mem_write_out  <= mem_write_in;
            mem_to_reg_out <= mem_to_reg_in;
            branch_taken_out <= branch_taken_in;

        end

    end

endmodule