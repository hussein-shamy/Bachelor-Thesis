module maxQmem
(
input	wire			CLK,
input	wire	[13:0]	Qn,
input	wire	[2:0]	Sn,SnP1,
output	reg		[13:0]	maxQn_SnP1
);

//internal memory >> maxQn memory
reg		[13:0]	maxQn_Sn_stored	[6:0];

//loop variable for initialization
integer i;

//initialization to clear all memory elements
initial
begin
	for(i=0; i<7; i=i+1)
	begin
		maxQn_Sn_stored[i] = 'b0;
	end
end

//behavioural discription of module's function
always@(posedge CLK)
begin
	if(Qn > maxQn_Sn_stored[Sn])
	begin
		maxQn_Sn_stored[Sn] <= Qn;			//	simultaneously check if the cuurrent Q-value is larger than the stored maximum
	end                                     //	if so store it as the new maximum with the CLK edge
	maxQn_SnP1 <= maxQn_Sn_stored[SnP1];    //	while outputting the maximum of the future state
end

endmodule