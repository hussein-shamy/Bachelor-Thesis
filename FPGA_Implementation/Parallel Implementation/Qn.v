module Qn (
input 	wire	[23:0]	alpha,gamma_maxQ,
input	wire	[95:0]	rn_z,
input 	wire	[3:0]	u,
input	wire			CLK,RST,

output	reg		[23:0]	maxQ_n,
output	wire	[23:0]	Qn_0,Qn_1,Qn_2,Qn_3
);

//intermediate signals and registers
reg 	[23:0]		REGn0,REGn1,REGn2,REGn3;
wire	[23:0]		SUM1n1_res,SUM1n2_res,SUM1n3_res,SUM1n0_res;
wire	[23:0]		SUM2n1_res,SUM2n2_res,SUM2n3_res,SUM2n0_res;
wire	[23:0]		SUB1n1_res,SUB1n2_res,SUB1n3_res,SUB1n0_res;
wire	[23:0]		MULT1n1_res,MULT1n2_res,MULT1n3_res,MULT1n0_res;


//////////////////////Adders level 1////////////////////////
/////////first adder
qadd SUM1n0 (
.a(gamma_maxQ),
.b(rn_z[23:0]),
.c(SUM1n0_res)
);
/////////second adder
qadd SUM1n1 (
.a(gamma_maxQ),
.b(rn_z[47:24]),
.c(SUM1n1_res)
);
/////////third adder
qadd SUM1n2 (
.a(gamma_maxQ),
.b(rn_z[71:48]),
.c(SUM1n2_res)
);
/////////fourth adder
qadd SUM1n3 (
.a(gamma_maxQ),
.b(rn_z[95:72]),
.c(SUM1n3_res)
);

//////////////////////Subtractors////////////////////////
//{1,Qn_0[22:0]}
/////////first subtractor
qadd SUB1n0 (
.a(SUM1n0_res),
.b({1'b1,Qn_0[22:0]}),
.c(SUB1n0_res)
);

/////////second subtractor
qadd SUB1n1 (
.a(SUM1n1_res),
.b({1'b1,Qn_1[22:0]}),
.c(SUB1n1_res)
);

/////////third subtractor
qadd SUB1n2 (
.a(SUM1n2_res),
.b({1'b1,Qn_2[22:0]}),
.c(SUB1n2_res)
);

/////////fourth subtractor
qadd SUB1n3 (
.a(SUM1n3_res),
.b({1'b1,Qn_3[22:0]}),
.c(SUB1n3_res)
);

//////////////////////Multipliers/////////////
/////////first multiplier
mul_2414f MULT1n0(
.A     (alpha),
.B     (SUB1n0_res),
.Result(MULT1n0_res)
);

/////////second multiplier
mul_2414f MULT1n1(
.A     (alpha),
.B     (SUB1n1_res),
.Result(MULT1n1_res)
);

/////////third multiplier
mul_2414f MULT1n2(
.A     (alpha),
.B     (SUB1n2_res),
.Result(MULT1n2_res)
);

/////////fourth multiplier
mul_2414f MULT1n3(
.A     (alpha),
.B     (SUB1n3_res),
.Result(MULT1n3_res)
);

//////////////////////Adders level 2////////////////////////
/////////first adder
qadd SUM2n0 (
.a(MULT1n0_res),
.b(Qn_0),
.c(SUM2n0_res)
);

/////////second adder
qadd SUM2n1 (
.a(MULT1n1_res),
.b(Qn_1),
.c(SUM2n1_res)
);

/////////third adder
qadd SUM2n2 (
.a(MULT1n2_res),
.b(Qn_2),
.c(SUM2n2_res)
);

/////////fourth adder
qadd SUM2n3 (
.a(MULT1n3_res),
.b(Qn_3),
.c(SUM2n3_res)
);

// sequential registers for storing Q(n,z)_k
always@(posedge CLK,negedge RST)
begin
	if(!RST)
	begin
		REGn0 <= 0;
		REGn1 <= 0;
		REGn2 <= 0;
		REGn3 <= 0;
	end
	
	else
	begin
		case(u)
			4'b0001: begin
				REGn0 <= SUM2n0_res;				
			end
			4'b0010: begin
				REGn1 <= SUM2n1_res;				
			end
			4'b0100: begin
				REGn2 <= SUM2n2_res;				
			end
			4'b1000: begin
				REGn3 <= SUM2n3_res;				
			end
		endcase
	end
end

assign Qn_0 = REGn0;
assign Qn_1 = REGn1;
assign Qn_2 = REGn2;
assign Qn_3 = REGn3;


// combinational comparator: returns the maximum stored Qn_z
always@(*)
begin
	if ((Qn_0>Qn_1)&&(Qn_0>Qn_2)&&(Qn_0>Qn_3))	//	if Qn_0 is the beggist?:max 
		maxQ_n = Qn_0;                          // 	not? Qn_0 insignificant
												
	else if ((Qn_1>Qn_2)&&(Qn_1>Qn_3))          //	if Qn_1 is the beggist?:max
		maxQ_n = Qn_1;                          // 	not? Qn_1 insignificant
												
	else if ((Qn_2>Qn_3))                       //	if Qn_2 is the beggist?:max
		maxQ_n = Qn_2;                          // 	not? Qn_2 insignificant
												
	else                                        //	if Qn_3 is the beggist?:max
		maxQ_n = Qn_3;                          // 	not? Qn_3 insignificant

end

endmodule
