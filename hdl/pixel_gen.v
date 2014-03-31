module pixel_gen(input clk, input video_on, input [9:0] pixel_x, input [9:0] pixel_y,
                 output reg [2:0] out_red, output reg [2:0] out_green, output reg [2:1] out_blue,
                 input [11:0]     wr_video_mem_addr, input wr, input [3:0] wr_data, output [3:0] rd_data, input rd,
                 input            wr_clk);

   wire [11:0]                    address_a;
   wire [3:0]                     pixel_data;

   assign address_a = {pixel_y[9:4], pixel_x[9:4]};

   RAMB16_S4_S4 ram_4096_x4_4096_x4(
                                    .DIA     (16'h0000),
                                    .ENA     (1'b1),
                                    .WEA     (1'b0),
                                    .SSRA    (1'b0),
                                    .CLKA    (clk),
                                    .ADDRA   (address_a),
                                    .DOA     (pixel_data),

                                    .DIB     (wr_data),
                                    .ENB     (wr | rd),
                                    .WEB     (wr),
                                    .SSRB    (1'b0),
                                    .CLKB    (wr_clk),
                                    .ADDRB   (wr_video_mem_addr),
                                    .DOB     (rd_data)
                                    );

   always @(pixel_data or video_on)
     begin
        if (!video_on)
          begin
             out_red = 3'b0;
             out_green = 3'b0;
             out_blue = 2'b0;
          end
        else
          begin
             out_red = pixel_data[2:0];
             out_green = pixel_data[3:1];
             out_blue = pixel_data[1:0];
          end
     end

endmodule
