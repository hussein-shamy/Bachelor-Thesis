module Qn_calc
(
input	wire	[13:0]	gamma_maxQ,
input	wire	[13:0]	Qn_old,
input	wire	[13:0]	Rn_current,
input	wire	[13:0]	alpha_const,
output	wire		[13:0]	QnP1_new
);

//internal signals
wire	[13:0]	result_Add_gammaMaxQ_Reward;
wire	[13:0]	negative_Qn_old;
wire	[13:0]	result_Sub_Qn_old;
wire	[13:0]	result_Mult_alpha_const;

//negative Qn for the adder (subtraction)
assign  negative_Qn_old = {~Qn_old[13] , Qn_old[12:0]};
//first stage addition			[gammaMaxQ + Rn]
qadd	Add_gammaMaxQ_Reward
(
.a	(gamma_maxQ),
.b	(Rn_current),
.c	(result_Add_gammaMaxQ_Reward)
);

//second stage subtraction		[gammaMaxQ + Rn - Qn]
qadd	Sub_Qn_old
(
.a	(result_Add_gammaMaxQ_Reward),
.b	(negative_Qn_old),
.c	(result_Sub_Qn_old)
);

//third stage multiplication	[alpha * (gammaMaxQ + Rn - Qn)]
qmult	Mult_alpha_const
(
.i_multiplicand	(result_Sub_Qn_old),
.i_multiplier	(alpha_const),
.o_result		(result_Mult_alpha_const)
);

//forth stage addition			[Qn + [alpha * (gammaMaxQ + Rn - Qn)]]
qadd	Add_Qn_old
(
.a	(result_Mult_alpha_const),
.b	(Qn_old),
.c	(QnP1_new)
);

endmodule