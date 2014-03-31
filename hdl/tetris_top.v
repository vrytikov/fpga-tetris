module tetris_top(input uclk, output hsync, output vsync, output [2:0] OutRed, output [2:0] OutGreen, output [2:1] OutBlue,
                  input [3:0]      btn, input [7:0] sw,
                  output reg [7:0] Led, inout [7:0] EppDB, output EppWait, input EppAstb, input EppDstb, input EppWr,
                  output [3:0]     an);

   assign an = 4'b1111;

   wire                        clk;
   assign clk = uclk;
   wire                        rst;

   sync2 rst_sync(.clk(clk),
                 .async_in(btn[0]),
                 .sync_out(rst)
                 );

   wire                        mem_port_wr;
   wire [9:0]                  mem_port_addr;
   wire [17:0]                 mem_port_data;
   wire                        wr_clk;

   wire [7:0]                  port_id;
   wire                        write_strobe;
   wire                        read_strobe;
   wire [7:0]                  out_port;
   wire [15:0]                 video_mem_addr;

   wire [9:0]                  pixel_x;
   wire [9:0]                  pixel_y;
   wire                        video_on;

   wire                        wr_inc, en1, en2, g_en;

   assign wr_inc = port_id[2];
   assign en1 = port_id[0];
   assign en2 = port_id[1];

   assign g_en = write_strobe;

   wire [2:0]                  out_red;
   wire [2:0]                  out_green;
   wire [2:1]                  out_blue;

   assign OutRed = out_red;
   assign OutGreen = out_green;
   assign OutBlue = out_blue;

   wire [7:0]                  wr_data;
   wire [7:0]                  rd_data;
   reg [7:0]                  in_port;

   assign wr_data = out_port;

   always @(port_id or sw or rd_data)
     begin
        if (port_id == 8'd10)
          in_port = sw;
        else if (port_id == 8'd11)
          in_port = {5'b0, btn[3], btn[2], btn[1]};
        else
          in_port = rd_data;
     end

   always @(posedge clk)
     begin
        if (write_strobe && port_id == 8'd8)
          Led <= out_port;
     end

   video_mem_wr_addr_gen addr_gen(.clk(clk),
                                  .d_in(out_port),
                                  .g_en(g_en),
                                  .en1(en1),
                                  .en2(en2),
                                  .inc(wr_inc),
                                  .video_mem_addr(video_mem_addr)
                                  );

   mem_cpu_unit mcu0(.clk(clk),
                     .rst(rst),

                     .mem_port_wr(mem_port_wr),
                     .mem_port_addr(mem_port_addr),
                     .mem_port_data(mem_port_data),
                     .mem_wr_clk(wr_clk),

                     .port_id(port_id),
                     .write_strobe(write_strobe),
                     .read_strobe(read_strobe),
                     .out_port(out_port),
                     .in_port(in_port)
                     );

   vga_sync vga_sync0(.clk(clk),
                      .rst(rst),
                      .pixel_x(pixel_x),
                      .pixel_y(pixel_y),
                      .hsync(hsync),
                      .vsync(vsync),
                      .video_on(video_on)
                      );

   pixel_gen pixel_gen0(.clk(clk),
                        .pixel_x(pixel_x),
                        .pixel_y(pixel_y),
                        .out_red(out_red),
                        .out_green(out_green),
                        .out_blue(out_blue),
                        .wr_video_mem_addr(video_mem_addr),
                        .wr(wr_inc&g_en),
                        .wr_data(wr_data),
                        .wr_clk(clk),
                        .video_on(video_on),
                        .rd_data(rd_data),
                        .rd(port_id != 8'd10)
                        );

   wire [7:0]                  EppBusOut;
   wire [4:0]                  EppAdrOut;
   wire                        EppWrOut;
   wire                        selBramCtrl;
   wire                        EppStbDataOut;

   EppCtrlAsync EppCtrlAsyncInst(.busIn(8'b0),
                                 .EppAstb(EppAstb),
                                 .EppDstb(EppDstb),
                                 .EppWr(EppWr),
                                 .busOut(EppBusOut),
                                 .ctlrWr(EppWrOut),
                                 .EppWait(EppWait),
                                 .outEppAdr(EppAdrOut),
                                 .stbData(EppStbDataOut),
                                 .EppDB(EppDB),
                                 .selA(),
                                 .selC(),
                                 .selE(),
                                 .sel0(selBramCtrl),
                                 .sel2(),
                                 .sel4(),
                                 .sel6(),
                                 .sel8());

   BramComCtrl #(.n(10)) BramComCtrlInst(.busBramIn(8'b0),
                               .busEppAdrIn(EppAdrOut),
                               .busEppIn(EppBusOut),
                               .ctrlWr(EppWrOut),
                               .selBram(selBramCtrl),
                               .stbData(EppStbDataOut),

                               .busBramAdr(mem_port_addr),
                               .busBramOut(mem_port_data[17:0]),
                               .busEppOut(),
                               .clkBram(wr_clk),
                               .ctlEnBram(),
                               .ctlWeBram(mem_port_wr));

endmodule
