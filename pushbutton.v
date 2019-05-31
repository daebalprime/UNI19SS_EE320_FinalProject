module pushbutton (clk,resetn,pushn,push);
	input clk;
	input resetn;
	input pushn;
	output push;
	reg  push_buf_a1, push_buf_a2; 
	reg  push_sig_a;
	wire push_buf_a;
	
	always @(posedge clk or negedge resetn) begin
		
		if (!resetn) begin
			push_buf_a1 <= 0;
			push_buf_a2 <= 1;
			
		end
		else begin
			if (!pushn) push_buf_a1 <= 1;
			else push_buf_a1 <= 0;
			
			if (push_buf_a1) push_buf_a2 <= 0;
			else push_buf_a2 <= 1;
			

		end
	end
	
	// toggle input
	always @(posedge clk or negedge resetn) begin
	
		if (!resetn) push_sig_a <= 0;
		else if (push_buf_a) push_sig_a <= !push_sig_a;
		else push_sig_a <= push_sig_a;
		
		
	end
	
	assign push_buf_a = push_buf_a1 & push_buf_a2;
	assign push = push_sig_a;
endmodule

	