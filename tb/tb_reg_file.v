`timescale 1ns/1ps

module tb_reg_file;


reg clk;
reg we3;

reg [4:0] ra1;
reg [4:0] ra2;
reg [4:0] wa3;

reg [31:0] wd3;

wire [31:0] rd1;
wire [31:0] rd2;


reg_file uut (

    .clk(clk),
    .we3(we3),

    .ra1(ra1),
    .ra2(ra2),

    .wa3(wa3),

    .wd3(wd3),

    .rd1(rd1),
    .rd2(rd2)

);


always #5 clk = ~clk;


initial
begin

    $dumpfile("sim/reg_file.vcd");
    $dumpvars(0,tb_reg_file);

    clk = 0;
    we3 = 0;
    ra1 = 0;
    ra2 = 0;
    wa3 = 0;
    wd3 = 0;


    $display("Writing x1 = 25");

    wa3 = 5'd1;
    wd3 = 32'd25;
    we3 = 1;

    @(posedge clk);
    we3 = 0;
    ra1 = 5'd1;
    #1;
    if(rd1 == 32'd25)
        $display("PASS : x1 = %d", rd1);
    else
        $display("FAIL : x1 = %d Expected 25", rd1);





    $display("Writing x5 = 100");

    wa3 = 5'd5;
    wd3 = 32'd100;
    we3 = 1;

    @(posedge clk);
    we3 = 0;
    ra1 = 5'd5;
    #1;
    if(rd1 == 32'd100)
        $display("PASS : x5 = %d", rd1);
    else
        $display("FAIL : x5 = %d Expected 100", rd1);





    $display("Reading x1 and x5 simultaneously");

    ra1 = 5'd1;
    ra2 = 5'd5;
    #1;
    if(rd1 == 32'd25 && rd2 == 32'd100)
        $display("PASS : x1=%d x5=%d", rd1, rd2);
    else
        $display("FAIL");




    $display("Attempting to write x0");

    wa3 = 5'd0;
    wd3 = 32'd999;
    we3 = 1;
    @(posedge clk);
    we3 = 0;
    ra1 = 5'd0;
    #1;
    if(rd1 == 32'd0)
        $display("PASS : x0 remains zero");
    else
        $display("FAIL : x0 = %d", rd1);




    ra1 = 5'd10;
    #1;
    if(rd1 == 32'd0)
        $display("PASS : x10 = 0");
    else
        $display("FAIL");


    $display("\nAll Register File Tests Completed");
    #20;
    $finish;

end

endmodule