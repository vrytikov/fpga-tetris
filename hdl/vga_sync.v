module vga_sync(input clk, input rst, output [9:0] pixel_x,output [9:0] pixel_y, output hsync,output vsync, output video_on);
   reg [9:0] x;
   reg [9:0] y;

   always @(posedge clk)
     begin
        if (rst)
          x <= 10'b0;
        else if (x >= 10'd799)
          x <= 10'b0;
        else
          x <= x + 1;
     end

   always @(posedge clk)
     begin
        if (rst)
          y <= 10'b0;
        else
          if (x >= 10'd799)
            begin
               if (y >= 10'd524)
                 y <= 10'b0;
               else
                 y <= y + 1;
            end
     end

   assign video_on = (x >= 10'd48) && (x < 10'd640+10'd48) && (y >= 10'd33) && (y < 10'd480+10'd33);

   assign pixel_x = ((x >= 10'd48) && (x < 10'd640+10'd48)) ? (x - 10'd48) : 0;
   assign pixel_y = ((y >= 10'd33) && (y < 10'd480+10'd33)) ? (y - 10'd33) : 0;

   wire hsync_n = (x >= 10'd640+10'd48+10'd16) && (x <= 10'd640+10'd48+10'd16+10'd94);
   wire vsync_n = (y >= 10'd480+10'd33+10'd10) && (y <= 10'd480+10'd33+10'd10+10'd1);

   assign hsync = !hsync_n;
   assign vsync = !vsync_n;
endmodule
