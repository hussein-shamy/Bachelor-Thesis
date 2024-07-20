module PQL_Top (
input	wire				CLK,RST,
input	wire	[95:0]		RS0,RS1,RS2,RS3,RS4,RS5,
input	wire	[23:0]		alpha, Gamma,

output	wire	[23:0]		Q0_0	,Q0_1	,Q0_2	,Q0_3,    	// from Sn with parameter (state_num = 0)
							Q1_0	,Q1_1	,Q1_2	,Q1_3,    	// from Sn with parameter (state_num = 1)
							Q2_0	,Q2_1	,Q2_2	,Q2_3,    	// from Sn with parameter (state_num = 2)
							Q3_0	,Q3_1	,Q3_2	,Q3_3,    	// from Sn with parameter (state_num = 3)
							Q4_0	,Q4_1	,Q4_2	,Q4_3,    	// from Sn with parameter (state_num = 4)
                            Q5_0	,Q5_1	,Q5_2	,Q5_3		// from Sn with parameter (state_num = 5)
);

wire	[4:0]	addr;
wire	[2:0]	S_to_EN;
wire	[3:0]	u0,u1,u2,u3,u4,u5;
wire	[1:0]	a_z;
wire	[23:0]	gamma_maxQ;
wire	[23:0]	maxQ0,maxQ1,maxQ2,maxQ3,maxQ4,maxQ5;


//assignment
assign addr = {S_to_EN,a_z};
////////

//Random number generator ,output: a_z
PRNG GA(
.CLK   (CLK),
.RST   (RST),
.Action(a_z)
);

/////////////////////////////////EN Array of modules ,N = 0:5
//EN module	0	,output: u0
EN #(0) EN_0 (
.s   	(S_to_EN),
.a   	(a_z),
.u		(u0)
);

//EN module	1	,output: u1
EN #(1) EN_1 (
.s   	(S_to_EN),
.a   	(a_z),
.u		(u1)
);

//EN module	2	,output: u2
EN #(2) EN_2 (
.s   	(S_to_EN),
.a   	(a_z),
.u		(u2)
);

//EN module	3	,output: u3
EN #(3) EN_3 (
.s   	(S_to_EN),
.a   	(a_z),
.u		(u3)
);

//EN module	4	,output: u4
EN #(4) EN_4 (
.s   	(S_to_EN),
.a   	(a_z),
.u		(u4)
);

//EN module	5	,output: u5
EN #(5) EN_5 (
.s   	(S_to_EN),
.a   	(a_z),
.u		(u5)
);

/////////////////////////////////

//////////////////////////////////Sn array of modules

/////////////////Sn0
Sn Sn0 (
//const
.CLK       (CLK),
.RST       (RST),
.alpha     (alpha),
.gamma_maxQ(gamma_maxQ),
//vars
.u         (u0),
.r         (RS0),
.maxQ      (maxQ0),
.Qn_0      (Q0_0),
.Qn_1      (Q0_1),
.Qn_2      (Q0_2),
.Qn_3      (Q0_3)
);
///////

/////////////////Sn1
Sn Sn1 (
//const
.CLK       (CLK),
.RST       (RST),
.alpha     (alpha),
.gamma_maxQ(gamma_maxQ),
//vars
.u         (u1),
.r         (RS1),
.maxQ      (maxQ1),
.Qn_0      (Q1_0),
.Qn_1      (Q1_1),
.Qn_2      (Q1_2),
.Qn_3      (Q1_3)
);
///////

/////////////////Sn2
Sn Sn2 (
//const
.CLK       (CLK),
.RST       (RST),
.alpha     (alpha),
.gamma_maxQ(gamma_maxQ),
//vars
.u         (u2),
.r         (RS2),
.maxQ      (maxQ2),
.Qn_0      (Q2_0),
.Qn_1      (Q2_1),
.Qn_2      (Q2_2),
.Qn_3      (Q2_3)
);
///////

/////////////////Sn3
Sn Sn3 (
//const
.CLK       (CLK),
.RST       (RST),
.alpha     (alpha),
.gamma_maxQ(gamma_maxQ),
//vars
.u         (u3),
.r         (RS3),
.maxQ      (maxQ3),
.Qn_0      (Q3_0),
.Qn_1      (Q3_1),
.Qn_2      (Q3_2),
.Qn_3      (Q3_3)
);
///////

/////////////////Sn0
Sn Sn4 (
//const
.CLK       (CLK),
.RST       (RST),
.alpha     (alpha),
.gamma_maxQ(gamma_maxQ),
//vars
.u         (u4),
.r         (RS4),
.maxQ      (maxQ4),
.Qn_0      (Q4_0),
.Qn_1      (Q4_1),
.Qn_2      (Q4_2),
.Qn_3      (Q4_3)
);
///////

/////////////////Sn0
Sn Sn5 (
//const
.CLK       (CLK),
.RST       (RST),
.alpha     (alpha),
.gamma_maxQ(gamma_maxQ),
//vars
.u         (u5),
.r         (RS5),
.maxQ      (maxQ5),
.Qn_0      (Q5_0),
.Qn_1      (Q5_1),
.Qn_2      (Q5_2),
.Qn_3      (Q5_3)
);
///////

//SEL module
SEL SEL_module(
.CLK       (CLK),
.RST       (RST),
.addr	   (addr),
.Gamma     (Gamma),
.Max_Q0    (maxQ0),
.Max_Q1    (maxQ1),
.Max_Q2    (maxQ2),
.Max_Q3    (maxQ3),
.Max_Q4    (maxQ4),
.Max_Q5    (maxQ5),
.S_to_EN   (S_to_EN),
.gamma_maxQ(gamma_maxQ)
);

endmodule