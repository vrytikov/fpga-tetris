module sync2(input async_in, input clk, output reg sync_out);
   reg q;

   always @(posedge clk)
     {sync_out, q} <= {q, async_in};

endmodule
