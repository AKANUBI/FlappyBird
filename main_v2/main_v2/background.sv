module background (
    input         Clk,                // 50 MHz clock
    input         Reset,              // Active-high reset signal
    input         frame_clk,          // The clock indicating a new frame (~60Hz)
    input [9:0]   DrawX, DrawY,       // Current pixel coordinates
	 input is_ball,
	 input is_pipe,
    output logic  is_bg,
	 output logic [18:0]   bg_addr
	 
);

	 
	 
	 always_comb begin
        if ((!is_ball) && (!is_pipe)) begin
            is_bg = 1'b1;
				bg_addr = (DrawX-160)+DrawY*320; //0-440
			end

        else begin
            is_bg = 1'b0;
				bg_addr = (DrawX-160)+DrawY*320; //0-440
			end

    end
	 
endmodule