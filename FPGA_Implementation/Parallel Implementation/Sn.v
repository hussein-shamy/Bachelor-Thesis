module Sn (
//ins
input	wire				CLK,RST,
input 	wire	[3:0]  		u,
input 	wire	[95:0] 		r,
input 	wire	[23:0] 		alpha,
input 	wire	[23:0] 		gamma_maxQ,
//outs
output 	wire	[23:0] 		maxQ,
output 	wire	[23:0] 		Qn_0,
output 	wire	[23:0] 		Qn_1,
output 	wire	[23:0] 		Qn_2,
output 	wire	[23:0] 		Qn_3
);

//Port mapping
Qn Qn_module(
.alpha		(alpha),
.gamma_maxQ	(gamma_maxQ),
.rn_z      	(r),
.u         	(u),
.CLK       	(CLK),
.RST       	(RST),
.maxQ_n    	(maxQ),
.Qn_0      	(Qn_0),
.Qn_1      	(Qn_1),
.Qn_2      	(Qn_2),
.Qn_3      	(Qn_3)
);

endmodule
