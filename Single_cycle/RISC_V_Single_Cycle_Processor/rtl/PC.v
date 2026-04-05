module PC (	
		input wire 	   clk,reset, stall,
		input wire [31:0]  PCNext,
		output wire [31:0] PC );
   
   reg [31:0] 			   PCReg;

   always@(posedge clk or posedge reset)
     begin
	if (reset) PCReg <= 0;
	else if (!stall) PCReg <= PCNext;
     end	

   assign PC = PCReg;

endmodule
