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
// Module Name:    qadd 
// Design Name:    Q_Learining_SON
// Engineers:	   Hatem El Shorbagy
//
//////////////////////////////////////////////////////////////////////////////////
//discription:
// The qadd module performs fixed-point addition or subtraction based on the input signals a and b.
// It supports configurable parameters for the number of fractional bits (Q) and the total number of bits (N) in the fixed-point values.
// The module outputs the result of the addition/subtraction (c), where the sign bit indicates the sign of the result.
// The module uses a register (res) to hold the result, which is assigned to the output signal c.
// The addition/subtraction is determined based on the sign bits of the operands.
// If both operands have the same sign, their absolute values are added, and the sign of either operand is used for the result.
// If one operand is negative and the other is positive, subtraction is performed by taking the absolute difference.
// If one operand is negative and the other is positive, the subtraction is performed based on the magnitude of the operands.
// The result is then stored in the register res, and the output signal c is updated accordingly.
// The module operates on fixed-point values with the assumption that both operands have the same length (N,Q).
//////////////////////////////////////////////////////////////////////////////////


module qadd #(
							//Parameterized values
	parameter Q = 9,		//number of fractional bits
	parameter N = 14		//total number of bits
	)
	(
    input [N-1:0] 	a,
    input [N-1:0] 	b,
    output [N-1:0] 	c
    );

reg [N-1:0] res;			//holds the result of the addition

assign c = res;

always @(a,b) begin
    // Check the sign bits to determine the type of addition/subtraction to perform
	// both negative or both positive
	if(a[N-1] == b[N-1]) begin									//		Since they have the same sign, absolute magnitude increases
		res[N-2:0] = a[N-2:0] + b[N-2:0];			   		 	//		So we just add the two numbers
		res[N-1] = a[N-1];										//		and set the sign appropriately...  Doesn't matter which one we use, 
																//		they both have the same sign
																//		Do the sign last, on the off-chance there was an overflow...  
		end														//		Not doing any error checking on this...
	//	one of them is negative...
	else if(a[N-1] == 0 && b[N-1] == 1) begin					//		subtract a-b
		if( a[N-2:0] > b[N-2:0] ) begin							//		if a is greater than b,
			res[N-2:0] = a[N-2:0] - b[N-2:0];					//		then just subtract b from a
			res[N-1] = 0;										//		and manually set the sign to positive
			end
		else begin												//		if a is less than b,
			res[N-2:0] = b[N-2:0] - a[N-2:0];					//		we'll actually subtract a from b to avoid a 2's complement answer
			if (res[N-2:0] == 0)
				res[N-1] = 0;									//		I don't like negative zero....
			else
				res[N-1] = 1;									//		and manually set the sign to negative
			end
		end
	else begin													//		subtract b-a (a negative, b positive)
		if( a[N-2:0] > b[N-2:0] ) begin							//		if a is greater than b,
			res[N-2:0] = a[N-2:0] - b[N-2:0];					//		we'll actually subtract b from a to avoid a 2's complement answer
			if (res[N-2:0] == 0)
				res[N-1] = 0;									//		I don't like negative zero....
			else
				res[N-1] = 1;									//		and manually set the sign to negative
			end
		else begin												//		if a is less than b,
			res[N-2:0] = b[N-2:0] - a[N-2:0];					//		then just subtract a from b
			res[N-1] = 0;										//		and manually set the sign to positive
			end
		end
	end
endmodule
