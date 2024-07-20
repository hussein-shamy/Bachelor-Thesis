module UnitDelay	#(parameter WIDTH = 8)
(
input	wire	CLK,RST,
input	wire	[WIDTH-1 : 0]	data_in,
output	reg		[WIDTH-1 : 0]	data_out
);

always@(posedge CLK,negedge RST)
begin
	if(!RST)
	begin
		data_out <= 'b0;
	end
	
	else
	begin
		data_out <= data_in;
	end
end
endmodule