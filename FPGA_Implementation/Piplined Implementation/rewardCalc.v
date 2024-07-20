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
// Create Date:    06/Jun/2023 
// Module Name:    rewardCalc
// Design Name:    Q_Learining_SON
// Engineers:	   Mohamed Helal
//
//////////////////////////////////////////////////////////////////////////////////
//discription:
// This module is a comparator of states,  
// if the current state is larger in number than the previous >> larger in connected users >> +6
// if the current state is equal in number with the previous >> same in connected users >> +2
// if the current state is smaller in number with the previous >> smaller in connected users >> -2
//////////////////////////////////////////////////////////////////////////////////

module rewardCalc
(
	input	wire			CLK,RST,
	input	wire	[2:0]	S_current,
	output	reg		[13:0]	rewardOut
);

//internal signals
reg		[2:0]		S_previous;

//Unit delay FFs
always@(posedge CLK, negedge  RST)
begin
	if(!RST)
	begin
		S_previous <= 3'b000;
		rewardOut  <= 'b0;
	end
	
	else
	begin
		S_previous <= S_current;
		if (S_current>S_previous)
		begin
			rewardOut <= 14'b0_0110_000000000;		//note : we want the integer part to be 5 bits
		end
		
		else if (S_current==S_previous)
		begin
			rewardOut <= 14'b0_0010_000000000;
		end
		
		else
		begin
			rewardOut <= 14'b1_0010_000000000;
		end
	end
end

endmodule