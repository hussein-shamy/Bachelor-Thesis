module PRNG #(parameter Seed = 16'b1001_0111_1011_0010) (
input	wire			CLK,RST,
output	wire	[1:0]	Action
);

reg		[15:0]	PRNG_out;
wire			feedback;
	
//feedback is XORing the last two FFs 
assign feedback = PRNG_out[15] ^ PRNG_out[13] ^ PRNG_out[12] ^ PRNG_out[11];

//assign action the two MSBs from PRNG_out
assign	Action = PRNG_out[15:14];

//  main PRNG code
always@(posedge CLK,negedge RST)
begin
	if(!RST)
	begin
		PRNG_out <= Seed;
	end
	
	else
	begin
		PRNG_out[15:0]<= {PRNG_out[14:0],feedback};
	end
end

endmodule