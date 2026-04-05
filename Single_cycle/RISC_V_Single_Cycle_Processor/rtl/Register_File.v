
module Register_File(
		     input wire 	clk, WE3, stall,
		     input wire [4:0] 	RA1,RA2,WA3,
		     input wire [31:0] 	WD3,
		     output wire [31:0] RD1,RD2
		     );

   reg [31:0] 				REG_MEM_BLOCK[31:0];

   always@(posedge clk)
     begin
	if(WE3 && !stall)
	  REG_MEM_BLOCK[WA3] <= WD3;
     end

   assign RD1 = (RA1 != 0) ? REG_MEM_BLOCK[RA1] : 0;
   assign RD2 = (RA2 != 0) ? REG_MEM_BLOCK[RA2] : 0;

endmodule
