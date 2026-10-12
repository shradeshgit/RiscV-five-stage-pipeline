
module reg_file (
    input  wire        clk, we3,
    input  wire [4:0]  ra1, ra2, wa3,
    input  wire [31:0] wd3,
    output wire [31:0] rd1, rd2
);

    reg [31:0] regs [0:31];

    // Read port 1 with write-through bypass
    assign rd1 = (ra1 == 5'd0) ? 32'b0 :
                 (we3 && wa3 != 5'd0 && wa3 == ra1) ? wd3 :
                 regs[ra1];

    // Read port 2 with write-through bypass
    assign rd2 = (ra2 == 5'd0) ? 32'b0 :
                 (we3 && wa3 != 5'd0 && wa3 == ra2) ? wd3 :
                 regs[ra2];

    // Write port
    always @(posedge clk) begin
        if (we3 && wa3 != 5'd0)
            regs[wa3] <= wd3;
    end

endmodule
