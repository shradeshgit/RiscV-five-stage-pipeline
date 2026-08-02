module reg_file (
    input  wire        clk, we3,
    input  wire [4:0]  ra1, ra2, wa3,
    input  wire [31:0] wd3,
    output wire [31:0] rd1, rd2
);
    reg [31:0] regs [0:31];

    integer i;
    initial 
    begin
        for(i = 0; i < 32; i = i + 1)
            regs[i] = 32'd0;
    end

    assign rd1 = (ra1 == 5'b0) ? 32'b0 : regs[ra1];
    assign rd2 = (ra2 == 5'b0) ? 32'b0 : regs[ra2];

    always @(posedge clk)
    begin
        if (we3 && wa3 != 5'b0)
            regs[wa3] <= wd3;
    end 
    
endmodule