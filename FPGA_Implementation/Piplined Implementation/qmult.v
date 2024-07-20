//////////////////////////////////////////////////////////////////////////////////
//	
//								Tanta University
//						   	 Faculty of Engineering
//		Electronics and Electrical Communications Engineering Department
//
//////////////////////////////////////////////////////////////////////////////////
//
// Project Name: 	Meeting 5G Latency Requirements in Cell Outage Compensation (COC) 
//               	in Self Organizing Networks (SONs) using Hardware Acceleration.
//
// Create Date:    03/Feb/2023 
// Module Name:    qmult 
// Design Name:    Q_Learining_SON
// Engineers:	   Hatem El Shorbagy
//
//////////////////////////////////////////////////////////////////////////////////
//discription:
// The qmult module performs a fixed-point multiplication operation on the input signals i_multiplicand and i_multiplier.
// It supports configurable parameters for the number of fractional bits (Q) and the total number of bits (N) in the fixed-point values.
// The module outputs the result of the multiplication (o_result) and an overflow flag (ovr) indicating whether an overflow occurred.
// The module uses two registers, r_result and r_RetVal, to hold intermediate and final results of the multiplication.
// The multiplication is performed whenever the inputs change, and the sign bit, result bits, and overflow flag are updated accordingly.
// The module utilizes bitwise operations, such as XOR (^) and slicing ([N-2+Q:Q]), to compute the sign bit and extract the desired bits from the result.
// The output signal o_result is assigned the value of r_RetVal, and the overflow flag ovr is reset to zero by default.
// The module operates on fixed-point values with the assumption that both multiplicand and multiplier have the same length (N,Q).
// The final result size is 2N bits, and the binary point location remains the same.
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
module qmult #(
							//Parameterized values
	parameter Q = 9,		//number of fractional bits
	parameter N = 14		//total number of bits
	)
	(
	 input			[N-1:0]	i_multiplicand,
	 input			[N-1:0]	i_multiplier,
	 output			[N-1:0]	o_result,
	 output	reg				ovr
	 );
	 
	 //		The underlying assumption, here, is that both fixed-point values are of the same length (N,Q)
	 //		Because of this, the results will be of length N+N = 2N bits....
	 //		This also simplifies the hand-back of results, as the binimal point 
	 //		will always be in the same location...
	
	reg [2*N-1:0]	r_result;		//	Multiplication by 2 values of N bits requires a 
									//	register that is N+N = 2N deep...
	reg [N-1:0]		r_RetVal;
	
//--------------------------------------------------------------------------------
	assign o_result = r_RetVal;		//	Only handing back the same number of bits as we received...
									//	with fixed point in same location...
	
//---------------------------------------------------------------------------------
	always @(i_multiplicand, i_multiplier)	begin							//	Do the multiply any time the inputs change
																			//  Multiply the multiplicand and multiplier, excluding the sign bits
		r_result <= i_multiplicand[N-2:0] * i_multiplier[N-2:0];			//	Removing the sign bits from the multiply 
																			//	would introduce *big* errors	
		ovr <= 1'b0;														//	reset overflow flag to zero
		
		r_RetVal[N-1] <= i_multiplicand[N-1] ^ i_multiplier[N-1];			//	which is the XOR of the input sign bits...  (you do the truth table...)
		r_RetVal[N-2:0] <= r_result[N-2+Q:Q];								//	And we also need to push the proper N bits of result up to 
																			//	the calling entity...
		if (r_result[2*N-2:N-1+Q] > 0)										//  And finally, we need to check for an overflow
		ovr <= 1'b1;
			
		end
	
	
endmodule
