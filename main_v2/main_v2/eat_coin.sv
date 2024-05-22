module eat_coin (
    input Clk,
    input Reset,
    input frame_clk,
    input [9:0] Ball_X_Pos, Ball_Y_Pos, // 小球的中心坐标
    input [9:0] coin1_X_Pos, coin1_Y_Pos,  // 硬币1的坐标
    input [9:0] coin2_X_Pos, coin2_Y_Pos,  // 硬币2的坐标
	 input [1:0] game_state,
    output logic [6:0] score2,              // 游戏分数
	 output logic coin1_collected, coin2_collected
);

    parameter [9:0] Coin_Size = 16; // 硬币大小（假设是10x10像素）
//    logic coin1_collected, coin2_collected;
	 logic coin1_collected_in, coin2_collected_in;
	 logic [6:0] score2_in;

    initial begin
        score2 = 0;
        coin1_collected = 0;
        coin2_collected = 0;
    end

    always_ff @ (posedge Clk) begin
        if (Reset) begin
            score2 <= 0;
            coin1_collected <= 0;
            coin2_collected <= 0;
        end else begin
            score2 <= score2_in;
            coin1_collected <= coin1_collected_in;
            coin2_collected <= coin2_collected_in;
        end
    end
	 
	 
	 
	 always_comb begin
			case (game_state)
			2'd1: begin		
            coin1_collected_in = coin1_collected;
            coin2_collected_in = coin2_collected;
				score2_in = score2;
				if (!coin1_collected && ((coin1_X_Pos-Ball_X_Pos)*(coin1_X_Pos-Ball_X_Pos)+(coin1_Y_Pos-Ball_Y_Pos)*(coin1_Y_Pos-Ball_Y_Pos)<=100)) begin
                score2_in = score2+1;
                coin1_collected_in= 1;
            end
            if (!coin2_collected && ((coin2_X_Pos-Ball_X_Pos)*(coin2_X_Pos-Ball_X_Pos)+(coin2_Y_Pos-Ball_Y_Pos)*(coin2_Y_Pos-Ball_Y_Pos)<=100)) begin
                score2_in = score2+1;
                coin2_collected_in = 1;
            end
				if(coin1_X_Pos<=144) begin
					coin1_collected_in = 0;
				end
				if(coin2_X_Pos<=144) begin
					coin2_collected_in = 0;
				end
			end 
			 2'd2: begin
				 coin1_collected_in = coin1_collected;
				 coin2_collected_in = coin2_collected;
				 score2_in =score2;
			 end
					
			 2'd0: begin
				coin1_collected_in = 0;
            coin2_collected_in = 0;
				score2_in =0;
			 end
			 
			 default: begin
				 coin1_collected_in = coin1_collected;
				 coin2_collected_in = coin2_collected;
				 score2_in =score2;
			 end
			 
			
				
			endcase
	 end
endmodule
