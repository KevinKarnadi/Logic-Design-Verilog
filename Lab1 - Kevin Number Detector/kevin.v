module kevin_G(in, out);

	input [3:0]in;
	output out;
	
	wire notA, notB, notC, notD;
	wire and1, and2, and3, and4, and5;
	
	not not_1(notA, in[3]);
	not not_2(notB, in[2]);
	not not_3(notC, in[1]);
	not not_4(notD, in[0]);
	
	and and_1(and1, notB, notC, in[0]);
	and and_2(and2, in[3], in[2], notD);
	and and_3(and3, notA, in[2], in[0]);
	and and_4(and4, notA, in[2], in[1]);
	and and_5(and5, in[3], in[1], notD);
	
	or or_1(out, and1, and2, and3, and4, and5);

endmodule


module kevin_D(in, out);

	input [3:0]in;
	output out;
	
	assign out = (!in[2]&!in[1]&in[0]) | 
				 (in[3]&in[2]&!in[0])  | 
				 (!in[3]&in[2]&in[0])  | 
				 (!in[3]&in[2]&in[1])  | 
				 (in[3]&in[1]&!in[0]);

endmodule


module kevin_B(in, out);

	input [3:0]in;
	output out;
	
	reg out;
	
	always@(*)begin
		out=1'b0;
		case(in)
			1,5,6,7,9,10,12,14:begin
				out=1'b1;
			end
		endcase
	end

endmodule