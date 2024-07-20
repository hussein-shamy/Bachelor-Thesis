module EN #(parameter N=3'b000)(
input [3:0] s,
input [1:0] a,
output reg [3:0] u
);

always @(*)
begin

 if(s==N)
 begin
  case(a)
 2'b00:  u=4'b0001;

 2'b01:  u=4'b0010;

 2'b10:  u=4'b0100;

 2'b11:  u=1000;
endcase
 end


 		else
 		u=4'b0000;
end



endmodule