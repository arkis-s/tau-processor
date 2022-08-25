module clock_divider (	input wire phys_clk,
								// MSB (little endian encoding) where clock_div[25] should give 0.67 seconds
								output reg [25:0] clock_div = 0);
								
	always @(posedge phys_clk) begin
		clock_div <= clock_div + 1;
	end
endmodule