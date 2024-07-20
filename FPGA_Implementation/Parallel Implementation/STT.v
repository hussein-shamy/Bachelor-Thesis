module STT #(parameter width = 3 ,parameter depth = 24)(
input	wire	CLK,RST,
input	wire	[$clog2(depth)-1: 0] addr,	// mapping .addr({S_to_EN,Action})
//number of addresses equals (NxZ)=24 ,requires (n+z)=5 bits, using $clog2(NxZ)

//outs

output	reg		S_to_EN			//to all EN blocks

);
reg		S_to_MUX;
reg [width-1 : 0] memory [depth-1: 0];

always@(posedge CLK,negedge RST)
begin
    S_to_MUX<=0;
	S_to_EN<=0;
	if(!RST)
	begin
		//state 0
		memory[5'b000_00] <= 3'b000;
		memory[5'b000_01] <= 3'b011;
		memory[5'b000_10] <= 3'b000;
		memory[5'b000_11] <= 3'b001;
		
		//state 1
		memory[5'b001_00] <= 3'b000;
		memory[5'b001_01] <= 3'b100;
		memory[5'b001_10] <= 3'b000;
		memory[5'b001_11] <= 3'b010;
		
		//state 2
		memory[5'b010_00] <= 3'b000;
		memory[5'b010_01] <= 3'b101;
		memory[5'b010_10] <= 3'b001;
		memory[5'b010_11] <= 3'b000;
		
		//state 3
		memory[5'b011_00] <= 3'b000;
		memory[5'b011_01] <= 3'b000;	
		memory[5'b011_10] <= 3'b000;
		memory[5'b011_11] <= 3'b100;
		
		//state 4
		memory[5'b100_00] <= 3'b001;
		memory[5'b100_01] <= 3'b000;
		memory[5'b100_10] <= 3'b011;
		memory[5'b100_11] <= 3'b101;
		
		//state 5
		memory[5'b101_00] <= 3'b010;
		memory[5'b101_01] <= 3'b000;
		memory[5'b101_10] <= 3'b100;
		memory[5'b101_11] <= 3'b000;
	end
	
	else 
	begin
		S_to_EN <= memory[addr];
		S_to_MUX <=S_to_EN;
	end
	
end

endmodule