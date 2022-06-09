module PAT(clk, reset, data, flag);
	
	input clk, reset, data;
	output flag;
	
	parameter S0 = 4'b0000;
	parameter S1 = 4'b0001;
	parameter S2 = 4'b0010;
	parameter S3 = 4'b0011;
	parameter S4 = 4'b0100;
	parameter S5 = 4'b0101;
	parameter S6 = 4'b0110;
	parameter S7 = 4'b0111;
	parameter S8 = 4'b1000;
	reg[3:0] cur, next;
	
	assign flag = (cur == S8) ? 1 : 0;
	
	always@(posedge clk)
	begin
		if(reset) 
			cur <= S0;
		else
			cur <= next;
	end
	
	always@(cur, data)
	begin
		case(cur)
			S0:
			begin
				if(data == 0)
					next = S1;
				else if(data == 1)
					next = S0;
			end
			S1:
			begin
				if(data == 0)
					next = S2;
				else if(data == 1)
					next = S0;
			end
			S2:
			begin
				if(data == 0)
					next = S2;
				else if(data == 1)
					next = S3;
			end
			S3:
			begin
				if(data == 0)
					next = S1;
				else if(data == 1)
					next = S4;
			end
			S4:
			begin
				if(data == 0)
					next = S5;
				else if(data == 1)
					next = S0;
			end
			S5:
			begin
				if(data == 0)
					next = S2;
				else if(data == 1)
					next = S6;
			end
			S6:
			begin
				if(data == 0)
					next = S1;
				else if(data == 1)
					next = S7;
			end
			S7:
			begin
				if(data == 0)
					next = S5;
				else if(data == 1)
					next = S8;
			end
			S8:
			begin
				if(data == 0)
					next = S1;
				else if(data == 1)
					next = S0;
			end
			default
				next = S0;
		endcase
	end
endmodule
