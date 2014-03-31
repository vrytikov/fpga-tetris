module mem_cpu_unit(input clk, input rst, input mem_port_wr, input [9:0] mem_port_addr, input [17:0] mem_port_data, input mem_wr_clk,
                    output [7:0] port_id, output write_strobe, output read_strobe, output [7:0] out_port, input [7:0] in_port);

   wire [9:0]                    address;
   wire [17:0]                   instruction;

   kcpsm3 processor(.address(address),
                    .instruction(instruction),
                    .port_id(port_id),
                    .write_strobe(write_strobe),
                    .out_port(out_port),
                    .read_strobe(read_strobe),
                    .in_port(in_port),
                    .interrupt(1'b0),
                    .interrupt_ack(),
                    .reset(rst),
                    .clk(clk));

   prog_mem prog_mem0(.address(address), .instruction(instruction), .clk(clk),
                      .mem_port_data(mem_port_data),.mem_port_wr(mem_port_wr),
                      .mem_port_addr(mem_port_addr),.mem_wr_clk(mem_wr_clk));

endmodule
