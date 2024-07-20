module Mux (
input	wire	[2:0] 	S_to_EN,
input   wire    [23:0] 	Max_Q0, Max_Q1, Max_Q2, Max_Q3, Max_Q4, Max_Q5,
input	wire	[23:0]	Gamma,


//outs
output	wire    [23:0] 	gamma_maxQ			//to all EN blocks
);

reg [23:0]Max_Q;

mul_2414f U_gamma_mult(
.A		(Gamma),
.B      (Max_Q),
.Result (gamma_maxQ)
);

always@(*)
begin
	case (S_to_EN)
		3'b000: 
		Max_Q = Max_Q0;
		
		3'b001: 
		Max_Q = Max_Q1;
		
		3'b010: 
		Max_Q = Max_Q2;
		
		3'b011: 
		Max_Q = Max_Q3;
		
		3'b100: 
		Max_Q = Max_Q4;
		
		3'b101: 
		Max_Q = Max_Q5;
	
	default:
		Max_Q = Max_Q0;	
		
	endcase	
	
end

endmodule