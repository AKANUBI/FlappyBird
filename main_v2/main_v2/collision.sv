module collision(input  Clk,                // 50 MHz clock
								Reset,              // Active-high reset signal
					  input  is_ball, is_pipe, is_pipe_edge,
					  output logic  collision       
					  );	
					  
	always_ff @ (posedge Clk)
	begin
		if (Reset == 1'b1)
			collision <= 1'b0;
		else// if ((frame_clk_rising_edge == 1'b1))
			begin
				if ((is_ball == 1'b1 && is_pipe == 1'b1) || (is_ball == 1'b1 && is_pipe_edge == 1'b1))
					begin
						collision <= 1'b1;
					end
				else
					collision <= 1'b0;
			end
	end		
endmodule
