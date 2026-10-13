
module pc (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall,
    input  wire [31:0] pc_in,
    output reg  [31:0] pc_out
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            pc_out <= 32'b0;
        else if (!stall)
            pc_out <= pc_in;
        // When stall=1, retain the current PC.
    end

endmodule
