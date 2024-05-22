module coin ( input Clk, Reset,
					input frame_clk,  
					input [19:0] random_num,
					input [9:0]   DrawX, DrawY,      
					input [1:0] game_state,
					input coin1_collected, coin2_collected,
					output logic  is_coin,
					output logic [18:0] c_addr,
					output logic [9:0] coin1_X_Pos, coin1_Y_Pos, coin2_X_Pos,coin2_Y_Pos
					);	                                                                                                                                                                                
					
    
    logic [9:0] coin1_X_Pos_in;
	 logic [9:0] coin2_X_Pos_in;
	 logic [9:0] coin1_Y_Pos_in;
	 logic [9:0] coin2_Y_Pos_in;
//	 logic [9:0] coin1_X_Pos, coin1_Y_Pos, coin2_X_Pos,coin2_Y_Pos;


	 
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end

	 
	 initial begin
      coin1_X_Pos <= 597;
		coin2_X_Pos <= 782;
		coin1_Y_Pos <= random_num;
		coin2_Y_Pos <= random_num-50;

    end
	 
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            coin1_X_Pos <= 597;
				coin2_X_Pos <= 782;
				coin1_Y_Pos <= random_num;
				coin2_Y_Pos <= random_num-50;

        end
        else
        begin
            coin1_X_Pos <= coin1_X_Pos_in;
				coin2_X_Pos <= coin2_X_Pos_in;
				coin1_Y_Pos <= coin1_Y_Pos_in;
				coin2_Y_Pos <= coin2_Y_Pos_in;
        end
		  
    end
 

			
    always_comb
		begin
			coin1_X_Pos_in = coin1_X_Pos;
			coin2_X_Pos_in = coin2_X_Pos;
			coin1_Y_Pos_in = coin1_Y_Pos;
			coin2_Y_Pos_in = coin2_Y_Pos;
//			random1_in = random1;
//			random2_in = random2;
			   if (frame_clk_rising_edge) begin
				case (game_state)
						 2'd1: begin
								if (coin1_X_Pos<= 10'd144) begin
									coin1_Y_Pos_in = random_num;
									coin1_X_Pos_in = 524;
								end else begin
									coin1_X_Pos_in = coin1_X_Pos - 10'd1;
								end
								
								if (coin2_X_Pos <= 10'd144) begin
									coin2_Y_Pos_in = random_num;
									coin2_X_Pos_in = 524;
								end else begin
									coin2_X_Pos_in = coin2_X_Pos - 10'd1;
								end
							
						 end

						 2'd2: begin
							  coin1_X_Pos_in = coin1_X_Pos;
							  coin2_X_Pos_in = coin2_X_Pos;
						 end

						 2'd0: begin
							  coin1_X_Pos_in = 597;
							  coin2_X_Pos_in = 782;
						 end

						 default: begin
							  coin1_X_Pos_in = coin1_X_Pos;
							  coin2_X_Pos_in = coin2_X_Pos;
						 end
					endcase

					
					end
				
				
				
		  end

    
    // Compute whether the pixel corresponds to pipe or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX1, DistX2, DistY1, DistY2, ran1, ran2;
    assign DistX1 = DrawX - coin1_X_Pos;
	 assign DistX2 = DrawX - coin2_X_Pos;
    assign DistY1 = DrawY - coin1_Y_Pos ;
	 assign DistY2 = DrawY - coin2_Y_Pos ;
//	 assign ran1 = random1;
//	 assign ran2 = random2;
	 
	 parameter [9:0] width_p_e = 10'd60;

	
    always_comb begin

        if ( (DistX1 < 16 && DistX1 >= 0) &&  (DistY1 < 16 && DistY1 >= 0) &&(!coin1_collected)) begin
            is_coin = 1'b1;
				c_addr = DistX1+DistY1*16;
			end
		else if ( (DistX2 < 16 && DistX2 >= 0) &&  (DistY2 < 16 && DistY2 >= 0) &&(!coin2_collected)) begin
            is_coin = 1'b1;
				c_addr = DistX2+DistY2*16;
		  end
        else begin
            is_coin = 1'b0;
				c_addr = 0;
			end
				
		 
    end
	 
endmodule