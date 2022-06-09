module CLA_4bit(A, B, Cin, S, Cout);
	
	parameter n = 4;
	input [n - 1: 0] A, B;
	input Cin;
	
	output [n - 1: 0] S;
	output Cout;

	wire [3:0] G,P,C;
	
  	assign G = A & B;
	
  	assign P = A ^ B;
	
  	assign C[0] = Cin;
  	assign C[1] = G[0] | (P[0] & C[0]);
  	assign C[2] = G[1] | (P[1] & C[1]);
  	assign C[3] = G[2] | (P[2] & C[2]);
	
  	assign Cout = G[3] | (P[3] & C[3]);
  	assign S = A ^ B ^ C;

endmodule


module Adder_16bit(A, B, Cin, S, Cout);

	parameter n = 16;
	parameter m = 4;

	input [n - 1: 0] A, B;
	input Cin;
	
	output [n - 1: 0] S;
	output Cout;
	
	wire C4, C8, C12;
	wire [m - 1: 0] S0_3, S4_7, S8_11, S12_15;
	assign S = {S12_15, S8_11, S4_7, S0_3};
	
	CLA_4bit cla0(A[3:0], B[3:0], Cin, S0_3, C4);
	CLA_4bit cla1(A[7:4], B[7:4], C4, S4_7, C8);
	CLA_4bit cla2(A[11:8], B[11:8], C8, S8_11, C12);
	CLA_4bit cla3(A[15:12], B[15:12], C12, S12_15, Cout);
	
endmodule


module ALU(A, B, Cin, Mode, Y, Cout, Overflow);

	parameter n = 16;
	parameter m = 4;
	
	input [n - 1: 0] A, B;
	input Cin;
	input [m - 1: 0] Mode;	
	
	output reg [n - 1: 0] Y;
	output reg Cout;
	output reg Overflow;
	
	wire [n - 1:0] Y_Add;
	wire [n - 1:0] Y_Sub;
	wire Cout_Add;
	wire Cout_Sub;
	Adder_16bit add(A, B, Cin, Y_Add, Cout_Add);
	Adder_16bit sub(A, (~B)+1'b1, Cin, Y_Sub, Cout_Sub);
	
	always@(*)begin
		case(Mode)
			//Logical shift A left by 1-bit.
			4'd0: begin
			Y = A << 1'b1;
			Cout = 1'b0;
			Overflow = 1'b0;
			end
			//Arithmetic shift A left by 1-bit.
			4'd1: begin
			Y = A <<< 1'b1;
			Cout = 1'b0;
			Overflow = 1'b0;
			end
			//Logical shift A right by 1-bit.
			4'd2: begin
			Y = A >> 1'b1;
			Cout = 1'b0;
			Overflow = 1'b0;
			end
			//Arithmetic shift A right by 1-bit.
			4'd3: begin
			Y = A >>> 1'b1;
			Y[15] = A[15];
			Cout = 1'b0;
			Overflow = 1'b0;
			end
			//Add two numbers with cla.
			4'd4: begin
			Y = Y_Add;
			Cout = Cout_Add;
			Overflow = (~A[15] & ~B[15] & Y[15]) | (A[15] & B[15] & ~Y[15]);
			end
			//Subtract B from A.
			4'd5: begin
			Y = Y_Sub;
			Cout = Cout_Sub;
			Overflow = (~A[15] & B[15] & Y[15]) | (A[15] & ~B[15] & ~Y[15]);
			end
			//and
			4'd6: begin
			Y = A & B;
			Cout = 1'b0;
			Overflow = 1'b0;
			end
			//or
			4'd7: begin
			Y = A | B;
			Cout = 1'b0;
			Overflow = 1'b0;
			end
			//not A
			4'd8: begin
			Y = ~A;
			Cout = 1'b0;
			Overflow = 1'b0;
			end
			//xor
			4'd9: begin
			Y = A ^ B;
			Cout = 1'b0;
			Overflow = 1'b0;
			end
			//xnor
			4'd10: begin
			Y = ~(A ^ B);
			Cout = 1'b0;
			Overflow = 1'b0;
			end
			//nor
			4'd11: begin
			Y = ~(A | B);
			Cout = 1'b0;
			Overflow = 1'b0;
			end
			//binary to one-hot
			4'd12: begin
			Y = 16'b1 << A[3:0];
			Cout = 1'b0;
			Overflow = 1'b0;
			end
			//A
			4'd13: begin
			Y = A;
			Cout = 1'b0;
			Overflow = 1'b0;
			end
			//B
			4'd14: begin
			Y = B;
			Cout = 1'b0;
			Overflow = 1'b0;
			end
			//find first one from left
			4'd15: begin
			if(A[15] == 1)
				Y = 4'd15;
			else if(A[14] == 1)
				Y = 4'd14;
			else if(A[13] == 1)
				Y = 4'd13;
			else if(A[12] == 1)
				Y = 4'd12;
			else if(A[11] == 1)
				Y = 4'd11;
			else if(A[10] == 1)
				Y = 4'd10;
			else if(A[9] == 1)
				Y = 4'd9;
			else if(A[8] == 1)
				Y = 4'd8;
			else if(A[7] == 1)
				Y = 4'd7;
			else if(A[6] == 1)
				Y = 4'd6;
			else if(A[5] == 1)
				Y = 4'd5;
			else if(A[4] == 1)
				Y = 4'd4;
			else if(A[3] == 1)
				Y = 4'd3;
			else if(A[2] == 1)
				Y = 4'd2;
			else if(A[1] == 1)
				Y = 4'd1;
			else if(A[0] == 1)
				Y = 4'd0;
			Cout = 1'b0;
			Overflow = 1'b0;
			end
			default: begin
			Y = 1'b0;
			Cout = 1'b0;
			Overflow = 1'b0;
			end
		endcase
	end
	
endmodule


















