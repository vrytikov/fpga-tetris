module video_mem_wr_addr_gen(input clk,input [7:0] d_in,input g_en,input en1,
                             input en2,input inc,output reg [15:0] video_mem_addr);

   wire [15:0]                     video_mem_addr_plus_one = video_mem_addr + 16'b1;

   always @(posedge clk)
     if (g_en)
       if (en1 && g_en)
         video_mem_addr[7:0] <= d_in;
       else if (inc && g_en)
         video_mem_addr[7:0] <= video_mem_addr_plus_one[7:0];

   always @(posedge clk)
     if (g_en)
       if (en2)
         video_mem_addr[15:8] <= d_in;
       else if (inc)
         video_mem_addr[15:8] <= video_mem_addr_plus_one[15:8];
endmodule
