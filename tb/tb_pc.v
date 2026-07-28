`timescale 1ns/1ps

module tb_pc;

reg clk;
reg rst;

wire [31:0] pc;

pc uut (
    .clk(clk),
    .rst(rst),
    .pc(pc)
);

always #5 clk = ~clk;

initial begin

    $dumpfile("sim/pc.vcd");
    $dumpvars(0, tb_pc);

    clk = 0;
    rst = 1;

    #20;

    rst = 0;

    #100;

    $finish;

end

endmodule