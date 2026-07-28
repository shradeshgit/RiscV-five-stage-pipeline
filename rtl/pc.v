module pc(
    input clk,
    input rst,
    output reg [31:0] pc
);

always @(posedge clk) begin
    if (rst)
        pc <= 32'd0;
    else
        pc <= pc + 4;
end

endmodule
