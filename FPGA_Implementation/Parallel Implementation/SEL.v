module SEL #(parameter depth = 24)(
input   wire	                     	CLK, RST,
input   wire	[$clog2(depth)-1: 0] 	addr,		//{S_to_EN,A}
input   wire	[23:0]               	Gamma,
input   wire	[23:0]               	Max_Q0, Max_Q1, Max_Q2, Max_Q3, Max_Q4, Max_Q5,
output  wire	[2:0]                	S_to_EN,
output  wire	[23:0]               	gamma_maxQ
);



//port mapping//

STT U_STT(
.CLK    (CLK),
.RST    (RST),
.addr   (addr),
.S_to_EN(S_to_EN)

);

Mux U_Mux(
.Max_Q0   	(Max_Q0),
.Max_Q1	  	(Max_Q1),
.Max_Q2	 	(Max_Q2),
.Max_Q3   	(Max_Q3),
.Max_Q4   	(Max_Q4),
.Max_Q5   	(Max_Q5),
.S_to_EN	(S_to_EN),
.Gamma   	(Gamma),
.gamma_maxQ	(gamma_maxQ)
);
 endmodule
// 24 Q signals are added in the final top module 	