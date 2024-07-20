module mul_2414f
(
input	wire 	[23:0]		A,B,
output	wire	[23:0]		Result,
output	wire				overflow_flag
);

qmult #(14,24) MUL1_ARITH_LIB(
		.i_multiplicand(A),
		.i_multiplier(B),
		.o_result(Result),
		.ovr(overflow_flag)
		);
		
endmodule