module data_memory(

    input wire clk,

    input wire mem_read,
    input wire mem_write,

    input wire [31:0] addr,
    input wire [31:0] write_data,

    output reg [31:0] read_data

);

reg [31:0] memory [0:1023];

integer i;

initial begin
    for(i=0;i<1024;i=i+1)
        memory[i]=32'd0;
end

// Write

always @(posedge clk)
begin
    if(mem_write)
        memory[addr[31:2]] <= write_data;
end

// Read

always @(*)
begin

    if(mem_read)
        read_data = memory[addr[31:2]];

    else
        read_data = 32'd0;

end

endmodule